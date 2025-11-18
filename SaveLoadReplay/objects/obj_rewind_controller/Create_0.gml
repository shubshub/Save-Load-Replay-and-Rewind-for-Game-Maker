/// @description Insert description here
// You can write your code in this editor
global.CONFIGS = {
	rewind_key: ord("R"),
	rewind_speed: 2,
	rewind_time_seconds: 60
}


rewind_array = [];
max_array_size = global.CONFIGS.rewind_time_seconds * room_speed;
rewinding = false;
rewind_timer = 0;

global.isRewinding = function() {
	return rewinding;	
}

global.rewind_data = {
	state: [],
	settings: {}
};