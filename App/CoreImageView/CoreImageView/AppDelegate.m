//
//  AppDelegate.m
//  CoreImageView
//
//  Created by hehanlong on 2021/6/6.
//

#import "AppDelegate.h"

@interface AppDelegate ()

// Illegal redeclaration of property in class extension 'AppDelegate' (attribute must be 'readwrite', while its primary must be 'readonly')
//@property (nonatomic, readwrite, strong) UIWindow * window;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (@available(iOS 13.0,*)) {
        
        // @available放在函数，类或者协议前面。表明这些类型适用的平台和操作系统
        //
        // @available(iOS 9, *)必须包含至少2个特性参数，
        // 其中iOS 9表示必须在 iOS 9 版本以上才可用。如果你部署的平台包括 iOS 8 , 在调用此方法后，编译器会报错
        // 另外一个特性参数：星号（*），表示包含了所有平台
        // 
        // @available(iOS 9, *)是一种简写形式。全写形式是@available(iOS, introduced=9.0)。
        //
        // @available(iOS 8.0, OSX 10.10, *) 这样也是可以的。表示同时在多个平台上（iOS 8.0 及其以上；OSX 10.10及其以上）的可用性。
        //
        
    } else {
        // IOS 13 及 后续会遇到崩溃
        // -[AppDelegate setWindow:]: unrecognized selector sent to instance
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor grayColor];
      
        UIViewController* vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor purpleColor];
        UISwitch* s = [[UISwitch alloc] init]; // 创建控件
        [vc.view addSubview:s]; // 控件设置到view中
        
        // 设置为window的根控制器
        self.window.rootViewController = vc ;
        
        //让创建的UIWindow成为主窗口并显示出来
        [self.window makeKeyAndVisible];
    }
    
   
    
    

                   
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
