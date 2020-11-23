#define MAX_ITER 10.
#define PI 3.14159
#define EPSILON 0.01
#define SQUARE_WIDTH 64.

int square(float x,float d)
{
    return int(step(fract(x),d));
}

int checker(vec2 uv)
{
    return 2*square(uv.x+float(square(uv.y,.5))*0.5,.5)-1;
}

int fractal(vec2 uv, float d)
{
    return 1-2*square(uv.x-d,d)*square(uv.y-d,d);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord )
{
    float time = pow(sin(float(iFrame)/180.*PI),2.)*2.;
    float zoom = pow(2.,time*(1.5+EPSILON));
	vec2 uv = fragCoord.xy/(2.*SQUARE_WIDTH)/zoom;
    
    int lum = checker(uv);
    float level = 2.5*time-1.;
    
    for (float i=0.; i<MAX_ITER; i++)
    {
    	if(i>level){break;}
        lum*=fractal(2.*pow(3.,i)*uv,1./3.);
    }
    
    lum*=fractal(2.*pow(3.,ceil(level))*uv,1./3.*(level-floor(level)));

	fragColor = vec4(vec3(float(lum)),1.0);
}
