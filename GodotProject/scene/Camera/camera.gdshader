shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform vec3 grey_ratio = vec3(0.8,1,0.8);
global uniform int lead_emo;
global uniform sampler2D shadow_texture;

float _overlap(float color,float background_color,float strength){
	return (1.0 - (1.0-color)*(1.0-background_color)*2.0)*strength + background_color*(1.0-strength);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	float blink = float(60-lead_emo)/80.0;
	if(blink<0.0){
		blink = 0.0;
	}else{
		blink *=(sin(TIME * 1.0))/4.0+0.75;
	}
	vec4 color = texture(screen_texture, vec2(uv));
	float distortion_amount = 0.0;
	float contrast = 1.0;
	if(lead_emo < 30){
		distortion_amount = float(30-lead_emo)/6000.0;
		contrast = 1.0+float(30-lead_emo)/30.0;
	}
	vec2 center = vec2(0.5, 0.6); // 画面中心点
	uv = FRAGCOORD.xy / vec2(1920.0, 1080.0);
	float distance = length(uv - center);
	vec2 distortion = vec2(
		sin(TIME * 2.0 + uv.y) * distortion_amount * distance*5.0,
		sin(TIME * 3.0 + uv.x) * distortion_amount * distance*5.0
    );
    vec2 distorted_uv = uv + distortion;
    // 从扭曲后的UV坐标中采样颜色值
    vec4 uv_color = texture(screen_texture, distorted_uv);
	// shadow
	vec4 shadow = texture(shadow_texture, distorted_uv);
	color-=(1.0 - shadow)*blink/2.5;
	uv_color-=(1.0 - shadow)*blink/2.5;
	
	//增大对比度
	color.rgb = ((color.rgb - 0.5) * contrast + 0.5);
	uv_color.rgb = ((uv_color.rgb - 0.5) * contrast + 0.5);
	if(lead_emo < 30){
		//按照时间混合幻觉，不能一直幻觉
		float mix_amount = 0.5+sin(TIME * 0.3);
		if(mix_amount>0.8){
			mix_amount = 0.8;
		}
		else if(mix_amount<0.0){
			mix_amount = 0.0;
		}
		COLOR = color*(mix_amount) + uv_color*(1.0-mix_amount);
	}else{
		COLOR = color;
	}
	
}


