shader_type canvas_item;

uniform vec2 light_center;
uniform float light_radius = 0.0;
uniform float max_radius = 800.0;
uniform float softness = 0.3;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    vec2 screen_uv = SCREEN_UV * vec2(textureSize(SCREEN_TEXTURE, 0));
    
    float dist = distance(screen_uv, light_center);
    float norm = smoothstep(light_radius, light_radius - (light_radius * softness), dist);

    // Norm = 1 → oscuro / Norm = 0 → iluminado
    COLOR = vec4(col.rgb * (1.0 - (1.0 - norm)), 1.0);
}
