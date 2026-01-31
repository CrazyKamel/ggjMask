shader_type canvas_item;
render_mode unshaded;

uniform float circle_size : hint_range(0.0, 1.05);
uniform float screen_width;
uniform float screen_height;
uniform vec2 player_screen_pos; // in screen UV (0–1)

void fragment() {
	float ratio = screen_width / screen_height;
	float dist = distance(player_screen_pos, vec2(mix(player_screen_pos.x, UV.x, ratio), UV.y));
	//float dist = distance(player_screen_pos, SCREEN_UV);
	COLOR.a = step(circle_size, dist);
}