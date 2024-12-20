shader_type canvas_item;

uniform float time : hint_range(0.0, 10.0);

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    // 设置热浪效果的频率和振幅
    float frequency1 = 2.0;
    float amplitude1 = 0.002;
    
    // 设置x位置的位移量的频率和振幅
    float frequency2 = 25.0;
    float amplitude2 = 0.002;
    
    // 获取当前像素的坐标
    vec2 uv = FRAGCOORD.xy / vec2(1920, 1080);
    
    // 计算热浪效果的偏移量
    float heat_offset = sin(TIME * frequency1) * amplitude1;
    
    // 计算x位置的位移量，按正弦函数变化
    float x_offset = sin(uv.x * frequency2 + TIME) * amplitude2;
    
    // 对UV坐标进行扰动
    uv.y += heat_offset + x_offset;
    
    // 获取扰动后的纹理颜色
    vec4 texture_color = texture(screen_texture, uv);
    
    // 输出最终颜色
    COLOR = texture_color;
}
