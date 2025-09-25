if (!global.isRewinding()) {
	var xy = choose("x", "y");

	if (xy == "x") {
		shub_instance_create_depth(irandom(room_width), 0, -1, obj_triangle);	
	} else {
		shub_instance_create_depth(0, irandom(room_height), -1, obj_triangle);	
	}
}

alarm[0] = time_to_spawn;