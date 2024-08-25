{ userSettings, ... }: 

{
  virtualisation.docker.enable = true;

  users.users.${userSettings.userName}.extraGroups = [ "docker" ];
}
