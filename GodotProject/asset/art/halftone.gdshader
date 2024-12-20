shader_type canvas_item;

uniform float time : hint_range(0.0, 10.0);

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

const int bayer_matrix[64] = {
    0, 48, 12, 60, 3, 51, 15, 63,
    32, 16, 44, 28, 35, 19, 47, 31,
    8, 56, 4, 52, 11, 59, 7, 55,
    40, 24, 36, 20, 43, 27, 39, 23,
    2, 50, 14, 62, 1, 49, 13, 61,
    34, 18, 46, 30, 33, 17, 45, 29,
    10, 58, 6, 54, 9, 57, 5, 53,
    42, 26, 38, 22, 41, 25, 37, 21
};

vec4 _bayer_print(vec2 uv,vec4 result){
    float bayer_index = float(bayer_matrix[int(uv.x)/4%8*8+int(uv.y)/4%8]) / 64.0;
	float th = (result.r+result.b+result.g-1.0-sin(TIME * 0.3)/4.0);
	result.r  = step(bayer_index, th);
	result.g  = step(bayer_index, th);
	result.b  = step(bayer_index, th);
	return result;
}

void fragment() {
    // 获取当前像素的坐标
    vec2 uv = FRAGCOORD.xy / vec2(1920, 1080);

    // 获取扰动后的纹理颜色
    vec4 texture_color = texture(screen_texture, uv);
    uv = vec2(UV)* vec2(1920, 1080);
	texture_color = _bayer_print(uv,texture_color);
    // 输出最终颜色
    COLOR = texture_color;
}
