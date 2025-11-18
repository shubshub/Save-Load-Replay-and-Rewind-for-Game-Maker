function SaveGame() {
	
	var game_data = UpdateFullGameState();
	
	var _string = json_stringify(game_data);
	var _buffer = buffer_create(string_byte_length(_string) + 1, buffer_fixed, 1);
	
	buffer_write(_buffer, buffer_string, _string);
	
	buffer_save(_buffer, "saveload.txt");
	
	buffer_delete(_buffer);
	
	show_debug_message("Saved Game!: " + _string);
}

function GetGameData() {
	return global.game_data;	
}

function GetGameState() {
	return global.game_data.state;	
}

function UpdateGameData() {
	UpdateGameState();
	
	UpdateGameSettings();
}

function UpdateGameState() {
	var saveables = tag_get_asset_ids("saveable", asset_object);
	
	var game_state = GetGameState();
	
	var _settings = {
		gs: game_state	
	};
	
	foreach(game_state, _settings, function(inst, _settings) {
		if (instance_exists(inst.id)) {
			with(inst.id) {
				inst.x = x;
				inst.y = y;
				inst.active = true;
			}
		} else {
			inst.active = false;	
		}
	});
	
	return game_state;
}

function ApplyStructToInstance(_instance, _struct) {
	
	struct_foreach(_struct, method({_instance}, function(_name, _value)
	{
		_instance[$ _name] = _value;
	}));
}

function ApplyInstanceToStruct(_instance, _struct, _includes) {
	for (var i = 0; i < array_length(_includes); i++) {
		var _name = _includes[i];
		_struct[$ _name] = _instance[$ _name];
	}
}

function find_instance_by_index(_indexid, _object_index) {
	var _found = noone;
	if (instance_exists(_object_index)) {
		with(_object_index) {
			if (index_id == _indexid) {
				_found = id;
				break;
			}
		}
	}
	
	return _found;
}

function SetFullGameState(game_data, rewinding) {
	
	var _settings = {
		gs: game_data.state,
	};
	
	foreach(game_data.state, _settings, function(inst, _settings) {
		var alreadyExistingInstance = find_instance_by_index(inst.uuid, asset_get_index(inst.index));
		
		switch(inst.type) {
			case "STANDARD": {
				if (instance_exists(inst.id)) {
			
					with(inst.id) {
						x = inst.x;
						y = inst.y;
						active = inst.active;
						ApplyStructToInstance(self, inst.otherData);
					}
				} else if (alreadyExistingInstance != noone) {
					with(alreadyExistingInstance) {
						x = inst.x;
						y = inst.y;
						active = inst.active;
						ApplyStructToInstance(self, inst.otherData);
					}
			
				} else {
					if (inst.active && alreadyExistingInstance == noone) {
						alreadyExistingInstance = shub_instance_create_depth(inst.x, inst.y, -5, asset_get_index(inst.index), inst.otherData, inst.uuid);	
					}
				}
				break;
			}
			case "CREATE": {
				if (rewinding) {
					shub_instance_destroy(alreadyExistingInstance);	
				} else {
					alreadyExistingInstance = shub_instance_create_depth(inst.x, inst.y, -5, asset_get_index(inst.index), inst.otherData, inst.uuid);	
				}
				break;	
			}
			case "DELETE": {
				if (!rewinding) {
					shub_instance_destroy(alreadyExistingInstance);	
				} else {
					alreadyExistingInstance = shub_instance_create_depth(inst.x, inst.y, -5, asset_get_index(inst.index), inst.otherData, inst.uuid);	
				}
				break;	
			}
		}
	});
	
	SetGameData(game_data);
	
}

function SetGameData(game_data) {

	var settings = game_data.settings;

	/*
	score = game_data.settings.collectables;
	add your own settings stuff here
	obj_inventory_controller.inventory._inventory_items = json_parse(game_data.settings.inventory);
	obj_inventory_controller.treasures._inventory_items = json_parse(game_data.settings.treasures);
	global.radioController._prevVolume = global.radioController._volume;
	global.radioController._volume = real(game_data.settings.radioVolume);
	obj_simonsays_controller.highest_wave = real(game_data.settings.highest_color_score);
	*/
}

function UpdateGameSettings() {
	var game_data = GetGameData();
	var settings = game_data.settings;
	/*
	
	Replace this with your settings
	settings.collectables = score;
	settings.inventory = json_stringify(obj_inventory_controller.inventory._inventory_items);
	settings.treasures = json_stringify(obj_inventory_controller.treasures._inventory_items);
	settings.radioVolume = real(global.radioController.getVolume());
	settings.game_version = global.game_version;
	settings.highest_color_score = obj_simonsays_controller.highest_wave;	
	*/
	return settings;
}

function UpdateFullGameState() {
	
	var game_state = GetGameState();
	
	var _settings = {
		gs: game_state
	};
	
	foreach(game_state, _settings, function(inst, _settings) {
		var alreadyExistingInstance = find_instance_by_index(inst.uuid, asset_get_index(inst.index));
		
		if (instance_exists(inst.id)) {
			with(inst.id) {
				inst.x = x;
				inst.y = y;
				inst.active = true;
				inst = UpdateSpecialParamters(inst);
			}
		} else if (alreadyExistingInstance != noone) {
			with(alreadyExistingInstance) {
				inst.x = x;
				inst.y = y;
				inst.active = true;
				inst = UpdateSpecialParamters(inst);
			}
		} else {
			inst.active = false;
		}
		
	});
	
	UpdateGameData();
	
	return global.game_data;
}

function UpdateSpecialParamters(_state) {
	
	with(_state.id) {
		ApplyInstanceToStruct(self, _state.otherData, _state.includes);
	}
	
	return _state;
}

function FindUniqueIdInState(unique_id) {
	var _settings = {
		entity: false,
		uuid: unique_id
	};
	
	foreach_tilltrue(global.game_data.state, _settings, function(entity, _settings) {
		var assetInRoom = noone;
		var uuid = _settings.uuid;
		if (entity.uuid == _settings.uuid) {
			_settings.entity = entity.id;
			return true;
		}
	}); 
	
	return _settings.entity;
}

function LoadGame2() {
	if (file_exists("saveload.txt")) {
		var _buffer = buffer_load("saveload.txt");
		var _json = buffer_read(_buffer, buffer_string);
		
		var game_data = json_parse(_json);
		
		/*if (global.game_version != game_data.settings.game_version) {
			return false;
		}*/
		
		/*score = game_data.settings.collectables;
		obj_inventory_controller.inventory._inventory_items = json_parse(game_data.settings.inventory);
		obj_inventory_controller.treasures._inventory_items = json_parse(game_data.settings.treasures);
		global.radioController._prevVolume = global.radioController._volume;
		global.radioController._volume = real(game_data.settings.radioVolume);
		obj_simonsays_controller.highest_wave = real(game_data.settings.highest_color_score);*/
		
		var cached_game_state = [];
		
		var settings = {
			cgs: global.game_data.state	
		}
		
		foreach(game_data.state, settings, function(entity, settings) {
			if (entity.active) {
				var asset = FindUniqueIdInState(entity.uuid);
				var dont_creates = [];
				asset.x = entity.x;
				asset.y = entity.y;
				struct_foreach(entity.otherData, method({asset}, function(_name, _value)
				{
				    asset[$ _name] = _value;
				}));
			} else {
				var asset = asset_get_index(entity.index);
				/*with (asset) {
					if (object_is_ancestor(object_index, obj_collectable_parent) ||
					object_is_ancestor(object_index, obj_item_parent) ||
					object_is_ancestor(object_index, obj_treasure_parent)){
						if (index_id == entity.uuid) {
							if (!entity.active) {
								instance_destroy();	
							}
						}
					}	
				}*/
			}
		});
		
		buffer_delete(_buffer);
		
		UpdateFullGameState();
		/*with(obj_unlockable_controller) {
			grid_squares = InitializeUnlockables();	
		}*/
	}
}

function FixErroneousSpace(_obj, cached_game_state) {
	with(_obj) {
		var erroneous_space = [obj_collide_parent, obj_collide_parent2, obj_obstacle_parent]
		var collisions = CollisionAreaList(bbox_left, bbox_top, bbox_right, bbox_bottom, erroneous_space);
		if (array_length(collisions) > 0) {
			show_debug_message("Bad Collision");
			var settings = {
				obj: id,
				start_pos: {x: xstart, y: ystart},
				closest_pos: {}
			}
			foreach(cached_game_state, settings, function(state_item, settings) {
				with(settings.obj) {
					x = xstart;
					y = ystart;
					if (!variable_struct_exists(settings.closest_pos, "x") || distance_to_point(state_item.otherData.xstart, state_item.otherData.ystart) < distance_to_point(settings.closest_pos.x, settings.closest_pos.y)) {
						settings.closest_pos = {
							x: state_item.otherData.xstart,
							y: state_item.otherData.ystart
						}
					}
				}
				
			});
			
			if (variable_struct_exists(settings.closest_pos, "x")) {
				x = settings.closest_pos.x;
				y = settings.closest_pos.y;
				xstart = settings.closest_pos.x;
				ystart = settings.closest_pos.y;
			}
		}
	}	
}

function DestroyGame() {
	var saveables = tag_get_asset_ids("saveable", asset_object);
	//https://github.com/shubshub/crawlspace2/issues/15
	//Dont Destroys is for the Collectable Gates to be set manually
	var dont_destroys = [obj_collectable_power_parent, obj_collectable_parent, obj_key_power_parent, obj_secret_power_parent];
	var _settings = {
		dont_destroys:	dont_destroys
	}
	foreach(saveables, _settings, function(asset, _settings) {
		
		var dontdestroy = foreach_tilltrue(_settings.dont_destroys, asset, function(dont_destroy, asset) {
			if (instance_exists(asset)) {
				if (object_is_ancestor(asset.object_index, dont_destroy)) {
					
					asset.started = false;
					return true;
				}
			}
		})
		
		if(!dontdestroy) {
			
			if (instance_exists(asset)) {
				
				with(asset) {
					instance_destroy();	
					
				}
			}
		}
		
	});
	
	
		
}

function FindInGameState(inst_id) {
	var game_state = GetGameState();
	var ret = -1;
	for (var i = 0; i < array_length(game_state); i++) {
		if (game_state[i].id == inst_id) {
			ret = i;
			break;
		}
	}
	
	return ret;
}

function CacheInGameState(inst_id, active) {
	show_debug_message("Cacheing... " + string(inst_id));
	var _objectState = {
			id: inst_id.id,
			index: object_get_name(inst_id.object_index),
			x: inst_id.x,
			y: inst_id.y,
			active: active,
			otherData: {
				xstart: inst_id.xstart,
				ystart: inst_id.ystart
			}
		};

		_objectState = UpdateSpecialParamters(_objectState);
			
		array_push(GetGameState(), _objectState);
}

function CreateInclusionList(instance) {
	var inclusions = [];
	struct_foreach(instance, method({inclusions}, function(_name, _value) {
		if (!string_starts_with(_name, "private_")) {
			array_push(inclusions, _name);	
		}
	}));
	
	return inclusions;
}

function DestroyInGameState(gs_id, _instance) {
	if (variable_global_exists("game_data") && gs_id >= 0) {
		var game_state_entry = global.game_data.state[gs_id];
		var old_entry = variable_clone(game_state_entry);
		game_state_entry.active = false;
		SetRewindState(old_entry);	
	}
}

function DirtyChecker(gs_id, _instance) {
	if (variable_global_exists("game_data")) {
		var game_state_entry = global.game_data.state[gs_id];
		var old_entry = variable_clone(game_state_entry);
		if (game_state_entry.type == "CREATE" || game_state_entry.type == "DELETE") {
			game_state_entry.type = "STANDARD";	
		}
		
		var settings = {
			gs_entry: game_state_entry,
			otherData: game_state_entry.otherData,
			instance: _instance,
			dirty: false
		}
		
		struct_foreach(game_state_entry, method({settings}, function(_name, _value) {
			if (_name != "type") {
				if (struct_exists(settings.instance, _name)) {
					var _instance_entry = settings.instance[$ _name];
					if(_instance_entry != settings.gs_entry[$ _name]) {
						settings.gs_entry[$ _name] = _instance_entry;
						settings.dirty = true;
					}
				}
			}
			
		}));
		
		
		struct_foreach(game_state_entry.otherData, method({settings}, function(_name, _value) {
			if (struct_exists(settings.instance, _name)) {
				var _instance_entry = settings.instance[$ _name];
				
				if(_instance_entry != settings.otherData[$ _name]) {
					//show_debug_message(string(_name) + ": " + string(_instance_entry) + " vs " + string(settings.otherData[$ _name])); 
					settings.otherData[$ _name] = _instance_entry;
					settings.dirty = true;
				}
			}
		}));
		
		if (settings.dirty || old_entry.type != "STANDARD") {
			SetRewindState(old_entry);	
		}
		
		
		
		
	}
}

function ResetRewindState() {
	global.rewind_data = {
		state: [],
		settings: {}
	}
}

function GetRewindData() {
	var rw_data = global.rewind_data;
	rw_data.settings = UpdateGameSettings();
	return global.rewind_data;
}

function SetRewindState(entry) {
	var rewind_data = GetRewindData();
	//show_debug_message("Added to Rewind State: " + string(entry));
	array_push(rewind_data.state, entry);
}

function AddToGameState(asset, uuid, type) {
	
	var game_state = GetGameState();
	asset.game_state_id = array_length(game_state);
	with(asset) {
		var _objectState = {
			includes: CreateInclusionList(self),
			id: id,
			uuid: uuid,
			index: object_get_name(object_index),
			x: x,
			y: y,
			active: true,
			otherData: {
				xstart: xstart,
				ystart: ystart,
				image_xscale: image_xscale,
				image_yscale: image_yscale,
				image_angle: image_angle
			},
			type: type
		}
		show_debug_message("Added to Game State: " + string(_objectState));
		array_push(game_state, _objectState);
	}
	
	 UpdateGameState();
}
	

function GameInitialize() {
	var saveables = tag_get_asset_ids("saveable", asset_object);
	
	var _settings = {
		gs: global.game_data.state,
	};
	
	foreach(saveables, _settings, function(asset, _settings) {
		var objs = [];
		with(asset) {
			var _objectState = {
				includes: CreateInclusionList(self),
				id: id,
				uuid: id.index_id,
				index: object_get_name(object_index),
				x: x,
				y: y,
				active: true,
				otherData: {
					xstart: xstart,
					ystart: ystart,
					image_xscale: image_xscale,
					image_yscale: image_yscale,
					image_angle: image_angle
				},
				type: "STANDARD"
			};
			
			array_push(objs, _objectState);
		}
		
		for (var i = 0; i < array_length(objs); i++) {
			if (!FindInGameState(objs[i].id)) {
				array_push(_settings.gs, objs[i]);
			}
		}
		
		
	});
	
	for (var i = 0; i < array_length(global.game_data.state); i++) {
		var entry = global.game_data.state[i];
		entry.otherData.game_state_id = i;
		if(instance_exists(entry.id)) {
			entry.id.game_state_id = i;
		}
	}
	
	UpdateFullGameState();
	
	
	
}