//
//  ViewController.m
//  ButtonTextNotification
//
//  Created by hehanlong on 2021/5/5.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>

// 打开两个窗口(右上角+)
// 按住 Control 键 , 左键点击 Button 控件不放 , 然后拖动到 ViewController.m 代码空白处
@property (weak, nonatomic) IBOutlet UIButton *alertViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *alertControlBtn;
@property (weak, nonatomic) IBOutlet UIButton *notifyBtn;
@property (weak, nonatomic) IBOutlet UITextField *text;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 按钮处理
    [self.alertViewBtn
     addTarget:nil
     action:@selector(btnAlterViewClick)
     forControlEvents:UIControlEventTouchDown];
    
    [self.alertControlBtn
     addTarget:nil
     action:@selector(btnAlterContorlClick)
     forControlEvents:UIControlEventTouchDown];
    
    // addTarget:action:forControlEvents:
    // 把一个目标对象及动作 关联到一个控件
    [self.notifyBtn
     addTarget:self  // 谁的方法被调用 nil的话UIKit会搜索响应链
     action:@selector(btnNotifyClick:forEvent:)
     forControlEvents:UIControlEventTouchDown];
    

    // 注册通知监听者
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sayHello:) // 如果方法带有一个参数的话，函数签名就是带: SEL就要带:
     name:@"NotifySayHello"
     object:nil];
    // - (void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName object:(id)notificationSender
    // 第一个参数是观察者为本身，
    // 第二个参数表示消息回调的方法
    // 第三个消息通知的名字 为nil，则会接收所有的通知(如果notificationSender不为空，则接收所有来自于notificationSender的所有通知)
    // 第四个为nil表示表示接受所有发送者的消息 如果notificationSender为nil，则会接收所有notificationName定义的通知；否则，接收由notificationSender发送的通知
    // 如果name和sender都是nil 接受所有的通知
    
    
    // - (id<NSObject>)addObserverForName:(NSString *)name object:(id)sender queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block
    // 创建一个匿名的对象作为观察者(即方法返回的id<NSObject>对象)，这个匿名对象会在指定的队列(queue)上去执行我们的block
    // 如果queue为nil，则消息是默认在post线程中同步处理 即通知的post与转发是在同一线程中
    // block块会被通知中心拷贝一份(执行copy操作)，以在堆中维护一个block对象，直到观察者被从通知中心中移除。所以，应该特别注意在block中使用外部对象，避免出现对象的循环引用
    // 如果一个给定的通知触发了多个观察者的block操作，则这些操作会在各自的Operation Queue中被并发执行。所以我们不能去假设操作的执行会按照添加观察者的顺序来执行
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
        name:@"NotifySayHello"
     object:nil];
}

// UIAlertViewDelegate 协议的方法
-(void) alertView:(UIAlertView*) alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 从0开始
    if ([alertView.title isEqualToString:@"MyAlertView"])
    {
        self.text.text = [NSString stringWithFormat:@"第%li个按钮按下", (long)buttonIndex];
    }
    
    
}

-(IBAction)btnAlterViewClick
{
    NSLog(@"btnAlterViewClick");
    // Terminating app due to uncaught exception 'NSObjectNotAvailableException', reason: 'UIAlertView is deprecated and unavailable for UIScene based applications,
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"MyAlertView" message:@"显示AlertView" delegate:self cancelButtonTitle:@"Cannel按钮title" otherButtonTitles:nil, nil];
    
    [alert show];
    
    NSLog(@"alert show return");
    
}

-(IBAction)btnAlterContorlClick
{
    NSLog(@"btnAlterContorlClick");
    
    // @interface UIAlertController:UIViewContorller
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"我的UIAlertController"
                                message:@"显示我的UIAlertController"
                                preferredStyle:UIAlertControllerStyleAlert];
    // UIAlertControllerStyleAlert 中心
    // UIAlertControllerStyleSheet 底部弹出  iPad要格外处理位置 否则会crash
    
    [alert addAction:[UIAlertAction
                             actionWithTitle:@"我的确定"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction* _Nonnull action) {
        self.text.text = @"按下我的确定";
        
    }]];
    
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"我的取消"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction * _Nonnull action) { // *** Xcode提示下 直接回车 自动生成 块 ****
        self.text.text = @"按下我的取消";
    }]];
    
    // 调用UIViewContorl的 presentViewController
    [self presentViewController:alert animated:YES completion:^{
            NSLog(@"presentViewController  alertControl done ");
    }];
    
    NSLog(@"UI thread running ???"); // 会继续执行  然后才看到上面的complete
    
}

-(IBAction)btnNotifyClick:(id)sender forEvent:(UIEvent*)event;
{
    // https://developer.apple.com/documentation/uikit/uibutton?language=objc
    NSLog(@"UIButton onClick sender = %@", sender); // UIButton
    NSLog(@"UIButton onClick event = %@", event); // UITouchesEvent
    
    NSLog(@"post thread = %@", [NSThread currentThread]);
    
    // NSNotification: 这是消息携带的载体，通过它，可以把消息内容传递给观察者
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString* current = [formatter stringFromDate:[NSDate date]];
 
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"NotifySayHello" object:current ];
}

-(void) sayHello:(NSNotification*) notifaction
{
    self.text.text = [@"Say Hello Notify" stringByAppendingString:notifaction.object];
    NSLog(@"receive thread = %@", [NSThread currentThread]); //跟post同一个线程
}


@end
