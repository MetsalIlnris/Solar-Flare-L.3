shader_type canvas_item;

uniform float time : hint_range(0.0, 10.0);

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    
    // 输出最终颜色
    COLOR = texture(screen_texture,SCREEN_UV);
}
