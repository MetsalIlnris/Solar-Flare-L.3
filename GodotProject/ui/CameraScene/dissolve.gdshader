shader_type canvas_item;
global uniform sampler2D dissolve_texture;
uniform float threshold = 0.1f;
uniform float fadeout = 0.0;
uniform vec4  inter_color = vec4(1.,0.,0.,1.);

void fragment(){
    vec4 color = texture(TEXTURE,UV);
    vec4 n = texture(dissolve_texture,UV);
    if(color.a > 0.0){
        float diff = n.r - fadeout;
        if(diff > threshold){
            color.a = 0.0;
        }else if(diff < threshold && diff > 0.0){
            //float a = n.r*diff/threshold;
            //color = color * (1.0- a) + inter_color * a;
        }
    }
    COLOR = color;
}