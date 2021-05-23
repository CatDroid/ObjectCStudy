//
//  FirstScene.m
//  MyFirstGame
//
//  Created by hehanlong on 2021/5/23.
//

#import "FirstScene.h"
#import "MainMenuScene.h"
#import "CApp.h"

@implementation FirstScene
{
@private
    SKLabelNode* lbl;
    SKLabelNode* lbl4Info;
    SKLabelNode* lbl4Back;
    GLfloat speed ;
    NSTimeInterval lastTime ;
}

// called when SKView present SKScene
-(void) didMoveToView:(SKView*) view
{
    deviceInit();
    
    UIDevice* device = [UIDevice currentDevice];
    NSString* deviceInfo = [NSString stringWithFormat:@"%@-%@-%@",
                            device.model, // iPhone iPad
                            device.systemName, // iOS
                            device.systemVersion]; // 14.2
 
    
    
    NSProcessInfo* info = [NSProcessInfo processInfo];
    NSString* name = [info processName];
    

    
    NSString* text = [NSString stringWithFormat:@"Hello %@ on %@", name, deviceInfo];
    
    lbl = [SKLabelNode labelNodeWithText:text];
    
    lbl.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));// 获取矩形的中心点  self.frame是Rect
    lbl.fontSize = 16 ;
    lbl.fontColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];

    
    [self addChild: lbl]; // 当前场景 增加一个节点
    
   
    UIScreen* screen = [UIScreen mainScreen];
    CGSize mainScreenSize = screen.bounds.size; // iphoneXR 320x480 scale=2 0,0
    CGPoint mainScreenOrigin = screen.bounds.origin;// 矩形的原点
    CGFloat retinaScale = screen.scale; // =1 不支持Retina屏 =2 每个分辨率对应2*2个点
    
    lbl4Info = [SKLabelNode labelNodeWithText:
                [NSString stringWithFormat:@"screen size %f-%f-%f,%f-%f ",
                 mainScreenSize.width, 
                 mainScreenSize.height,
                 retinaScale,
                 mainScreenOrigin.x,
                 mainScreenOrigin.y]
                ];
    
    lbl4Info.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 50); // 原点是左下角
    lbl4Info.fontSize = 10;
    lbl4Info.fontColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    
    [self addChild:lbl4Info]; // 当前场景 再增加一个节点
    
    //--------------------------------------------------------------------------------
    
    SKColor * color = self.backgroundColor;
    NSLog(@"old background color %@", color); // UIExtendedSRGBColorSpace 0.15 0.15 0.15 1
    //self.backgroundColor = [SKColor blueColor];
    self.backgroundColor = [SKColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0]; // SKColor 就是 UIColor*
    
    SKSpriteNode* alphaMask = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5]
                                                           size:CGSizeMake(gScreenSize.width, gScreenSize.height/2)];
    
    alphaMask.position = CGPointMake(gScreenSize.width/2, gScreenSize.height/4); // 几何中心是中心点位置
    alphaMask.name = @"alpha node";
    [self addChild:alphaMask];
    
    
    SKSpriteNode* redQuad = [SKSpriteNode spriteNodeWithColor:
                              [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]
                                                          size:CGSizeMake(10, 10)];
    redQuad.name = @"red quad";
    [alphaMask addChild:redQuad];
    
    // 设置节点的position属性 其实是设置 当前节点的锚点 相对于 父节点的锚点 的位置; anchorPoint 取值为0~1
    // 场景的position属性始终都是0,0/CGPointZero anchorPoint锚点也是CGPointZero; 其他大多数节点锚点都是0.5 0.5,也就是节点的中心
    
   
    SKSpriteNode* backQuad = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0] size:CGSizeMake(50,50)];
    backQuad.name = @"back quad";
    backQuad.anchorPoint = CGPointZero;
    backQuad.position = CGPointMake(0, self.frame.size.height);
    [self addChild:backQuad];
    
    //----------------------------------------------------------------------------------
    speed = -5.0;
}

/*
    SpriteKit 内建游戏循环机制
    1. update方法 游戏主逻辑
    2. 自定义动作 SKAction
    3. 自定义动作补充工作 didEvaluateActions方法
    4. 模拟物理活动
    5. 模拟物理活动补充工作 didSimulatePhysics
    6. 场景约束
    7. didApplyConstriaints
    8. didFinishUpdate
    9. 完成场景渲染并显示
 */
 -(void) update:(NSTimeInterval)currentTime
{
    if (currentTime - lastTime < 1.0/30.0 ) // 控制帧率30fps
    {
        return ;
    }
    lastTime = currentTime;
    
    SKNode* backQuad = [self childNodeWithName:@"//back quad"];
    CGFloat halfHeight = backQuad.frame.size.height/2.0;
    if(backQuad.position.y + halfHeight > gScreenSize.height)
    {
        speed = -5;
    }
    else if(backQuad.position.y - halfHeight < 0)
    {
        speed = 5;
    }
    
    backQuad.position = CGPointMake(backQuad.position.x, backQuad.position.y + speed ) ;
    
}


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [touches enumerateObjectsUsingBlock:^(UITouch * _Nonnull touch, BOOL * _Nonnull stop) {
            
        CGPoint location = [touch locationInNode:self]; // 获取在场景中的位置  SKScene也是一个特殊的SKNode SKNode--SKEffectNode--SKScene
        
        CGPoint locationInSKView = [touch locationInView:nil]; // Window和View的原点都是左上角 返回坐标是左下角 场景的原点
        
        NSLog(@"CGPoint (%f-%f)-->(%f,%f)", locationInSKView.x, locationInSKView.y, location.x, location.y);
        
        // CGPointZero  坐标为0的位置
        // CGRectZero   位置为0且宽高为0的矩形区域
        // CGSizeZero   尺寸宽高为0
        
        SKNode* alphaNode = [self childNodeWithName:@"alpha node"];
        
        //SKNode* redNode = [self childNodeWithName:@"red quad"]; // 只能是直接子节点
        //if (redNode == nil) {
        //    redNode = [alphaNode childNodeWithName:@"red quad"];
        //}
        SKNode* redNode = [self childNodeWithName:@"//red quad"]; // //  是在整个场景里搜索
        SKNode* backNode = [self childNodeWithName:@"back quad"];
        /*
         通配符:
         
         // 整个场景树
         / 指定路径
         .. 兄弟节点
         * 0到任意个字符
         [a-g] [a,e,i,o,u] 匹配其中任意一个
         */
        // CGRectContainsRect(CGRect rect1, CGRect rect2) 矩形区域是否相交 碰撞上了
        if (CGRectContainsPoint(alphaNode.frame, location)) // SKSpriteNode.frame node的矩形区域;  给定点坐标是否在区域内
        {
            [redNode removeFromParent];
            [alphaNode addChild:redNode];
            
            CGPoint scenePoint = [redNode.scene convertPoint:CGPointMake(10, 15) fromNode:redNode]; // redNode中某个点 转换到场景中
            NSLog(@"局部坐标转换成场景坐标(redNode在alphaNode下) %f,%f", scenePoint.x, scenePoint.y);
            *stop = true;
        }
        else
        {
            [redNode removeFromParent];
            [self addChild:redNode]; // 从原来的父节点 解除父子关系 移到场景根节点  场景的原点是在左下角
            
            CGPoint scenePoint = [redNode.scene convertPoint:CGPointMake(10, 15) fromNode:redNode];
            NSLog(@"局部坐标转换成场景坐标(redNode在场景下) %f,%f", scenePoint.x, scenePoint.y);
         
            if (CGRectContainsPoint(backNode.frame, location))
            {
                MainMenuScene* scene = [MainMenuScene sceneWithSize:self.size];
                SKTransition* trans = [SKTransition doorsCloseHorizontalWithDuration:2];
                [self.view presentScene:scene transition:trans];
                
                *stop = true ;
            }
            else
            {
                // 弹出对话框
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchOutsizeOfAlphaMask" object:nil];
            }
        }
        
            
    }];
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}


@end
