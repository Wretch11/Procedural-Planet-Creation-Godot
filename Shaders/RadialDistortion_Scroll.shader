shader_type canvas_item;
render_mode unshaded;
uniform float aspect = 1.0;
uniform float distortion = 1.0;
uniform float radius = 1.0;
uniform  float scroll_speed = 0.001;
uniform vec2 scroll_dir = vec2(-1.0,0.0);
uniform float outLineSize  = 0.02;
uniform vec4  outLineColor : hint_color;


vec2 distort(vec2 p)
{
	float d = length(p);
	float z = sqrt(distortion + d * d * -distortion);
	float r = atan(d, z) / 3.1415926535;
	float phi = atan(p.y, p.x);
	return vec2(r * cos(phi) * (1.0 / aspect) + 0.5, r * sin(phi) + 0.5);
}

void fragment()
{
	vec2 shifted_uv = UV;
	vec2 xy = (UV * 2.0 - 1.0); // move origin of UV coordinates to center of screen
	xy = vec2(xy.x * aspect, xy.y); // adjust aspect ratio
	float d = length(xy); // distance from center

	vec4 tex;
	shifted_uv  += TIME * scroll_speed *scroll_dir ;

	if (d < radius)
	{
		xy = distort(xy);
		tex = texture(TEXTURE,xy +shifted_uv);
		
	}
	COLOR = tex;
}
