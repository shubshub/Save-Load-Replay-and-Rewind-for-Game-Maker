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
	
	if (!shooting && mouse_check_button(mb_left)) {
		alarm[0] = cooldown_speed;	
	
		var bx = x + lengthdir_x(sprite_width/2, image_angle);
		var by = y + lengthdir_y(sprite_height/2, image_angle);
		var bullet = shub_instance_create_depth(bx, by, -1, obj_bullet);
		var dir = image_angle;
		var b_speed = bullet_speed;
		var l = bullet_life;
		with(bullet) {
			motion_set(dir, b_speed);	
			alarm[0] = l;
		}
	
		shooting = true;
	}
}