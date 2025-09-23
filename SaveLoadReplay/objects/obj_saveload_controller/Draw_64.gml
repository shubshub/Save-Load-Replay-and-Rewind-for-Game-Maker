/// @description Insert description here
// You can write your code in this editor
var g_width = display_get_gui_width();
var g_height = display_get_gui_height();
if (camera_flash) {
	draw_set(c_black, text_alpha);
	text_align(fa_center, fa_middle);
	draw_text(g_width / 2, (g_height / 4) * 3, "Saved Game Successfully");
	text_alpha-= 1 / exposure_rate;
	if (text_alpha <=0) {
		text_alpha = 2;
		camera_flash = 0;
	}
	text_align();
	draw_set();
}