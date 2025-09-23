/// @description Insert description here
// You can write your code in this editor
if(instance_exists(obj_load_buffer)) {
	if (file_exists("save.txt")) {
		GameInitialize();
		LoadGame2();	
		global.game_started = true;
	}
	
	with (obj_load_buffer) {
		instance_destroy();	
	}
}