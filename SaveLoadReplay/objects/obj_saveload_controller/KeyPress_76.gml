/// @description Insert description here
// You can write your code in this editor
show_debug_message("Checking for Load Buffer");

	//if (file_exists("saveload.txt")) {
		show_debug_message("Game Loaded");
		GameInitialize();
		LoadGame2();	
		global.game_started = true;
	//}
	
	with (obj_load_buffer) {
		instance_destroy();	
	}