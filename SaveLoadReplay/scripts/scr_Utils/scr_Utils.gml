function round_fraction(val, fraction) {
	return ceil(val*fraction)/fraction;	
}

function list_to_array(list) {
	if (is_array(list)) {
		return list;	
	} else (ds_exists(list, ds_type_list)) {
	
		var _arr = [];
		for (var i = 0; i < ds_list_size(list); i++) {
			array_push(_arr, list[| i]);	
		}
	
		ds_list_destroy(list);
	
		return _arr;
	}
}

function shub_instance_create_depth(_x, _y, _depth, _obj, _struct = undefined, uuid = generate_uuid()) {
	var _created = undefined;
	if (!is_undefined(_struct)) {
		_created = instance_create_depth(_x, _y, _depth, _obj, _struct);
	} else {
		_created = instance_create_depth(_x, _y, _depth, _obj);
	}
	
	_created.game_state_id = instance_count;
	_created.index_id = uuid;
	
	AddToGameState(_created, uuid);
}

function generate_uuid() {
    var _config_data = os_get_info();
    var _uuid_string = md5_string_unicode(
        string(get_timer()) +
        string(date_current_datetime()) +
        _config_data[? "udid"] + // Device UDID (if available)
        string(_config_data[? "video_adapter_subsysid"]) // Hardware info
    );
    ds_map_destroy(_config_data);
    return _uuid_string;
}

function object_get_ancestors(obj){
	var parents = []
	var last_parent = obj
	while true {
		last_parent = object_get_parent(last_parent)
		if last_parent=-100 //object has no parent
		or last_parent = -1 //object doesn't exist
		{
			break;
		}
		array_push(parents, last_parent)
	}
	return parents //returns an array of all of the object's ancestors
}

function floor_or_ceil(number, scalar) {
	if (number > 0) {
		return floor(number*scalar)/ scalar;
	} else {
		////show_debug_message("Ceil: " + string(ceil(number)) + " Floor: " + string(floor(number)));
		return ceil(number*scalar)/scalar;	
	}
		
}

function floor_or_ceil2(number, checker, scalar) {
	if (checker > 0) {
		return floor(number*scalar)/ scalar;
	} else {
		////show_debug_message("Ceil: " + string(ceil(number)) + " Floor: " + string(floor(number)));
		return ceil(number*scalar)/scalar;	
	}
		
}

function foreach(list, settings, func) {
	for (var i = 0; i < array_length(list); i++) {
		func(list[i], settings, i);	
	};
}

function foreach_tilltrue(list, settings, func) {
	var ret = false;
	for (var i = 0; i < array_length(list); i++) {
		ret = func(list[i], settings, i);	
		////show_debug_message("Return: " + string(ret));
		if (ret) {
			break;	
		}
	}
	
	return ret;
}

function draw_set(_color = c_white, _alpha = 1) {
	draw_set_color(_color);
	draw_set_alpha(_alpha);
}

function draw_reset() {
	draw_set();
}

function text_align(halign = fa_left, valign = fa_top) {
	draw_set_halign(halign);
	draw_set_valign(valign);
}