//
//  SpaceWarsScene.m
//  MyFirstGame
//
//  Created by hehanlong on 2021/5/28.
//

#import "SpaceWarsScene.h"
#import "CApp.h"
#import "AVFoundation/AVFoundation.h"

#define ROCK_COUNT 4

@implementation SpaceWarsScene
{
    // 1.  实例变量可以使用OC语言中任何一种数据类型（包括基本类型和指针类型）；
    // 2.  声明实例变量时不能为其初始化，系统默认会初始化；
    // NSArray<NSNumber*>* speeds;
    CGFloat speeds[ROCK_COUNT];
    SKSpriteNode* rocks[ROCK_COUNT];
    NSTimeInterval lastTime ;
    SKSpriteNode* spaceship ;
    CGPoint beganTPoint ;
    CGPoint beganSPoint ;
    AVAudioPlayer* player ;
}



-(void) didMoveToView:(SKView *)view
{
    // 设置外放声音
    // 使用AudioPlay 必须要有这个 AVAudioSession  AudioPlayer使用/SKAction跟AVAudioSession没有关系 但是AVAudioSession决定有没有音乐
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //SKAction* audio = [SKAction playSoundFileNamed:@"bomb.wav" waitForCompletion:NO];
    //[self runAction:[SKAction repeatActionForever:audio]];
    
    NSURL* audioUrl = [[NSBundle mainBundle] URLForResource:@"bubble" withExtension:@"wav"];
    NSError* myError ;
    //AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:&myError]; // 局部对象 这样会销毁了
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:&myError];
    if (myError != NULL) {
        NSLog(@"player create fail %@", myError);
    }
    player.numberOfLoops = -1 ;
    //[player prepareToPlay]; // it's ok
    BOOL success = [player play];
    if (!success) {
        NSLog(@"player play fail");
    }
    
    [self createNodes];
    

}


-(void) createNodes
{
    //NSNumber* numberArray[3];
    //numberArray[0] = [NSNumber numberWithFloat:1.0];
    //numberArray[1] = [NSNumber numberWithFloat:2.0];
    //numberArray[2] = [NSNumber numberWithFloat:3.0];
    //speeds = [NSArray arrayWithObjects:numberArray count:sizeof(numberArray)/sizeof(NSNumber*)];
    //NSLog(@"array size is %lu", sizeof(numberArray)/sizeof(numberArray[0])); // 3
    for (int i = 0 ; i < sizeof(speeds)/sizeof(speeds[0]) ; i++)
    {
        speeds[i] = arc4random() % 3 + 1 ;
        
        if (gDeviceType == DT_IPAD) {
            speeds[i] *= 2 ;
        }
    }
    
    CGSize baseSize = CGSizeMake(64, 64);
    if (gDeviceType == DT_IPAD) {
        // baseSize *= 2; CGSize 是结构体
        baseSize = CGSizeMake(128, 128);
    }
    
    SKTexture* spaceshipTex = [SKTexture textureWithImageNamed:@"Spaceship.png"];
    spaceship = [SKSpriteNode spriteNodeWithTexture:spaceshipTex size:baseSize];
    spaceship.position = CGPointMake(self.size.width * 0.5 , self.size.height * 0.1 );
    [self addChild:spaceship];
    
    SKSpriteNode* light = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(5.,5.)];
    light.position = CGPointMake(0, -baseSize.height * 0.25);
    SKAction* fadin = [SKAction fadeInWithDuration:0.5];
    SKAction* fadout = [SKAction fadeOutWithDuration:0.5];
    SKAction* seq = [SKAction sequence:@[fadin, fadout]];
    SKAction* repeat = [SKAction repeatActionForever:seq];
    [light runAction:repeat];
    [spaceship addChild:light];
    
    
    SKTexture* rockTex = [SKTexture textureWithImageNamed:@"Spaceship.png"];
    SKTexture* rock[4][4];
    for(int i = 0 ; i < 4 ; i++)
    {
        for(int j = 0 ; j < 4 ; j++)
        {
            rock[i][j] = [SKTexture textureWithRect:CGRectMake(0.25*i, 0.25*j, 0.25, 0.25) inTexture:rockTex];
        }
    }
    NSArray<SKTexture*>* animateTexs = [NSArray arrayWithObjects:rock count:4*4];
    SKAction* animate = [SKAction animateWithTextures:animateTexs timePerFrame:0.2];
    SKAction* repeatAnimate = [SKAction repeatActionForever:animate];
    
    CGFloat minY = self.frame.size.height * 0.7;
    CGFloat rangeY =  self.frame.size.height - minY;
    
    //SKSpriteNode* rocks[ROCK_COUNT];
    rocks[0] = [SKSpriteNode spriteNodeWithTexture:animateTexs[0] size:CGSizeMake(baseSize.width*0.4, baseSize.height*0.4)];
    [rocks[0] runAction:repeatAnimate];
    rocks[0].position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.8);
    [self addChild:rocks[0]];
    
    for (int i = 1 ; i < ROCK_COUNT ; i++)
    {
        rocks[i] = [rocks[0] copy];
        rocks[i].xScale = arc4random() % 4 / 10.0 + 0.6 ; // 缩放成原来的 [0.6,0.9]
        rocks[i].yScale = rocks[i].xScale;
        rocks[i].position = CGPointMake(rocks[i].size.width + arc4random() % (uint32_t)(self.frame.size.width - rocks[i].size.width),
                                        minY + arc4random() % (uint32_t)(rangeY - rocks[i].size.height));
        [self addChild:rocks[i]];
    }

}

-(void) resetPosition
{
    CGFloat minY = self.frame.size.height * 0.7;
    CGFloat rangeY =  self.frame.size.height - minY;
    
    for (int i = 0 ; i < ROCK_COUNT ; i++)
    {
        rocks[i].xScale = arc4random() % 4 / 10.0 + 0.6 ; // 缩放成原来的 [0.6,0.9]
        rocks[i].yScale = rocks[i].xScale;
        rocks[i].position = CGPointMake(rocks[i].size.width + arc4random() % (uint32_t)(self.frame.size.width - rocks[i].size.width),
                                        minY + arc4random() % (uint32_t)(rangeY - rocks[i].size.height));
    }
    spaceship.position = CGPointMake(self.size.width * 0.5 , self.size.height * 0.1 );;
}

-(BOOL) collisionCheck:(CGRect)rect1 with:(CGRect)rect2
{
    CGFloat r1 = CGRectGetMinX(rect1); // 直接用宽的一半 作为圆形半径 (物体可能其他形状)
    CGFloat r2 = CGRectGetMinX(rect2);
    
    CGPoint p1 = CGPointMake(rect1.origin.x + r1, rect1.origin.y + r1);
    CGPoint p2 = CGPointMake(rect2.origin.x + r2, rect2.origin.y + r2);
    
    CGFloat xx = p1.x - p2.x;
    CGFloat yy = p1.y - p2.y;
    CGFloat distance = sqrt(xx*xx +yy*yy);
    
    return (distance < (r1+r2) *0.75) ; // 0.75 考虑图形空白区域
}

-(void) update:(NSTimeInterval)currentTime
{
    NSTimeInterval duration = currentTime - lastTime ;
    lastTime = currentTime;
    
    for (int i = 0 ; i < ROCK_COUNT; i++)
    {
        rocks[i].position = CGPointMake(rocks[i].position.x, rocks[i].position.y - speeds[i] );
        if (rocks[i].position.y < -rocks[i].frame.size.height/2) {
            rocks[i].position = CGPointMake(rocks[i].size.width + arc4random() % (uint32_t)(self.frame.size.width - rocks[i].size.width),
                                            self.frame.size.height + rocks[i].frame.size.height + arc4random() % 50 );
        }
    }

    for (int i = 0 ; i < ROCK_COUNT; i++)
    {
        //if( CGRectContainsRect(spaceship.frame , rocks[i].frame))
        if ([spaceship intersectsNode:rocks[i]]) // 相交 同一棵树木两个物体相交  忽略子节点??
        {
            // 碰撞
            NSLog(@"contains !!");
            SKAction* old = [spaceship actionForKey:@"crash"]; // 查找动作 动作执行完成会自己从节点移除
            // removeActionForKey 移动节点上特定的动作
            // removeAllActions  移除节点上所有动作
            // BOOL hasAction = [spaceship hasActions] 判断节点是否有动作
            if(old == NULL)
            {
                SKAction* fout = [SKAction fadeOutWithDuration:0.5];
                SKAction* await = [SKAction waitForDuration:0.2];
                SKAction* fin = [SKAction fadeInWithDuration:0.5];
                SKAction* crash = [SKAction sequence:@[fout, await, fin]];
                SKAction* audio = [SKAction playSoundFileNamed:@"bomb.wav" waitForCompletion:NO]; // auido其实是 SKPlaySound 必须先要配置AVAudioSession
                SKAction* group = [SKAction group:@[crash, audio]]; // SKGroup
                
                SKAction* complete = [SKAction runBlock:^{
                    NSLog(@"crash complete");
                    /*
                     Block implicitly retains 'self'; explicitly mention 'self' to indicate this is intended behavior
                     
                     意思是block中使用了self的实例变量rocks，因此block会隐式的retain住self
                     Xcode认为这可能会给开发者造成困惑，或者因此而因袭循环引用
                     所以警告我们要显式的在block中使用self，以达到block显式retain住self的目的。
                     */
                    
                    //rocks[i].position = CGPointMake(rocks[i].size.width + arc4random() % (uint32_t)(self.frame.size.width - rocks[i].size.width),
                    //                                self.frame.size.height + rocks[i].frame.size.height + arc4random() % 50 );
                    self->rocks[i].position = CGPointMake(self->rocks[i].size.width + arc4random() % (uint32_t)(self.frame.size.width - self->rocks[i].size.width),
                                                    self.frame.size.height + self->rocks[i].frame.size.height + arc4random() % 50 );
                }];
               
               
                
                //[spaceship runAction:group withKey:@"collsion" completion:^{ // 没有同时withKey和complete的接口
               [spaceship runAction:[SKAction sequence:@[group,complete]] withKey:@"crash"]; // 给动作命名， 动作执行完成会自己从节点移除
                
            }
        }
    }
    
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches)
    {
        CGPoint posInSKScene = [touch locationInNode:self];
        beganTPoint = posInSKScene;
        beganSPoint = spaceship.position ;
    }
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches) // 手势--移动
    {
        CGPoint posInSKScene = [touch locationInNode:self];
        
        CGFloat xOffset = posInSKScene.x - beganTPoint.x;
        CGFloat yOffset = posInSKScene.y - beganTPoint.y;
        
        CGFloat xCur = beganSPoint.x + xOffset;
        CGFloat yCur = beganSPoint.y + yOffset;
        
        CGFloat haftW = spaceship.frame.size.width / 2 ;
        CGFloat haftH = spaceship.frame.size.height / 2 ;
        
        if (xCur < haftW) {
            xCur = haftW ;
        } else if (xCur > self.size.width - haftW) {
            xCur = self.size.width - haftW ;
        }
    
        if (yCur < haftH) {
            yCur = haftH ;
        } else if (yCur > self.size.height - haftH) {
            yCur = self.size.height - haftH ;
        }
        
        
        spaceship.position = CGPointMake(xCur, yCur);
        
    }
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches) {
        // locationInNode 左下角为原点
        // locationInView 左上角为原点
        CGPoint posInSKScene = [touch locationInNode:self];
        CGFloat xOffset = posInSKScene.x - beganTPoint.x;
        CGFloat yOffset = posInSKScene.y - beganTPoint.y;
        if (xOffset < 10 && yOffset < 10 ){
            // 手势--单击
            [self resetPosition];
        }
    }
    
}

-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}



@end
