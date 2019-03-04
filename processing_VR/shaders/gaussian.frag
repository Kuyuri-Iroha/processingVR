uniform sampler2D tex;
uniform bool horizontal;
uniform float weight[10];
uniform vec2 resolution;

void main()
{
    vec2 tFrag = vec2(1.0 / resolution.x, 1.0 / resolution.y);
    vec2 fc = gl_FragCoord.xy;
    vec4 color = vec4(0.0);

    if(horizontal)
    {
        color += texture2D(tex, (fc + vec2(-9.0, 0.0)) * tFrag) * weight[9];
        color += texture2D(tex, (fc + vec2(-8.0, 0.0)) * tFrag) * weight[8];
        color += texture2D(tex, (fc + vec2(-7.0, 0.0)) * tFrag) * weight[7];
        color += texture2D(tex, (fc + vec2(-6.0, 0.0)) * tFrag) * weight[6];
        color += texture2D(tex, (fc + vec2(-5.0, 0.0)) * tFrag) * weight[5];
        color += texture2D(tex, (fc + vec2(-4.0, 0.0)) * tFrag) * weight[4];
        color += texture2D(tex, (fc + vec2(-3.0, 0.0)) * tFrag) * weight[3];
        color += texture2D(tex, (fc + vec2(-2.0, 0.0)) * tFrag) * weight[2];
        color += texture2D(tex, (fc + vec2(-1.0, 0.0)) * tFrag) * weight[1];
        color += texture2D(tex, (fc + vec2( 0.0, 0.0)) * tFrag) * weight[0];
        color += texture2D(tex, (fc + vec2( 1.0, 0.0)) * tFrag) * weight[1];
        color += texture2D(tex, (fc + vec2( 2.0, 0.0)) * tFrag) * weight[2];
        color += texture2D(tex, (fc + vec2( 3.0, 0.0)) * tFrag) * weight[3];
        color += texture2D(tex, (fc + vec2( 4.0, 0.0)) * tFrag) * weight[4];
        color += texture2D(tex, (fc + vec2( 5.0, 0.0)) * tFrag) * weight[5];
        color += texture2D(tex, (fc + vec2( 6.0, 0.0)) * tFrag) * weight[6];
        color += texture2D(tex, (fc + vec2( 7.0, 0.0)) * tFrag) * weight[7];
        color += texture2D(tex, (fc + vec2( 8.0, 0.0)) * tFrag) * weight[8];
        color += texture2D(tex, (fc + vec2( 9.0, 0.0)) * tFrag) * weight[9];
    }
    else
    {
        color += texture2D(tex, (fc + vec2(0.0, -9.0)) * tFrag) * weight[9];
        color += texture2D(tex, (fc + vec2(0.0, -8.0)) * tFrag) * weight[8];
        color += texture2D(tex, (fc + vec2(0.0, -7.0)) * tFrag) * weight[7];
        color += texture2D(tex, (fc + vec2(0.0, -6.0)) * tFrag) * weight[6];
        color += texture2D(tex, (fc + vec2(0.0, -5.0)) * tFrag) * weight[5];
        color += texture2D(tex, (fc + vec2(0.0, -4.0)) * tFrag) * weight[4];
        color += texture2D(tex, (fc + vec2(0.0, -3.0)) * tFrag) * weight[3];
        color += texture2D(tex, (fc + vec2(0.0, -2.0)) * tFrag) * weight[2];
        color += texture2D(tex, (fc + vec2(0.0, -1.0)) * tFrag) * weight[1];
        color += texture2D(tex, (fc + vec2(0.0,  0.0)) * tFrag) * weight[0];
        color += texture2D(tex, (fc + vec2(0.0,  1.0)) * tFrag) * weight[1];
        color += texture2D(tex, (fc + vec2(0.0,  2.0)) * tFrag) * weight[2];
        color += texture2D(tex, (fc + vec2(0.0,  3.0)) * tFrag) * weight[3];
        color += texture2D(tex, (fc + vec2(0.0,  4.0)) * tFrag) * weight[4];
        color += texture2D(tex, (fc + vec2(0.0,  5.0)) * tFrag) * weight[5];
        color += texture2D(tex, (fc + vec2(0.0,  6.0)) * tFrag) * weight[6];
        color += texture2D(tex, (fc + vec2(0.0,  7.0)) * tFrag) * weight[7];
        color += texture2D(tex, (fc + vec2(0.0,  8.0)) * tFrag) * weight[8];
        color += texture2D(tex, (fc + vec2(0.0,  9.0)) * tFrag) * weight[9];
    }
    gl_FragColor = color;
}
