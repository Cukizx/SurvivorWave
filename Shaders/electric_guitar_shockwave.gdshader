shader_type canvas_item;

uniform vec2 global_position;
uniform vec2 screen_size;
uniform float force;
uniform sampler2D screen_texture: hint_screen_texture;
uniform float size;
uniform float thickness;
uniform float feather;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 center = global_position;
	float actual_size = size / 25.0;
	float screen_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	center.x /= screen_size.x;
	center.x = (center.x - 0.5) / screen_ratio + 0.5;
	center.y = 1.0 - ((screen_size.y - center.y) / screen_size.y);
	vec2 scaled_UV = (SCREEN_UV - vec2(0.5 , 0.0)) / vec2(screen_ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(actual_size - feather, actual_size, length(scaled_UV - center))) * smoothstep(actual_size - thickness - feather, actual_size - thickness, length(scaled_UV - center));
	vec2 displacement = normalize(scaled_UV - center) * force * mask;
	COLOR = texture(screen_texture ,SCREEN_UV - displacement);
	//COLOR.rgb = vec3(mask);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
