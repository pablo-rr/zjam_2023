shader_type canvas_item;

uniform sampler2D base_color : source_color;
uniform vec4 albedo : source_color = vec4(0.0);
uniform sampler2D heightmap;

void fragment() {
	if(albedo == vec4(0.0)){
		COLOR = texture(base_color, UV).rgba;
	} else {
		COLOR = albedo;
	}
	COLOR.a = texture(heightmap, UV).r;
}
