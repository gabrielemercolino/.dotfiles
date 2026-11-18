-- Work around the SN6140 occasionally retaining the unavailable internal mic
-- after the analog duplex profile has selected the headset route.
local cutils = require ("common-utils")
local log = Log.open_topic ("mini-pc-headset")
local pending, attempted, generation = nil, false, 0
local card = "alsa_card.pci-0000_74_00.6"
local duplex = "output:analog-stereo+input:analog-stereo"

local function target (device)
  return device and device.properties["device.name"] == card and
      device.properties["alsa.components"] == "HDA:14f11f87,14f10362,00100100"
end

local function snapshot (device)
  local profile, internal, external, active
  for p in device:iterate_params ("Profile") do
    profile = cutils.parseParam (p, "Profile")
  end
  for p in device:iterate_params ("EnumRoute") do
    local r = cutils.parseParam (p, "EnumRoute")
    if r and r.direction == "Input" and r.devices and cutils.arrayContains (r.devices, 0) then
      if r.name == "analog-input-internal-mic" then internal = r end
      if r.name == "analog-input-mic" then external = r end
    end
  end
  for p in device:iterate_params ("Route") do
    local r = cutils.parseParam (p, "Route")
    if r and r.device == 0 and r.direction == "Input" then active = r end
  end
  if not profile or profile.name ~= duplex or not internal or not external or
      not external.profiles or not cutils.arrayContains (external.profiles, profile.index) or
      external.available ~= "yes" or internal.available ~= "no" then
    return nil
  end
  return internal, external, active
end

local function set_route (device, index)
  device:set_param ("Route", Pod.Object {
    "Spa:Pod:Object:Param:Route", "Route",
    index = index, device = 0, save = false,
  })
end

SimpleEventHook {
  name = "mini-pc/headset-reset",
  interests = {
    EventInterest { Constraint { "event.type", "=", "device-removed" } },
    EventInterest {
      Constraint { "event.type", "=", "device-params-changed" },
      Constraint { "event.subject.param-id", "c", "EnumRoute" },
    },
  },
  execute = function (event)
    local device = event:get_subject ()
    if not target (device) then return end
    if event:get_properties ()["event.type"] == "device-removed" or not snapshot (device) then
      generation = generation + 1
      attempted = false
      if pending then pending:destroy (); pending = nil end
    end
  end,
}:register ()

SimpleEventHook {
  name = "mini-pc/headset-retry",
  after = "device/apply-routes",
  interests = { EventInterest { Constraint { "event.type", "=", "select-routes" } } },
  execute = function (event)
    local device = event:get_subject ()
    if not target (device) then return end
    local internal, external = snapshot (device)
    if not internal then return end
    local selected = event:get_data ("selected-routes")
    local route = selected and selected["0"]
    route = route and Json.Raw (route):parse ()
    if not route or route.index ~= external.index or attempted then return end

    if pending then pending:destroy () end
    local token = generation
    pending = Core.timeout_add (1500, function ()
      pending = nil
      if token ~= generation or attempted then return end
      local old, desired, active = snapshot (device)
      if not old or not active or active.index ~= old.index then return end
      attempted = true
      log:notice (device, "Retrying stuck headset input route once")
      -- Re-select the current route first; selecting the headset alone can be ignored.
      set_route (device, old.index)
      Core.sync (function ()
        if token ~= generation then return end
        local current_old, current_desired, current = snapshot (device)
        if current_old and current and current.index == current_old.index and
            current_desired.index == desired.index then
          set_route (device, current_desired.index)
        end
      end)
    end)
  end,
}:register ()
