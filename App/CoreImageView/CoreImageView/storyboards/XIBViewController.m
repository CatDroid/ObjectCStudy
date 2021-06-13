//
//  XIBViewController.m
//  CoreImageView
//
//  Created by hehanlong on 2021/6/12.
//

#import "XIBViewController.h"

@interface XIBViewController ()
@property (weak, nonatomic) IBOutlet UILabel *LabelView;

@end

@implementation XIBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 在成员函数中 访问属性 两种方式
    // 1. _LabelView 相当于 self->_LabelView
    // 2. self.LabelView (实际是调用了getter)
    self.LabelView.text = [NSString stringWithFormat:@"控制器传入参数 = %i", self.paramtersFromLastViewController];
    self.LabelView.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    
}


-(int) paramtersFromLastViewController
{
    return self->paramtersFromLastViewController;
}

-(void) setParamtersFromLastViewController:(int)paramId;
{
    self->paramtersFromLastViewController = paramId;
}

// 刚切换到这个ViewController willMove和didMove都会被调用, 并且parant是 <UINavigationController: 0x101013600>

// 当开始使用系统侧滑的时候，会先调用willMove，而parent的值为空；
// 当滑动结束后返回了上个页面，则会调用didMove，parent的值也为空，
// 如果滑动结束没有返回上个页面，也就是轻轻划了一下还在当前页面，那么则不会调用didMove方法。

// 这个方法 手势返回，但还没返回上个VC
-(void) willMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"XIBVIewController --will--  MoveToParentViewController %@", parent);
    
    [super willMoveToParentViewController:parent];
}

// 这个方法 手势返回，已经返回到上个VC
-(void) didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"XIBVIewController  --did--  MoveToParentViewController %@", parent);
    
    [super didMoveToParentViewController:parent];
    if (!parent) {
        BOOL result = self.feedback(self.paramtersFromLastViewController, [NSString stringWithFormat:@"%p", self]);
        NSLog(@"--返回 parent 是nil-- 控制器返回给上一个控制器参数(block方式) %d", result);
        
    }
}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //super prepareForSegue: sender:<#(nullable id)#>
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // 在一个基于storyboard的应用 可能需要 在跳转之前 做一些准备
    // 通过 segue.destinationViewController 获取 新的视图控制器 并且 给这个视图控制器传入参数
    NSLog(@"prepareForSegue id=%@, source=%@, dest=%@",
          segue.identifier, segue.sourceViewController, segue.destinationViewController);
}


@end
