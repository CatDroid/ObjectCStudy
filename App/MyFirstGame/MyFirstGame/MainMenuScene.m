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
