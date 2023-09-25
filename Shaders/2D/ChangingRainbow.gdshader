shader_type canvas_item;

uniform float alpha = 1.0;

void fragment() {
	vec4 animated_line_color = vec4(sin(2.0 * 3.14 * 0.5 * TIME),
							   sin(2.0 * 3.14* 0.5 * TIME + radians(120.0)),
							    sin(2.0 * 3.14 * 0.5 * TIME + radians(240.0)),
							   1.0);
	
	COLOR = animated_line_color;
}