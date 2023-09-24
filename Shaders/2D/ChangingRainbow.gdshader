shader_type canvas_item;

uniform float alpha = 1.0;

void fragment() {
	float color_r = sin(TIME * 1.0);
	float color_g = sin(TIME * 3.0);
	float color_b = sin(TIME * 5.0);
	
	COLOR = vec4(color_r, color_g, color_b, alpha);
}