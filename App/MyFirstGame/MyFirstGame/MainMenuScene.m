//
//  MainMenuScene.m
//  MyFirstGame
//
//  Created by hehanlong on 2021/5/23.
//

#import "MainMenuScene.h"
#import "FirstScene.h"
#import "SpaceshipScene.h"
#import "SpaceWarsScene.h"
#import "MyShaderScene.h"
#import "CApp.h"

@implementation MainMenuScene
{
@private
    SKLabelNode* btnSKNode;
}

-(void) didMoveToView:(SKView *)view
{
    deviceInit();
    
    self->btnSKNode = [SKLabelNode labelNodeWithText:@"Go To FirstScene"];
    self->btnSKNode.fontSize = 18;
    self->btnSKNode.fontName = @"Chalkduster";
    self->btnSKNode.fontColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    self->btnSKNode.position = CGPointMake(self->btnSKNode.frame.size.width/2, 20); // 能够根据文字内容 大小 字体 计算出尺寸
    // self->btnSKNode.anchorPoint = CGPointZero;
    
    [self addChild:self->btnSKNode];
    
    SKLabelNode* l2 = [self->btnSKNode copy]; // SKSpriteNode支持NSCopying深度拷贝协议
    l2.text = @"Go To SpaceShip";
    l2.position = CGPointMake(l2.frame.size.width/2,
                              l2.frame.size.height/2 + (20 + self->btnSKNode.frame.size.height/2) + 50);
    l2.name = @"SpaceShip";
    [self addChild:l2];
    
    SKLabelNode* l3 = [self->btnSKNode copy];
    l3.text = @"Go To SpaceWar";
    l3.position = CGPointMake(l3.frame.size.width/2,
                               l3.frame.size.height/2 +  (l2.position.y + l2.frame.size.height/2) + 50);
    l3.name = @"SpaceWar";
    [self addChild:l3];
    
    
    
    SKLabelNode* l4 = [self->btnSKNode copy];
    l4.text = @"Go To SKShade";
    l4.position = CGPointMake(l4.frame.size.width/2,
                              l4.frame.size.height/2 +  (l3.position.y + l3.frame.size.height/2) + 50);
    l4.name = @"SKShade";
    [self addChild:l4];
    
    
    
    // 根据给定的点 做样条曲线  可以使闭合的曲线 只要最后一点跟第一个点一样
    CGPoint spline[6];
    spline[0] = CGPointMake(0,40);
    spline[1] = CGPointMake(20,140);
    spline[2] = CGPointMake(40,110);
    spline[3] = CGPointMake(60,130);
    spline[4] = CGPointMake(80,10);
    spline[5] = CGPointMake(90,90);
    SKShapeNode* shape = [SKShapeNode shapeNodeWithSplinePoints:spline count:sizeof(spline)/sizeof(spline[0])];
    shape.position = CGPointMake(self.frame.size.width /2 , self.frame.size.height /2);
    [self addChild:shape];
    
    
    // 给点点连成线条
    CGPoint temp[] = {
        CGPointMake(0,0),
        CGPointMake(50,200),
        CGPointMake(80,220),
    };
    SKShapeNode* line = [SKShapeNode shapeNodeWithPoints:temp count:sizeof(temp)/sizeof(temp[0])];
    line.position = CGPointMake(20, self.frame.size.height * 0.3);
    line.fillColor = [UIColor blueColor]; // 线条不会连接起来，但是fillcolor是所有点围成区域填充
    line.strokeColor = [UIColor yellowColor]; // 连线的颜色
    [self addChild:line];
    
    
    // SKEffectNode 将其子节点渲染到单独的缓冲区中 可以应用effect 比如Core Image filter, 在最后渲染结果之前
    // 每次渲染 effectNode会做如下内容
    //
    // It draws its children into a private framebuffer. 渲染子节点到一个单独的fbo
    // It applies a Core Image effect to the private framebuffer. 渲染滤镜 This stage is optional; see the filter and shouldEnableEffects properties.
    // It blends the contents of its private framebuffer into its parent’s framebuffer, using one of the standard sprite blend modes. 渲染到父fbo
    // It discards its private framebuffer. This step is optional; see the shouldRasterize property. 丢弃其私有fbo 可选 使用 shouldRasterize 属性
    
    SKEffectNode* effect = [[SKEffectNode alloc] init];
    // effect.filter   应用 Core Image filter
    // effect.shader   当渲染到父fbo时候使用的shader
    // effect.shouldRasterize  是否保留渲染子节点的缓冲fbo
    // effect.blendMode 如何把节点内容混合到父节点!!
    //         SKBlendModeAlpha    output.rgba = dst.rgba * (1 - alpha) + src.rgba * alpha.
    //         SKBlendModeAdd      output.rgba = dst.rgba + src.rgba
    //         SKBlendModeSubtract  src - dst
    //         SKBlendModeReplace The source color replaces the destination color.
    effect.blendMode = SKBlendModeReplace ; //  这个不是两个childnode的混合 而是effectNode如何把私有的fbo混合到父节点
    
    SKSpriteNode* redNode = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] size:CGSizeMake(50, 50)];
    SKSpriteNode* yellowNode = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.5] size:CGSizeMake(50, 50)];
    // 正 z 轴指向观察者，以便具有较大 z 位置值的节点更靠近观察者。
    // 从最小 z 位置值到最大 z 位置值渲染树中的所有节点。
    // 如果多个节点共享相同的 z 位置，则对这些节点进行排序，以便父节点在其子节点之前绘制，并且兄弟节点按照它们在父节点的子节点数组中出现的顺序呈现。
    // SKView的ignoresSiblingOrder属性 控制是否同样z值是否需要排序
    
    //redNode.zPosition = 10; // The default value is 0.0.
    //yellowNode.zPosition = 20; // 如果zPosition不一样 深度检测会抛弃另外一个 所有没有混合
    redNode.zPosition = 0;
    yellowNode.zPosition = 0;
 
    //  redNode.blendMode
    //redNode.colorBlendFactor = 1.0; // colorBlendFactor属性则是指Blend的程度。0表示没有blend，1表示最大程度的blend
    redNode.blendMode = SKBlendModeAlpha; // alpha是默认值
    //yellowNode.colorBlendFactor = 1.0;
    yellowNode.blendMode = SKBlendModeAlpha;
    
    /*
     // Equations
     output.r = src.r * src.alpha + dst.r * (1 - src.alpha);
     output.g = src.g * src.alpha + dst.g * (1 - src.alpha);
     output.b = src.b * src.alpha + dst.b * (1 - src.alpha);
     output.a = src.a * src.alpha + dst.a * (1 - src.alpha);

     // OpenGL Equivalent
     glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

     */
    

    [effect addChild:redNode];
    [effect addChild:yellowNode]; // 如果zPosition一样的话,会按照addChild的先后顺序
    
    
    effect.position = CGPointMake(250, 100);
    
    [self addChild:effect];
}


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [touches enumerateObjectsUsingBlock:^(UITouch * _Nonnull touch, BOOL * _Nonnull stop) {
       
        CGPoint positionInSKScene = [touch locationInNode:self];  // 区别于locationInView: InNode会转成左下角为原点
        SKNode* l2 = [self childNodeWithName:@"SpaceShip"];
        SKNode* l3 = [self childNodeWithName:@"//SpaceWar"];
        SKNode* l4 = [self childNodeWithName:@"//SKShade"];
        if (CGRectContainsPoint(self->btnSKNode.frame, positionInSKScene)) // frame表示SKNode在父节点中的位置 这里是场景
        {
            SKTransition* tran = [SKTransition doorwayWithDuration:1];
            FirstScene* scene = [FirstScene sceneWithSize:self.size];
            [self.view presentScene:scene transition:tran];
            *stop = true;
        }
        else if (CGRectContainsPoint(l2.frame, positionInSKScene))
        {
            SKTransition* tran = [SKTransition doorsOpenHorizontalWithDuration:1];
            SpaceshipScene* scene = [SpaceshipScene sceneWithSize:self.size];
            [self.view presentScene:scene transition:tran];
            *stop = true ;
        }
        else if (CGRectContainsPoint(l3.frame, positionInSKScene))
        {
            SKTransition* tran = [SKTransition fadeWithColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.5] duration:1];
            SpaceWarsScene* scene = [SpaceWarsScene sceneWithSize:self.size];
            [self.view presentScene:scene transition:tran];
            *stop = true ;
        }
        else if (CGRectContainsPoint(l4.frame, positionInSKScene))
        {
            SKTransition* tran = [SKTransition crossFadeWithDuration:1];
            MyShaderScene* scene = [MyShaderScene sceneWithSize:self.size];
            [self.view presentScene:scene transition:tran];
            *stop = true ;
        }
      
    }];
}


@end
