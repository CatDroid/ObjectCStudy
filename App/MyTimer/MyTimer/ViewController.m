//
//  ViewController.m
//  MyTimer
//
//  Created by hehanlong on 2021/5/22.
//

#import "ViewController.h"
#import "MyTimerTest.h"

@interface ViewController ()
{
@private
    NSTimer* myNSThreadTimer ;
    NSMachPort* myPort ;
    NSThread* myExitThread ;
    BOOL isLoopRunning;
}


@property (weak, nonatomic) IBOutlet UIButton *timerInvalidButton;
@property (weak, nonatomic) IBOutlet UIButton *preformOnThreadButton;
@property (weak, nonatomic) IBOutlet UIButton *exitRunLoopButton;


@end

@implementation ViewController


// 直接重载  @interface 不用声明
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //---------------------------------------------------------------------------------------------------------------------
    
    NSRunLoop* loop = [NSRunLoop currentRunLoop];  // CFRunLoopGetCurrent()
    NSRunLoop* mainLoop = [NSRunLoop mainRunLoop]; // CFRunLoopGetMain()
    
    // viewDidLoad的确在主线程
    if (loop == mainLoop) {
        NSLog(@"current is main loop, thread name %@", [NSThread currentThread].name );
        [[NSThread mainThread] setName:@"MainThread"]; // 主线程默认没有名字 这里自定义一个
    }

    //---------------------------------------------------------------------------------------------------------------------
    // 切换到后台 会自动停止
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:2
                                                // 一个时间间隔对象，以秒为单位，一个>0的浮点类型的值，如果该值<0,系统会默认为0.1;
                                                // 并且不会第一次调用就执行函数 而是add到RunLoop之后的 timeInteval才会第一次执行
                                                // 不会延迟触发: 线程繁忙的过程超过了一个周期，但是timer并没有连着触发两次消息，而只是触发了一次
                                   target:self  // 表示发送的对象，如self
                                   selector:@selector(myTimerFunction) // 方法选择器，在时间间隔内，选择调用一个实例方法
                                   userInfo:nil  // 可以为nil 定时器会强引用这个 直到定时器失效
                                    repeats:YES];

    // 将定时器加入到交互运行模式中（一旦停止交互就不会响应）
    // 要让timer生效，必须保证该线程的runloop已启动，而且其运行的runloopmode
    // 一个timer对象只能够被注册到一个runloop中，在同一时间，在这个runloop中它能够被添加到多个runloop中模式中去
    // 一次性的timer在完成调用以后会自动将自己invalidate，而重复的timer则将永生，直到你显示的invalidate它为止
    NSTimer* timer2 = [NSTimer
                       timerWithTimeInterval:2
                       target:self
                       selector:@selector(myUITrackingTimerFunction)
                       userInfo:nil
                       repeats:TRUE];
    //[timer2 fire];
    
    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:UITrackingRunLoopMode];
    
    // RunLoop强引用了Timer, 不会释放
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(
                                                            CFAllocatorGetDefault(),
                                                                       kCFRunLoopBeforeWaiting, // Activity 监听的活动
                                                                       YES, // 重复
                                                                       0, // 优先级
                                                                       ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"监听到RunLoop发生改变---%zd", activity);
   });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode); // 监听的RunLoop和Mode
    //添加完后释放
    CFRelease(observer); // 还是要调用 CFRunLoopRemoveObserver
    
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(_MyNSThreadLoop) object:nil];
    [myThread start];
    

    // 属性两种方式访问 self->_timerInvalidButton self.preformOnThreadButton
    [self->_timerInvalidButton addTarget:self action:@selector(HandleTimerInvalidButton) forControlEvents:UIControlEventTouchDown];
    
    //---------------------------------------------------------------------------------------------------------------------
    
    self->myExitThread = [[NSThread alloc] initWithTarget:self selector:@selector(_MyNSThreadExitLoop) object:nil];
    [self->myExitThread start];
    
    
    // 通过performSelector来在子线程中处理耗时操作，避免重复创建
    //   [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
    
    [self.preformOnThreadButton addTarget:self action:@selector(HandlePreformOnThreadButton) forControlEvents:UIControlEventTouchDown];
    [self.exitRunLoopButton addTarget:self action:@selector(HandleExitThreadLoopButton)  forControlEvents:UIControlEventTouchDown];
    //---------------------------------------------------------------------------------------------------------------------
    
}


//------------------------------------------------------------------------------------------------------------------------
- (void) HandleTimerInvalidButton
{
    
    // 启动 Timer fire  触发Target的方法调用但是并不会改变Timer的时间设置; 即timer没有到达到，Timer会立即启动调用方法且没有改变时间设置，当时间timer到了的时候，Timer还是会调用方法。
  
    // 停止 Timer invalidate

    //if ([timer isValid]) {
    //    [timer invalidate];
    //    timer = nil;
    //}
    
    // if ([self->myNSThreadTimer isValid]) // 即使没有这个也没有问题
    {
        [self->myNSThreadTimer invalidate];
        self->myNSThreadTimer = nil;  // 不会导致NullPointException
    }
    
}



- (void) _MyNSThreadLoop
{
    NSLog(@"myNSThread enter");
    [[NSThread currentThread] setName:@"_MyNSThreadLoop"];
    
    // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    
    // autoreleasepool 会创建线程会自动添加 ??
    // works for any pthreads, not just NSThreads.
    // So basically, if you are running on OS X 10.9+ or iOS 7+,
    // autoreleasing on a thread without a pool should not lead to a leak.
    
    if ([NSRunLoop currentRunLoop] == nil) // 默认线程就有Runloop
    {
        NSLog(@"NSThread not runloop ?");
    }
    else
    {
        NSLog(@"NSThread has runloop: %@", [NSRunLoop currentRunLoop]);// 可以打印runloop的 source0/1 observers timers等  所有的common mode items等
    
    }
    
    {// 如果不加{} 分配的MyTimerTest会被这个函数一直持有; 另外这样说明了NSThread默认是有autoreleasepool的
        
        MyTimerTest* testor = [[MyTimerTest alloc] initWithId:12 withX:5.6 withY:-7.8];
        self->myNSThreadTimer = [NSTimer timerWithTimeInterval:5 target:testor selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self->myNSThreadTimer forMode:NSDefaultRunLoopMode];
        // [testor release]; // release' is unavailable: not available in automatic reference counting mode
    }

    
    // 开启当前线程的RunLoop，此处添加port是避免RunLoop退出
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];  // NSThread创建了Runnloop 但是不会自动运行
    
  
    // 打开下面一行, 该线程的runloop就会运行起来，timer才会起作用
    //[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    
 
    
    NSLog(@"myNSThread end ");
    
    // [pool release];
}

- (void) myTimerFunction
{
    NSLog(@"Timer Default runloop mode called ");
}

- (void) myUITrackingTimerFunction
{
    NSLog(@"Timer UITracking runloop mode called ");
}


//页面将要进入前台，开启定时器
- (void) viewWillAppear:(BOOL)animated
{
    // [NSDate distantPast]：表示过去的某个不可达到的事件点
    // [NSDate distantFuture]：表示未来的某个不可达到的事件点
    NSDate *date1 = [NSDate distantPast];
    NSDate *date2 = [NSDate distantFuture];
    NSLog(@"过于很久很久的时间,已经不能再过去了%@",date1); // 0001-01-01 00:00:00 +0000
    NSLog(@"未来某个时间点,不能去到的时间点%@",date2);    // 4001-01-01 00:00:00 +0000
    
    [self->myNSThreadTimer setFireDate:[NSDate distantPast]];
    
}


//页面消失，进入后台不显示该页面，关闭定时器
- (void) viewWillDisappear:(BOOL)animated
{
    [self->myNSThreadTimer setFireDate:[NSDate distantFuture]];
}


//------------------------------------------------------------------------------------------------------------------------
- (void) HandlePreformOnThreadButton
{
    NSLog(@"HandlePreformOnThreadButton before call thread:  %@", [NSThread currentThread].name);
    [self performSelector:@selector(performSelectorMethod:) onThread:self->myExitThread withObject:[NSThread currentThread].name waitUntilDone:NO];
    NSLog(@"HandlePreformOnThreadButton end ");
}

- (void) HandleExitThreadLoopButton
{
    NSLog(@"HandleExitThreadLoopButton start ");
    [self performSelector:@selector(performSelectorMethodForExit:) onThread:self->myExitThread withObject:[NSThread currentThread].name waitUntilDone:NO];
    NSLog(@"HandleExitThreadLoopButton end ");
}


- (void)performSelectorMethod:(NSString*) callThreadName
{
    NSLog(@"performSelectorMethod call thread name %@, process thread name %@", callThreadName, [NSThread currentThread].name);
}

- (void)performSelectorMethodForExit:(NSString*) callThreadName
{
    NSLog(@"performSelectorMethodForExit call thread name %@, process thread name %@", callThreadName, [NSThread currentThread].name);
    self->isLoopRunning = false ;
    CFRunLoopStop(CFRunLoopGetCurrent());
}


- (void) _MyNSThreadExitLoop
{
    [[NSThread currentThread] setName:@"_MyNSThreadExitLoop"];
    
    // 退出runloop方式 https://www.jianshu.com/p/24f875775336
    // - (void)run;
    //          如果runloop没有input sources或者附加的timer，runloop就会退出
    //          苹果并不建议我们这么做，因为系统内部有可能会在当前线程的runloop中添加一些输入源，
    //          所以通过手动移除input source或者timer这种方式，并不能保证runloop一定会退出
    // - (void)runUntilDate:(NSDate *)limitDate；
    //          可以通过设置超时时间来退出runloop 在超时时间到达之前，runloop会一直运行，
    //          在此期间runloop会处理来自输入源的数据，并且也会在NSDefaultRunLoopMode模式下重复调用runMode:beforeDate:方法；
    // - (void)runMode:(NSString *)mode beforeDate:(NSDate *)limitDate;
    //          runloop会运行一次，当超时时间到达或者第一个输入源被处理，runloop就会退出。
    //          如果我们想控制runloop的退出时机，而不是在处理完一个输入源事件之后就退出，
    //          那么就要重复调用runMode:beforeDate:
    // 无论通过哪一种方式启动runloop，如果没有一个输入源或者timer附加于runloop上，runloop就会立刻退出
    
   
    NSRunLoop *myLoop  = [NSRunLoop currentRunLoop];
    myPort = (NSMachPort *)[NSMachPort port];
    [myLoop addPort:myPort forMode:NSDefaultRunLoopMode];
    self->isLoopRunning = YES;
    
    while (isLoopRunning && [myLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]])
    {
        // 如果有 performSelector:onThread 会导致上面的runMode:beforeDate:退出一下
        NSLog(@"NSRunLoop runMode:beforeData loop outsize ");
    }
    
    NSLog(@"NSRunLoop runMode:beforeData loop exit  !!!!!!!!");
    
     
    // 等待要看的
    // https://www.jianshu.com/p/58f44609bd50 从零开始的Runloop实践02-使用ports 或custom input sources 和其他线程通信
    // https://juejin.cn/post/6844903606932471822 RunLoop终极解析:输入源，定时源，观察者，线程间通信，端口通信，NSPort，NSMessagePort，NSMachPort，NSPortMessage
    
}


//------------------------------------------------------------------------------------------------------------------------


/*
    什么是RunLoop https://juejin.cn/post/6844903981924220936
    OSX/iOS 系统中，提供了两个这样的对象：NSRunLoop 和 CFRunLoopRef。
    CFRunLoopRef 是在 Core Foundation 框架内的，它提供了纯 C 函数的 API，所有这些 API 都是线程安全的。它是基于pthread的。
    NSRunLoop 是基于 CFRunLoopRef 的封装，提供了面向对象的 API，但是这些 API 不是线程安全的。
    
    线程和RunLoop是一一对应的，其关系保存在一个全局的Dictionary里
    只能在一个线程内部获取其RunLoop对象（主线程RunLoop除外）
 
    main.m -> main -> UIApplicationMain UIApplicationMain函数内部为主线程开启了RunLoop
 
    两种来源 Input sources（输入源）和Timer sources（定时源)
 
    Core Foundation框架下有关于RunLoop的5个类
        CFRunLoopRef：       代表RunLoop的对象。
        CFRunLoopModeRef：   RunLoop的运行模式。
        CFRunLoopSourceRef： 就是RunLoop模型图中提到的输入源/事件源。
        CFRunLoopTimerRef：  就是RunLoop模型图中提到的定时源。
        CFRunLoopObserverRef：观察者，能够监听RunLoop的状态改变
    
    一个RunLoop对象（CFRunLoopRef）
        包含若干个运行模式（CFRunLoopModeRef）
        每个运行模式下又包含若干个输入源（CFRunLoopSourceRef）、定时源（CFRunLoopTimerRef）、观察者（CFRunLoopObserverRef）
 
    每次RunLoop启动时，只能选择一个运行模式启动，这个运行模式被称为CurrentMode; 如果要切换运行模式，只能退出RunLoop，并重新指定一个运行模式启动; ?? 这样使不同组的输入源、定时源、观察者互不影响
 
    运行模式
        kCFRunLoopDefaultMode：App的默认运行模式，通常主线程是在这个运行模式下运行。
        UITrackingRunLoopMode：跟踪用户交互事件（用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他Mode影响）
        UIInitializationRunLoopMode：在刚启动App时第进入的第一个 Mode，启动完成后就不再使用。
        GSEventReceiveRunLoopMode：接受系统内部事件，通常用不到。
        kCFRunLoopCommonModes：伪模式，不是一种真正的运行模式（后边会用到）  Common !
 
        开发中需要用到的模式: kCFRunLoopDefaultMode、UITrackingRunLoopMode、kCFRunLoopCommonModes

        由于NSRunLoopCommonModes不是一个真正的模式，并非需要中止其他模式再切换，只是其他mode可以用这个标记，来标记自己同时处理common队列的事件
 
    
         struct __CFRunLoopMode {
             CFStringRef _name;            // Mode Name, 例如 @"kCFRunLoopDefaultMode"
             CFMutableSetRef _sources0;    // Set
             CFMutableSetRef _sources1;    // Set      输入源
             CFMutableArrayRef _observers; // Array    观察者源
             CFMutableArrayRef _timers;    // Array    定时源
             ...
         };
          
        struct __CFRunLoop {
            // 这个runloop的 所以标记了common的mode 模式： 一个Mode可以将自己标记为“Common”属性: 将自己的ModelName添加到RunLoop中的_commonModes中
            CFMutableSetRef _commonModes;     // Set
            // runloop把common中 所有的输入源 定时源和观察者 都集合到这里 并且同步到 _commonModes中列举的所有mode中 这样每种mode在运行的时候, 都会执行commonModeItems的 输入源 定时源和观察者
            CFMutableSetRef _commonModeItems; // Set<Source/Observer/Timer>
            CFRunLoopModeRef _currentMode;    // Current Runloop Mode
            CFMutableSetRef _modes;           // Set
             ...
         };
    
        Source/Timer/Observer 被统称为 mode item，一个 item 可以被同时加入多个 mode。但一个 item 被重复加入同一个 mode 时是不会重复生效的。
        如果一个 mode 中一个 item 都没有，则 RunLoop 会直接退出，不进入循环
 
     
    CFRunLoopSourceRef分为两种   一种自动唤醒runloop一种不自动唤醒runloop
        Source0 只包含了一个回调（函数指针） 并不能主动触发事件
                    CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理
                    CFRunLoopWakeUp(runloop) 手动调用来唤醒 RunLoop，让其处理这个事件
        Source1 包含了一个 mach_port 和一个回调（函数指针）
                    被用于通过内核和其他线程相互发送消息 这种 Source 能主动唤醒 RunLoop 的线程
 
        点击事件是属于Sources0函数的，点击事件就是在Sources0中处理的。  main--CFRunLoopRun--CFRunLoopDoSources0
        Sources1，则是用来接收、分发系统事件，然后再分发到Sources0中处理的
 
 
    CFRunLoopObserverRef是观察者，用来监听RunLoop状态的改变
    typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
         kCFRunLoopEntry = (1UL << 0),               // 即将进入Loop：1
         kCFRunLoopBeforeTimers = (1UL << 1),        // 即将处理Timer：2
         kCFRunLoopBeforeSources = (1UL << 2),       // 即将处理Source：4
         kCFRunLoopBeforeWaiting = (1UL << 5),       // 即将进入休眠：32
         kCFRunLoopAfterWaiting = (1UL << 6),        // 即将从休眠中唤醒：64
         kCFRunLoopExit = (1UL << 7),                // 即将从Loop中退出：128
         kCFRunLoopAllActivities = 0x0FFFFFFFU       // 监听全部状态改变
     };
 
 ------------------------------------------------------------------------------------------------------
 RunLoop的应用场合
 
 AutoreleasePool:
 
    App启动后，ios在主线程 RunLoop 里注册了两个 Observer，其回调都是 _wrapRunLoopWithAutoreleasePoolHandler()
        第一个 Observer 监视的事件是：
            Entry(即将进入Loop)，其回调内会调用 _objc_autoreleasePoolPush() 创建自动释放池。
            其 order 是-2147483647，优先级最高，保证创建释放池发生在其他所有回调之前。
 
        第二个 Observer 监视了两个事件：
            BeforeWaiting(准备进入休眠) 时调用_objc_autoreleasePoolPop() 和 _objc_autoreleasePoolPush() 释放旧的池并创建新池；
            Exit(即将退出Loop) 时调用 _objc_autoreleasePoolPop() 来释放自动释放池。
            这个 Observer 的 order 是 2147483647，优先级最低，保证其释放池只发生在其他所有回调之后

 
    在主线程执行的代码，通常是写在诸如事件回调、Timer回调内的。
    这些回调会被 RunLoop 创建好的 AutoreleasePool 环绕着，所以不会出现内存泄漏，开发者也不必显式创建 Pool 了
 
 
 事件响应:
 
    ios注册了一个Source1（基于mach port）来接收系统事件
        如果发生硬件事件(触摸/锁屏/摇晃等)，Source1会触发回调__IOHIDEventSystemClientQueueCallback() ，
        函数内然后触发Source0，Source0再通过_UIApplicationHandleEventQueue() 分发到应用内部。
 
        _UIApplicationHandleEventQueue() 会把 IOHIDEvent 处理并包装成 UIEvent 进行处理或分发，
        其中包括识别 UIGesture/处理屏幕旋转/发送给 UIWindow 等。通常事件比如 UIButton 点击、touchesBegin/Move/End/Cancel 事件都是在这个回调中完成的

 手势识别
    当上面的_UIApplicationHandleEventQueue() 接收到一个手势时，其首先会调用 Cancel 将当前的 touchesBegin/Move/End 系列回调打断。
    随后系统将对应的 UIGestureRecognizer 标记为待处理
    ios注册了一个Observer来监听BeforeWaiting(即将进入休眠)，其回调函数内部会获取所有刚才标记了未处理的手势，并触发它们的回调
    当有 UIGestureRecognizer 的变化(创建/销毁/状态改变)时，这个回调都会进行相应处理 (?? 进入休眠前会处理一下之前的手势??)
 
 界面处理
    当在操作 UI 时，比如改变了 Frame、更新了 UIView/CALayer 的层次时，或者手动调用了 UIView/CALayer 的 setNeedsLayout/setNeedsDisplay方法后，
    这个 UIView/CALayer 就被标记为待处理，并被提交到一个全局的容器去
    IOS 注册了一个Observer来监听 BeforeWaiting(即将进入休眠) 和 Exit (即将退出Loop) 事件，
    并在回调函数里遍历所有待处理的 UIView/CAlayer 以执行实际的绘制和调整，并更新 UI 界面。（??RunLoop退出 处理UIView ??）
 
 定时器
    NSTimer实际也就相当于CFRunLoopTimerRef，他们之间是 toll-free bridged 的。
    一个 NSTimer 注册到 RunLoop 后，RunLoop 会为其重复的时间点注册好事件。例如 10:00, 10:10, 10:20 这几个时间点。
    RunLoop为了节省资源，并不会在非常准确的时间点回调这个Timer。
    Timer 有个属性叫做 Tolerance (宽容度)，标示了当时间点到后，容许有多少最大误差。
    如果某个时间点被错过了，例如执行了一个很长的任务，则那个时间点的回调也!!会跳过去!!，不会延后执行。就比如等公交，如果 10:10 时我忙着玩手机错过了那个点的公交，那我只能等 10:20 这一趟了。
 
    CADisplayLink是一个和屏幕刷新率一致的定时器（但实际实现原理更复杂 和 NSTimer 并不一样，其内部实际是操作了一个 Source）
    如果在两次屏幕刷新之间执行了一个长任务，那其中就会有一帧被跳过去（和 NSTimer 相似），造成界面卡顿的感觉。在快速滑动TableView时，即使一帧的卡顿也会让用户有所察觉。
 
 PerformSelector
    当调用 NSObject 的 performSelecter:afterDelay: 后，实际上其内部会创建一个 Timer 并添加到当前线程的 RunLoop 中。所以如果当前线程没有 RunLoop，则这个方法会失效。
    当调用 performSelector:onThread: 时，实际上其会创建一个Source0加到对应的线程去，同样的，如果对应线程没有 RunLoop 该方法也会失效

 关于GCD
    RunLoop底层会用到GCD的东西，GCD的实现也用到了RunLoop，比如dispatch_async()函数。
    当调用 dispatch_async(dispatch_get_main_queue(), block) 时，
    libDispatch 会向主线程的 RunLoop 发送消息，RunLoop会被唤醒，并从消息中取得这个 block，并在回调 CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE() 里执行这个 block。
    但这个逻辑仅限于 dispatch 到主线程，dispatch 到其他线程仍然是由 libDispatch 处理的

 
 
*/



@end
