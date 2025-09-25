if (!global.isRewinding()) {
	image_angle = point_direction(x, y, mouse_x, mouse_y);

	if (keyboard_check(ord("W"))) {
		y-=move_speed;	
	}

	if (keyboard_check(ord("D"))) {
		x+=move_speed;	
	}

	if (keyboard_check(ord("S"))) {
		y+=move_speed;	
	}

	if (keyboard_check(ord("A"))) {
		x-=move_speed;	
	}
}