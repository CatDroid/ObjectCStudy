//
//  MainMenuScene.m
//  MyFirstGame
//
//  Created by hehanlong on 2021/5/23.
//

#import "MainMenuScene.h"
#import "FirstScene.h"

@implementation MainMenuScene
{
@private
    SKLabelNode* btnSKNode;
}

-(void) didMoveToView:(SKView *)view
{
    
    self->btnSKNode = [SKLabelNode labelNodeWithText:@"Go To FirstScene"];
    self->btnSKNode.fontSize = 18;
    self->btnSKNode.fontName = @"Chalkduster";
    self->btnSKNode.fontColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    self->btnSKNode.position = CGPointMake(self->btnSKNode.frame.size.width/2, 10); // 能够根据文字内容 大小 字体 计算出尺寸
    // self->btnSKNode.anchorPoint = CGPointZero;
    
    [self addChild:self->btnSKNode];
}


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [touches enumerateObjectsUsingBlock:^(UITouch * _Nonnull touch, BOOL * _Nonnull stop) {
       
        CGPoint positionInSKView = [touch locationInNode:self];  // 区别于locationInView: InNode会转成左下角为原点
        
        if (CGRectContainsPoint(self->btnSKNode.frame, positionInSKView)) // frame表示SKNode在父节点中的位置 这里是场景
        {
            SKTransition* tran = [SKTransition doorwayWithDuration:1];
            FirstScene* scene = [FirstScene sceneWithSize:self.size];
            [self.view presentScene:scene transition:tran];
            *stop = true;
        }
        
      
    }];
}


@end
