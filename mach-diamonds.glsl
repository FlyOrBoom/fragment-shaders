// Mach Diamonds!

#define PI     3.1416
#define t     iTime
#define start  3.1 // sync with the soundcloud audio
#define end   23.6

float shell(vec2 p,float offset)
{
    float main = mvesica(p);
    float next = min(
        mvesica(p+vec2(offset,0)),
        mvesica(p-vec2(offset,0))
    );
    return smin(
        main,
        next,
        .15
    );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float t = mod(iTime,end);

    float offset = .8;
    
    float left = fragCoord.x/iResolution.x;
    float right = 1.-left;

    vec2 uv = (2.0*fragCoord-vec2(0,iResolution.y))/iResolution.y;
    uv += .03*perlin(t*.5+left)*(.5+left);
    uv += .01*perlin(t*7.+left)*(.5+left);
    uv.y += .01*perlin(t*67.+left)*(.5+left);
    uv.y += .005*perlin(t*101.+left)*(.5+left);
    //uv.y /= sqrt(right)*.5+1.;
    uv.x += .5*(.2-abs(uv.y))*perlin(t*3.);
    offset += .02*perlin(t*3.);
    uv*=1.;
   
    vec2 p = uv;
    p.x = mod(p.x,offset)-offset/2.;

    float diamonds = max(smin(
        vesica(p-vec2(offset-.4,0),.3,.15),
        max(vesica(p+vec2(offset-.4,0),.85,.7),0.)+.05*(1.-2.*abs(p.x-.1)),
        .1
    ),0.);
    float exhaust = shell(p,offset);
    float streams = 1.;
    for(float i = 0.; i<6.; i++){
        if(perlin(i+t)>.2) continue;
        p.y+=perlin(i-t)*.05;
        streams *= (abs(shell(
            p+vec2(0,sign(p.y)*.005*i*i
        ),offset))<.005) ? 0. : 1.;
    }
    
    
    float outside = max(sign(exhaust),0.);
    float inside = 1.-outside;
    
    float soutside = (1.+smoothsign(.1,exhaust))/2.;
    float sinside = 1.-soutside;

    float d = smin(exhaust,-diamonds,-.03);
    
    d = abs(d);
        
    
    float lum = (
        1.-d
        *(
             2. * inside
            +5. * outside / (left+.2)
        )
        *smoothstep(start,start+1.,t)
        *smoothstep(end,end-1.,t)
    );
    lum = clamp(lum,0.,1.);
    lum = pow(lum,(.9*(inside)+1.5*outside));
    
    //if (abs(d) < .005) d = 1.;
    
    
    vec3 col = vec3(lum);
        
    col *= vec3(
        (1.05*sinside+1.40*soutside-left*.0),
        (1.00*sinside+1.00*soutside-left*.2),
        (1.40*sinside+1.80*soutside-left*.6)
    );
    
    col -= diamonds;
    
    col *= smoothstep(start,start+.1,t)*smoothstep(end,end-.9,t);
    
    col *= 1.;//-.1*streams*perlin(.5*uv.x-5.*t+perlin(uv.y+uv.x+t));
    
    //col = vec3(streams);

    fragColor = vec4(col,1);
    //fragColor = vec4(vec3(1.-abs(p.x-.1)),1);

}
