//
//  MyFirstStoryboardViewController.m
//  CoreImageView
//
//  Created by hehanlong on 2021/6/12.
//

#import "MyFirstStoryboardViewController.h"
#import "ArgumentsViewController.h"

@interface MyFirstStoryboardViewController ()

// 如果通过控件--右键菜单--Sent Events--TouchDown--+号拖到这里，会生成函数，并且这个控件的Send Events会绑定这个方法
- (IBAction)Button1TouchDown:(UIButton *)sender;

// 如果通过控制--Ctrl+拖拽 到这里, 控件会增加一个reference outlet
@property (weak, nonatomic) IBOutlet UIButton *ButtonWithOutlet;


@end

@implementation MyFirstStoryboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_ButtonWithOutlet addTarget:self action:@selector(doSomething:forEvent:) forControlEvents:UIControlEventTouchDown];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // sender就是指的是点击的控件
    // segue指的是 ViewController之间的连线
    
    // Storyboard上每一根用来界面跳转的线，都是一个 "UIStoryboardSegue对象"
    // 在Storyboard上 按住Ctrl直接从一个控件拖动到另外一个ViewControl（segue是直接跳转不能添加条件判断）然后Segue Action下来列表 选择 Show
    
    
    // segue.sourceViewController（一级界面的控制器或者上个控制器）
    // segue.destinationViewController（二级界面的控制器或者下个控制器）
    // segue.identifier（标记。用来区分是那条线。我们后面讲这个用处。）

    // ArgumentsViewController
    NSLog(@"MyFirstStoryboardViewController prepareForSegue  dest is %@", segue.destinationViewController);
    
    // 判断跳转的目标viewcontroller是否ArgumentsViewController
    if ([segue.destinationViewController isKindOfClass:[ArgumentsViewController class]])
    {
        ArgumentsViewController* vc = segue.destinationViewController;
        vc.tableDataSource = @[@"2020", @"2021", @"2022", @"2023", @"2024"];
    }
    else
    {
        NSLog(@"prepareForSegue target is not ArgumentsViewController");
    }
    
    
}

- (IBAction)Button1TouchDown:(UIButton *)sender
{
    static int pressCounter = 0;
    pressCounter ++ ;
    sender.titleLabel.text = [NSString stringWithFormat:@"Sender方式关联 已按下 %d", pressCounter];
}


- (IBAction)doSomething:(UIButton*)sender forEvent:(UIEvent*)event
{
    static int pressCounter = 0;
    pressCounter ++ ;
    sender.titleLabel.text = [NSString stringWithFormat:@"Outlet方式关联 已按下 %d", pressCounter];
}


@end
