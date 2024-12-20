shader_type canvas_item;

uniform float fade_distance : hint_range(0.0, 1.0) = 0.2;

void fragment() {
	float screen_size_x = 1200.0;
    // 计算当前像素点在X轴上的位置
    float x = UV.x * screen_size_x;

    // 计算两侧区域的透明度
    float fade = 1.0 - smoothstep(0.5 - fade_distance, 0.5, abs(x / screen_size_x - 0.5));

    // 将透明度应用到像素颜色上
    COLOR.a *= fade;
}
