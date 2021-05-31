void main() {
    int size = 20;
    int h = int(v_tex_coord.x * u_texture_size.x) / size % 2; // /size 除以整数 分开一格格  比如 0 1 2 3 4 5 6 7 8 9 --> /4
    int v = int(v_tex_coord.y * u_texture_size.y) / size % 2; //                         --> 0 0 0 0 1 1 1 1 2 2 
    gl_FragColor = float4(v ^ h, v ^ h, v ^ h, 1.0);
}
