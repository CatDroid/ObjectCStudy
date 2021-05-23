//
//  GameViewController.m
//  MyFirstGame
//
//  Created by hehanlong on 2021/5/23.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "FirstScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load the SKScene from 'GameScene.sks'  从文件GameScene.sks中加载场景
    //GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    // GameScene* scene = [GameScene unarchiveFormFile:@"GameScene"]; //?? 已经没有这个
    //FirstScene* scene = [FirstScene sceneWithSize:CGSizeMake(320,568)];
    FirstScene* scene = [FirstScene sceneWithSize:self.view.bounds.size]; // iphoneXR (width = 320, height = 480)
    
    // CGSizeMake CGPointMake CGRectMake
    // NSMakeRange


    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    
    
    SKView *skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:scene]; // 把场景加载到View中
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES; // 是否显示节点数目
    // skView.ignoresSiblingOrder = YES; // SpriteKit 应用格外的优化来提高渲染性能   忽略兄弟顺序??
    
    
    // 游戏弹出对话框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertAction:) name:@"TouchOutsizeOfAlphaMask" object:nil];
 
}

- (void) showAlertAction:(NSNotification*) notification
{
    NSLog(@"showAlertAction %@", notification.name);
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:notification.name
                                                                   message:@"你触摸超出了半透明蒙版区域外"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"press ok");
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
     
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
