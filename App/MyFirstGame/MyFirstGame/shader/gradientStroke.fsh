void main()
{
 
    if (u_path_length == 0.0)
    {
        // error as u_path_length should never be zero, draw magenta
        gl_FragColor = vec4(1.0, 0.0, 1.0, 1.0);
        
    }
    else if(v_path_distance / u_path_length <= u_current_percentage)
    {
        float c = v_path_distance / u_path_length;
        float v = 1.0 - c;
        vec4 l = u_color_start;
        vec4 r = u_color_end;
 
        gl_FragColor = vec4( clamp(l.r*v + r.r*c, 0.0, 1.0),
                             clamp(l.g*v + r.g*c, 0.0, 1.0),
                             clamp(l.b*v + r.b*c, 0.0, 1.0),
                             clamp(l.a*v + r.a*c, 0.0, 1.0));
    }
    else
    {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
   
}
