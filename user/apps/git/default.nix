{ userSettings, ... }:

{
	programs.git = {
		enable = true;
		userName = userSettings.name;
		userEmail = userSettings.email;
	};
}
