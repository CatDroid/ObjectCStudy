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
    
    SKShapeNode* fadeStrokeNode = [SKShapeNode shapeNodeWithRect:CGRectMake(0,0,200,150) cornerRadius:10];
    fadeStrokeNode.lineWidth = 17.0;
    fadeStrokeNode.strokeShader = fadeShader;
    fadeStrokeNode.position = CGPointMake(0, self.frame.size.height * 0.15);
    [self addChild:fadeStrokeNode];
    
    
    //---------------------------------------------------------------------------------------------
    
    vector_float4 startColor = {1.0, 1.0, 0.0, 1.0};
    vector_float4 endColor = {1.0, 0.0, 0.0, 1.0}; // simd_make_float4(1,0,0,1)
    // typedef simd_float4 vector_float4;
    
    startColorUniform = [SKUniform uniformWithName:@"u_color_start" vectorFloat4:startColor];
    endColorUniform = [SKUniform uniformWithName:@"u_color_end" vectorFloat4:endColor];
    strokeLengthUniform = [SKUniform uniformWithName:@"u_current_percentage" float:0.5];
    
   
    gShader = [SKShader shaderWithFileNamed:@"gradientStroke.fsh"];
    gShader.uniforms = @[strokeLengthUniform, startColorUniform, endColorUniform];
    
    SKShapeNode* shaderNode = [SKShapeNode shapeNodeWithRect:CGRectMake(0,0,200,150) cornerRadius:10];
    shaderNode.lineWidth = 17.0;
    shaderNode.strokeShader = gShader;
    shaderNode.position = CGPointMake(50, self.frame.size.height * 0.05);
    [self addChild:shaderNode];
    
}


- (void) update:(NSTimeInterval)currentTime
{
    self.strokeLengthFloat += 0.01;
    if (self.strokeLengthFloat > 1.0) {
        self.strokeLengthFloat = 0.0;
    }
}

@end
