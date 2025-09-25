/// @description Insert description here
// You can write your code in this editor
global.CONFIGS = {
	rewind_key: ord("R"),
	rewind_speed: 2
}


rewind_array = [];
maximum_time_in_seconds = 60;
max_array_size = maximum_time_in_seconds * room_speed;
rewinding = false;
rewind_timer = 0;

global.isRewinding = function() {
	return rewinding;	
}

global.rewind_data = {
	state: [],
	settings: {}
};