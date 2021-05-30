//
//  SpaceshipScene.m
//  MyFirstGame
//
//  Created by hehanlong on 2021/5/26.
//

#import "SpaceshipScene.h"

@implementation SpaceshipScene
{
    bool isReady; // 实例变量 避免didMoveToView: 方法重复调用??
}

-(void) didMoveToView:(SKView *)view
{
    if (!isReady)
    {
        // file:///private/var/containers/Bundle/Application/1BCA4E35-9670-4A78-ABF1-8048962C675F/MyFirstGame.app/Spaceship.png
        
        NSURL* spaceShipUrl = [[NSBundle mainBundle] URLForResource:@"Spaceship" withExtension:@"png"];
        
        NSString* spaceShipPath = [[NSBundle mainBundle] pathForResource:@"Spaceship" ofType:@"png"];
        
        NSLog(@"App bundle, 应用包, mainBundle获取应用中的主应用包 %@,%@", spaceShipUrl, spaceShipPath);
        

        // SKSpriteNode* spaceship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship.png"];
        SKSpriteNode* spaceship = [SKSpriteNode spriteNodeWithImageNamed:spaceShipPath];
        spaceship.position = CGPointMake(self.size.width/2 , self.size.height/4);
        spaceship.size = CGSizeMake(64, 64);
        [self addChild:spaceship];
        
        
        SKSpriteNode* light = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] size:CGSizeMake(10, 10)];
        light.zPosition = 9 ; // 越大越晚绘制 
        SKAction* fadeIn = [SKAction fadeInWithDuration:0.5];
        SKAction* fadeOut = [SKAction fadeOutWithDuration:0.5];
        SKAction* sequene = [SKAction sequence:@[fadeIn, fadeOut]];
        SKAction* repeat  = [SKAction repeatActionForever:sequene];
        [light runAction:repeat];
        
        [spaceship addChild:light];
        
        SKAction* zoomOut = [SKAction scaleBy:2.0 duration:1];
        SKAction* zoomIn = [SKAction scaleBy:1/2.0 duration:1];
        SKAction* zoomSeq = [SKAction sequence:@[zoomOut, [SKAction waitForDuration:1], zoomIn]];
        SKAction* fadeSeq = [SKAction sequence:@[[SKAction fadeAlphaBy:0.8 duration:1], [SKAction waitForDuration:1],[SKAction fadeAlphaBy:1/0.8 duration:1]]];
        SKAction* group = [SKAction group:@[zoomSeq,fadeSeq]]; // group是同时开始  sequence是一个个执行
        SKAction* repeatGroup = [SKAction repeatActionForever:group];
        [spaceship runAction:repeatGroup];
        
        
        
        SKTexture* rockpng = [SKTexture textureWithImageNamed:@"Spaceship.png"]; // 如果找不到 会显示一个大红色X
        SKTexture* rock1 = [SKTexture textureWithRect:CGRectMake(0.125*0, 0,  0.125, 1) inTexture:rockpng]; // 归一化 与锚点坐标系一样
        SKTexture* rock2 = [SKTexture textureWithRect:CGRectMake(0.125*1, 0,  0.125, 1) inTexture:rockpng];
        SKTexture* rock3 = [SKTexture textureWithRect:CGRectMake(0.125*2, 0,  0.125, 1) inTexture:rockpng];
        SKTexture* rock4 = [SKTexture textureWithRect:CGRectMake(0.125*3, 0,  0.125, 1) inTexture:rockpng];
        SKTexture* rock5 = [SKTexture textureWithRect:CGRectMake(0.125*4, 0,  0.125, 1) inTexture:rockpng];
        SKTexture* rock6 = [SKTexture textureWithRect:CGRectMake(0.125*5, 0,  0.125, 1) inTexture:rockpng];
        SKTexture* rock7 = [SKTexture textureWithRect:CGRectMake(0.125*6, 0,  0.125, 1) inTexture:rockpng];
        SKTexture* rock8 = [SKTexture textureWithRect:CGRectMake(0.125*7, 0,  0.125, 1) inTexture:rockpng];
        
        SKSpriteNode* r1 = [SKSpriteNode spriteNodeWithTexture:rock1 size:CGSizeMake(64/8,64)];
        SKAction* animateAction = [SKAction animateWithTextures:@[rock1,rock2,rock3,rock4,rock5,rock6,rock7,rock8] timePerFrame:0.2]; // 只会循环一次
        SKAction* animateRepeatAction = [SKAction repeatActionForever:animateAction];
        [r1 runAction:animateRepeatAction];
       
        
        NSMutableArray<SKNode*>* array = [NSMutableArray arrayWithCapacity:3]; // 会预留但是是nil
        NSLog(@"count = %lu", array.count); // 0
        array[0] = r1 ;
        
        // typedef const struct CGPath *CGPathRef;
        CGPathRef myPath = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, 80, 100), nil);
        // CGPathCreateWithRect(<#CGRect rect#>, const CGAffineTransform * _Nullable transform)  // CGAffineTransform ??
        // [SKAction followPath:<#(nonnull CGPathRef)#> speed:<#(CGFloat)#>]
        //SKAction* pathAction = [SKAction followPath:myPath speed:2.0];
        SKAction* pathAction = [SKAction followPath:myPath duration:8];// 如何实现根据时间 判断速度??
        [array[0] runAction:pathAction];

        for(int i = 1 ; i < 3; i++)
        {
            array[i] = [r1 copy];
        }
        array[0].position = CGPointMake(self.size.width*0.5,  self.size.height*0.6);
        array[1].position = CGPointMake(self.size.width*0.25, self.size.height*0.75);
        array[2].position = CGPointMake(self.size.width*0.75, self.size.height*0.75);
        
        for(int i=0 ; i < 3; i++)
        {
            [self addChild:array[i]];
        }
        
        isReady = true;
    }

}

@end
