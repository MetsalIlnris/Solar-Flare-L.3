shader_type canvas_item;

uniform float blur_strength : hint_range(0.0, 10.0) = 1.0;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
	vec2 SCREEN_SIZE = vec2(1920.0,1080.0);
    vec2 uv = SCREEN_UV;
    vec4 blurred_color = texture(screen_texture, vec2(uv));

    // 模糊算法，这里使用简单的均值模糊
    for (float x = -4.0 * blur_strength; x <= 4.0 * blur_strength; x += 1.0) {
        for (float y = -4.0 * blur_strength; y <= 4.0 * blur_strength; y += 1.0) {
            vec2 offset = vec2(x, y) / SCREEN_SIZE;
            blurred_color += texture(screen_texture, uv + offset);
        }
    }

	if (blur_strength <= 0.05){
		COLOR = texture(screen_texture, vec2(uv));
	}
	else{
    COLOR = blurred_color / (81.0 * blur_strength * blur_strength); // 81是模糊范围的像素数		
	}
}
