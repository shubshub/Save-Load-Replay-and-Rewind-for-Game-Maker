/// @description Insert description here
// You can write your code in this editor
if (!global.game_started) {
	exit;	
}
if (keyboard_check_pressed(global.CONFIGS.rewind_key)) {
	show_debug_message("Begin Rewinding");	
}

if (keyboard_check_released(global.CONFIGS.rewind_key)) {
	show_debug_message("End Rewinding");	
}

if (keyboard_check(global.CONFIGS.rewind_key)) {
	rewinding = true;	
} else {
	rewinding = false;	
}


if (!rewinding) {

	var saveable = tag_get_asset_ids("saveable", asset_object);
	//show_debug_message("Saveable: " + string(array_length(saveable)));
	for (var i = 0; i < array_length(saveable); i++) {
		with(saveable[i]) {
			DirtyChecker(game_state_id, self);	
		}
	}
	
	var rewind_entry = variable_clone(GetRewindData());
	//show_debug_message("Rewind Entry: " + string(rewind_entry));
	array_insert(rewind_array, 0, rewind_entry);
	if (array_length(rewind_array) > max_array_size) {
		array_pop(rewind_array);	
	}
	
	ResetRewindState();
} else {
	//Rewinding
	if (array_length(rewind_array) > 0) {
		for (var i = 0; i < global.CONFIGS.rewind_speed; i++) {
			var entry = array_shift(rewind_array);
			if (entry != undefined) {
				SetFullGameState(entry, rewinding);
			} else {
				rewinding = false;	
				UpdateFullGameState();
			}
		}
	} else {
		rewinding = false;
		rewind_timer = 0;
		UpdateFullGameState();
	}
}

