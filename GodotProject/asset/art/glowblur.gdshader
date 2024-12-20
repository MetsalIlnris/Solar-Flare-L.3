shader_type canvas_item;

uniform float strength : hint_range(0.0, 10.0);
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable,filter_linear_mipmap;

bool is_in_sphere(int i,int j,int radius){
	if(i*i + j*j > radius* radius){
		return false;
	}else{
		return true;
	}
}

void fragment()
{
	vec4 tex = texture(screen_texture, UV,(strength-1.0)/2.0);
	vec4 center_color = vec4(0,0,0,1.0);
	int radius = int(strength*10.0 -10.0);
	//int radius = 10;
    for(int j=-radius;j<=radius;j+=2){
        for(int i=-radius;i<=radius;i+=2){
			if (i*i + j*j > radius*radius){
				continue;
			}
            vec2 each_coord = vec2(UV.x + float(i)/1920.0, UV.y + float(j)/1080.0);
            vec4 each_color = texture(screen_texture, each_coord);
            center_color = max(center_color, each_color);
        }
    }
	if(center_color.rgb != vec3(0,0,0)){
		COLOR = center_color;
	}
	else{
		COLOR = tex;
	}
	COLOR.rgb = COLOR.rgb*(strength+2.0)/3.0;
}
