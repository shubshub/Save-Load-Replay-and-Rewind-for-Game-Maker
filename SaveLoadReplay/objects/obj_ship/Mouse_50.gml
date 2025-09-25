if (!shooting && !global.isRewinding()) {
	alarm[0] = cooldown_speed;	
	
	var bullet = shub_instance_create_depth(x, y, -1, obj_bullet);
	var dir = image_angle;
	var b_speed = bullet_speed;
	var l = bullet_life;
	with(bullet) {
		motion_set(dir, b_speed);	
		alarm[0] = l;
	}
	
	shooting = true;
}