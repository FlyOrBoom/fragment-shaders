// Mach Diamonds!

#define PI 3.1416
#define t iTime

float sdVesica(vec2 p) // by iq
{
    float r = 1.;
    float d = .8*(smoothstep(.1,0.,t)/2.+1.);
    p = abs(p);

    float b = sqrt(r*r-d*d);  // can delay this sqrt by rewriting the comparison
    return ((p.x-b)*d > p.y*b) ? length(p-vec2(b,0.0))*sign(d)
                               : length(p-vec2(0.0,-d))-r;
}

float smin( float a, float b, float k )
{
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return mix( b, a, h ) - k*h*(1.0-h);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

    float offset = smoothstep(.3,.4,t)*0.6+.2;
    
	vec2 uv = (2.0*fragCoord-vec2(0,iResolution.y))/iResolution.y;
    
    vec2 p = uv;
    p.x = mod(p.x,offset)-offset/2.;

    float main = sdVesica(p);
    float neighbors = min(
        sdVesica(p+vec2(offset,0)),
        sdVesica(p-vec2(offset,0))
    );
        
    float d = smin(
        main,
        neighbors,
        .13
    );

    d = max(d,-.15*smin(d,-max(neighbors,0.),-.08));

    float lum = 1.-8.*d;
    lum = clamp(lum,0.,1.);
 //   lum = pow(sin(lum*PI/2.),7.);
    
    float dim = fragCoord.x/iResolution.x;
    float bri = 1.-dim;
    
    vec3 col = vec3(
        pow(lum*.2+lum*dim,.6),
        pow(lum,6.),
        pow(lum*.1+lum*bri,.6)
    )+pow(lum,50.);
    
	fragColor = vec4(col,1.0);
}
