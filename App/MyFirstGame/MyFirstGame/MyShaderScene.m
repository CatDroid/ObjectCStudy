//
//  MyShaderScene.m
//  MyFirstGame
//
//  Created by hehanlong on 2021/5/30.
//

#import "MyShaderScene.h"

@implementation MyShaderScene
{
    SKShader* gShader ;
    SKUniform* startColorUniform ;
    SKUniform* endColorUniform ;
    SKUniform* strokeLengthUniform ;
    CGFloat _strokeLengthFloat ;
    
    SKUniform* checkerRadiumUniform ;
    CGFloat _checkerRadiumFloat ;
}

-(CGFloat) strokeLengthFloat
{
    return _strokeLengthFloat;
}

-(void) setStrokeLengthFloat:(CGFloat) value
{
    _strokeLengthFloat = value ;
    strokeLengthUniform.floatValue = value ;
}

-(CGFloat) checkerRadiumFloat
{
    return _checkerRadiumFloat ;
}

-(void) setCheckerRadiumFloat:(CGFloat) value
{
    _checkerRadiumFloat = value ;
    checkerRadiumUniform.vectorFloat2Value = (vector_float2){value, value};
}


-(void) didMoveToView:(SKView *)view
{
    // 绘制椭圆形
    
    SKShapeNode* ecllispseNode = [SKShapeNode shapeNodeWithEllipseInRect:CGRectMake(0, 0, 200, 120)];
    // NSLog(@"achor point %@", shaderNode.anchorPoint); // 没有锚点设置 可以认为就是左下角为几何中心
    ecllispseNode.position = CGPointMake(0, self.frame.size.height * 0.5);
    
    //shaderNode.strokeColor = [UIColor redColor]; // 线条颜色
    //shaderNode.lineWidth = 12; // 线条宽度 单位 像素 宽度
    ecllispseNode.glowWidth = 13; // 光晕宽度  没有设置strokeColor就是白色
    ecllispseNode.fillColor = [UIColor yellowColor];
    
    [self addChild:ecllispseNode];
    
    //---------------------------------------------------------------------------------------------
    
    /*
        形状节点还有两个与x线条相关的属性，这些属性扩展了SKShader定义的属性：
        float u_path_length;        Uniform     The total length of the path, in points.
        float v_path_distance;      Varying     The distance along the path, in points.
     */
    SKShader* fadeShader = [SKShader shaderWithFileNamed:@"fadeStroke.fsh"];
    
    SKShapeNode* fadeStrokeNode = [SKShapeNode shapeNodeWithRect:CGRectMake(0,0,150,100) cornerRadius:10]; // 圆角矩形
    fadeStrokeNode.lineWidth = 17.0;
    fadeStrokeNode.strokeShader = fadeShader;
    fadeStrokeNode.position = CGPointMake(100, self.frame.size.height * 0.75);
    [self addChild:fadeStrokeNode];
    
    
    //---------------------------------------------------------------------------------------------
    
 
    
    
    //---------------------------------------------------------------------------------------------
    
    vector_float4 startColor = {1.0, 1.0, 0.0, 1.0};
    vector_float4 endColor = {1.0, 0.0, 0.0, 1.0}; // simd_make_float4(1,0,0,1)
    // typedef simd_float4 vector_float4;
    
    startColorUniform = [SKUniform uniformWithName:@"u_color_start" vectorFloat4:startColor];
    endColorUniform = [SKUniform uniformWithName:@"u_color_end" vectorFloat4:endColor];
    strokeLengthUniform = [SKUniform uniformWithName:@"u_current_percentage" float:0.5];
    
    // https://developer.apple.com/documentation/spritekit/skshader/executing_shaders_in_metal_and_opengl?language=objc
    // https://developer.apple.com/documentation/spritekit/skshapenode/controlling_shape_drawing_with_shaders?language=objc
    // shaderNode.strokeShader 使用的是OpenGLES的shader
    // 提供给SKShader的glsl代码会被转换成metal着色器语言 并运行在metal渲染器上 在旧的机器上还是运行opengl着色器(调试效果需要注意)
    
    // SpriteKit renders with Metal in iOS 9 and OS X 10.11,
    // 可以指定你的设备使用哪个渲染器
    // 例如，强制一个启用了metal的设备使用SpriteKit的OpenGL渲染器进行调试
    // 通过在你的应用程序的Info.plist中添加一个PrefersOpenGL=true  (SceneKit SpriteKit都会影响)
    // 为了兼容所有设备 建议在设置和不设置 PrefersOpenGL 这个key时候的效果
    
    gShader = [SKShader shaderWithFileNamed:@"gradientStroke.fsh"];
    gShader.uniforms = @[strokeLengthUniform, startColorUniform, endColorUniform];
    // shader每次渲染都会读取 这些SKUniform, 在CPU端update, 逻辑更新这个值, 就可更新传入shader中的值
    
    SKShader* fillShader = [SKShader shaderWithFileNamed:@"checkerboardFill.fsh"];
    CGSize size = CGSizeMake(200, 200);
    checkerRadiumUniform = [SKUniform uniformWithName:@"u_texture_size" vectorFloat2: (vector_float2){size.width, size.height}];
    fillShader.uniforms = @[checkerRadiumUniform];
    
    SKShapeNode* shaderNode = [SKShapeNode shapeNodeWithCircleOfRadius:50]; // 圆形
    shaderNode.lineWidth = 10.0;
    shaderNode.strokeShader = gShader;
    shaderNode.fillShader = fillShader;
    shaderNode.position = CGPointMake(80, self.frame.size.height * 0.1);
    [self addChild:shaderNode];
    

    // SKVideoNode videoNodeWithAVPlayer: 使用现成的AVPlayer对象创建和初始化SKVideoNode
 
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSURL* urlPath = [mainBundle URLForResource:@"temp" withExtension:@"mp4"];
    SKVideoNode* vdo = [SKVideoNode videoNodeWithURL:urlPath];
    vdo.position = CGPointMake(300, 100);
    vdo.anchorPoint = CGPointMake(0.5, 0.5);
    vdo.size = CGSizeMake(100, 100); // 无法知道视频大小进行缩放
     
    [self addChild:vdo];
    [vdo play]; // 只有play和pause
   
    
}


- (void) update:(NSTimeInterval)currentTime
{
    self.strokeLengthFloat += 0.01;
    if (self.strokeLengthFloat > 1.0) {
        self.strokeLengthFloat = 0.0;
        
        self.checkerRadiumFloat += 50;
        if (self.checkerRadiumFloat > 1000)
        {
            self.checkerRadiumFloat = 50;
        }
    }
}

@end
