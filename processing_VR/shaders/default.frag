#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PI 3.1415926535897932384626433832795

uniform vec3 lightDir;
uniform vec3 ambient;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;

float normalizedLambert(vec3 _lightDir, vec3 _normal)
{
  return max(dot(_lightDir, _normal), 0.0) / PI;
}

void main()
{
  float shade = normalizedLambert(lightDir, vertNormal);

//  gl_FragColor.rgb = vertColor.rgb * shade;
  gl_FragColor.rgb = vertColor.rgb * shade + ambient;
  gl_FragColor.a = vertColor.a;
}