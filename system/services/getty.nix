{ userSettings, ... }:

{
  # Enable automatic login for the user.
  services.getty.autologinUser = userSettings.userName;
}
