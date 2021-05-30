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
}


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [touches enumerateObjectsUsingBlock:^(UITouch * _Nonnull touch, BOOL * _Nonnull stop) {
       
        CGPoint positionInSKScene = [touch locationInNode:self];  // 区别于locationInView: InNode会转成左下角为原点
        SKNode* l2 = [self childNodeWithName:@"SpaceShip"];
        SKNode* l3 = [self childNodeWithName:@"//SpaceWar"];
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
        
      
    }];
}


@end
