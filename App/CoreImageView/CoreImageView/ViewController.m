//
//  ViewController.m
//  CoreImageView
//
//  Created by hehanlong on 2021/6/6.
//

#import "ViewController.h"
#import "FilterViewController.h"

// StoryBoard XIB等方式创建ViewController
#import "MyFirstStoryboardViewController.h"
#import "XIBViewController.h"
#import "MyTableViewController.h"

// @interface ViewController : UIViewController 这个是继承
// @interface ViewController() 这个是匿名类别/类扩展

// Extension是Category的一个特例。类扩展与分类相比只少了分类的名称，所以称之为“匿名分类”。

// 类扩展 作用 ！！
//      因为没有给名字,所以可以叫做匿名类别,他允许你定义消息,属性,变量和方法
//      匿名类别的主要作用是一些 ”属性和方法” 你只想在类内部使用,不需要暴露给外部类引用头文件时被看到,就可以用匿名类别来定义.
//      比较常用的是在私下遵守一些协议,不需要暴露在公共头文件中.


/*
 
 @interface XXX ()
 //私有属性
 //私有方法（如果不实现，编译时会报警,Method definition for 'XXX' not found）
 @end
 
 
 
 类别与类扩展的区别：
 a. 属性增加
    1. 类别中原则上只能增加方法（能添加属性的的原因只是通过runtime解决无setter/getter的问题而已）
    2. 类扩展不仅可以增加方法，还可以增加实例变量（或者属性），只是该实例变量默认是@private类型的
        （使用范围只能在自身类，而不是子类或其他地方）
 
 b. 方法不实现
    1.类扩展中声明的方法没被实现，编译器会报警，但是类别中的方法没被实现编译器是不会有任何警告的。
    2.这是因为类扩展是在编译阶段被添加到类中，而类别是在运行时添加到类中
 
 c. implementation部分
    1.类扩展不能像类别那样拥有独立的实现部分（@implementation部分）
    2. 也就是说，‘类扩展所声明的方法’ 必须依托对应‘类的实现部分’来实现。 ---> 所以类扩展一般都用在m文件中
 
 d. 类扩展方法私有公有
    定义在 .m 文件中的类扩展方法为私有的，
    定义在 .h 文件（头文件）中的类扩展方法为公有的 --- 没有见过这种情况
    类扩展是在 .m 文件中声明私有方法的非常好的方式
 
 */


@interface ViewController () <UITableViewDelegate,UITableViewDataSource> // 类扩展 声明要实现的协议

@property (nonatomic, strong) UITableView* tableview;
@property (nonatomic, strong) NSArray* dataSource;

@end

@interface NSIndexPath(ExtendNSIndexPath)
@end

@implementation NSIndexPath(ExtendNSIndexPath)
-(void) dumpInfo
{
    NSLog(@"NSIndexPath(%p) length=%lu item=%li %li-%li", self, self.length, self.item , self.section, self.row);
    // length=2 item=0 0-0
    // length=2 item=3 0-3
}
@end



@implementation ViewController
{
    // 这里不能声明属性
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 修改APP默认的storyboard, Targets--App--General--DeploymentInfo--Main interface(主交互界面)--切换storyboard
    
    // storyboard 设置 main entry （程序启动需要一个 "根视图控制器"）(Main.storyboard的根视图控制器)
    // 在Main.storyboard中 找到一个 单向的箭头 拖到到其他View上 即可
    // (或者) 先选中viewcontroller，然后勾选Is Initial View Controller，然后这个控制器的左侧就会出现一个箭头指向这个视图控制器
    
    // storyboard 增加 Navigation Bar
    // 在Main.storyboard中 点击最右上角的 +  搜索Navigation Controller 创建, 然后可删除默认创建的ViewContorl
    
    // 父子关系
    // 通过Ctrl+拖拽 建立Navigation Controller与ViewContorl的父子关系
    
 
    // 新建storyboard--默认是空白的--右上角+---搜索ViewContorller--添加之后会多了View Contorller Scene
    // -- 勾选 is initial view contoller (设置为这个storyboard的main entry)
    // 创建一个ViewContorller类（集成UIViewController） 并把新建的storyboard的class设置为这个ViewController
    
 
    _dataSource = @[
        @"Filter的使用",
        @"采用GPU方式实时绘制",
        @"转场效果",
        @"人脸识别",
        @"切换storyboard方式创建的ViewControler(VC)",
        @"切换xib方式创建的VC(控制器传参数/返回值)",
        @"切换xib方式创建的TableViewControler"
    ];
    
    // self.view.frame 和 self.view.bounds 区别 ??  创建TableView 指定大小 还有样式
    _tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableview.delegate = self ;    // 需要实现 <UITableViewDelegate> 协议
    _tableview.dataSource = self;   // 需要实现 <UITableViewDataSource> 协议
    _tableview.tableFooterView = [UIView new];
    [self.view addSubview:_tableview]; // 增加子View控件
}

//-----------------------------------------------------------------------------------------------
// UITableViewDelegate 协议
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     切换ViewController
     
     [self.navigationController pushViewController:(nonnull UIViewController *) animated:(BOOL)]; // 调用pushViewController
     [self presentViewController:(nonnull UIViewController *) animated:(BOOL) completion:^(void)completion]; // 调用presentViewController
     
     
     pushViewController
     1. 是作用于navigationController的  必须保证当前页面有导航栏 navigationController
     2. 把一个视图压入栈，然后显示出来，这样可以方便查找之前的视图，能够直接退回到之前的任意一个视图。
     
     presentViewController
     1. 作用在viewConroller上, 在当前页面没有导航栏的时候 也可以使用。
     2. 直接显示一个视图，这样每次就只能退回到前面的那一个视图。
     3. 在一直使用pushViewController的导航之间，一旦使用了presentViewController，当前界面的导航栏navigationController就会变成空的，那么pushViewController也就没办法使用了。
        这时，如果想要再次使用pushViewController，就必须重新设置导航栏 navigationController
        不过，这样的话，当前视图就会变成根视图（rootViewController），而之前导航链里面的视图也找不到了。
     
     pushViewController 和presentViewController退回到之前视图的方法：
     [self.navigationController popToViewController:(nonnull UIViewController *) animated:(BOOL)];//pushViewController 退回
     [self dismissViewControllerAnimated:(BOOL) completion:^(void)completion]；// presentViewController退回
     
     */
    switch(indexPath.row)
    {
        case 0:
            {
                UIViewController* ctl = [FilterViewController new];
                [self.navigationController pushViewController:ctl animated:TRUE];
            }
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
        {
            // ------------------------------------------------------------------------------------------------
            // ViewController对象的创建方式
            // 可视化编程的类的创建坚持一个原则就不会有问题.就是
            // 1. 如果是XIB就用XIB的方式创建，
            // 2. 如果是Storyboard就用Storyboard的方式创建，不要用 [[类名 alloc] init]
            // 3. 如果是纯代码编程就用[[类名 alloc] init]
           
            // ------------------------------------------------------------------------------------------------
            // 下面使用方式2 StoryBoard的方式创建ViewController对象
            
            // 在storyboard中指定根视图控制器的创建方式
            //通过加载storyboard创建ViewController
            //仅仅是加载了名为Storyboard的storyboard，并不会创建Storyboard中的控制器以及控件
            UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"MyFirstStoryboard" bundle:nil];
            MyFirstStoryboardViewController *testVC = [myStoryBoard instantiateInitialViewController];
            [self.navigationController pushViewController:testVC animated:YES];
            
            // 在storyboard中不是根视图控制器的创建方式（非entry point）  需要在可视化文件中设置对应的viewcontroller Identifier 为  viewC
            // UIStoryboard *myStoryBoard = UIStoryboard storyboardWithName:@"MyFirstStroyboard" bundle:nil];
            // TestViewController* viewC = [myStoryBoard instantiateViewControllerWithIdentifier:@“viewC"];
            
        } break;
        case 5:
        {
            // ------------------------------------------------------------------------------------------------
            // 下面使用方式1 XIB的方式创建ViewController对象
            
            // 创建ViewController类的时候 可以勾选 also create xib file
            // 1. 这样会创建xib文件(view)
            // 2. 并且xib文件的File's Owner custom class设置为新建的VIewController
            
            // 在xib文件中，
            // File’s Owner就是控制器 可以设置Custom Class为自己创建的ViewControl类
            // View就是视图 也就是 Viewcontroller中的self.view（这个需要关联）这个View也可以设置自己的Custom Class(继承View或者UITableViewCell)
            
            // View和File's Owner(ViewContorller) 关联
            // 1. 从File’s Owner按住control往View身上拽
            // 2. 弹出菜单Outlets中选择view
            // 3. 这样，viewcontroller中的view就是我们可视化xib文件中的View了
            
            
            XIBViewController *testVC = [[XIBViewController alloc] initWithNibName:@"XIBViewController" bundle:nil];
            // 这里的NibName是XIB的文件名字
            // 通过代码来创建的ViewController对象 传递参数
            // 传入参数 可以直接在这里给下一个控制器传入参数
            // 返回值   控制器之间的逆向传值, 通过block方式或者协议
            testVC.feedback = ^ BOOL (int paramters, NSString* hints) {
                
                NSMutableArray* newDataSource = [NSMutableArray arrayWithCapacity:self->_dataSource.count];
                
                // Block捕获的自动变量添加 __block 说明符，就可在Block内读和写该变量，也可以在原来的栈上读写该变量。
                // __block 发挥作用的原理：将栈上用 __block 修饰的自动变量封装成一个结构体，让其在堆上创建，以方便从栈上或堆上访问和修改同一份数据。
                
                __block NSUInteger refreshIdx = -1 ;  // 需要增加 __block
                
                // Block implicitly retains 'self'; explicitly mention 'self' to indicate this is intended behavior
                // [_dataSource enumerateObjectsUsingBlock:
                [self->_dataSource enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj containsString:@"控制器传参数"])
                    {
                        NSString* ns = [NSString stringWithFormat:@"(控制器传参数)控制器返回值:%i,%@", paramters,hints];
                        [newDataSource addObject:ns];
                        refreshIdx = idx ;
                    }
                    else
                    {
                        [newDataSource addObject:obj];
                    }
                    
                }];
                //   NSMutableArray 是 NSArray 的子类 所以不用转换
                self->_dataSource = newDataSource ;
                
                
                // TableView 刷新局部的cell  如果NSINdexPath不存在 会出现 _UIAssertValidUpdateIndexPath
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:refreshIdx inSection:0];
                [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
                
                return true ;
            };
            testVC.paramtersFromLastViewController = 2021 ;
            [self.navigationController pushViewController:testVC animated:YES];
            
        } break;
            
        case 6:
        {
            // 创建cocoa class 选择基类为TableViewController 并且勾选上also create xib
            // 这样创建的xib文件 就有了TableView 并且
            // 1. TableView的outlet delegate和datasource都指向了 file owner
            // 2. TableView的reference outlet显示被 file's owner.view 这个outlet引用了(也就是被viewcontorller.view引用了)
            // 3. file's owner custom class 指向自定义的viewcontrloer
            
            
            // Outlets 和 Reference Outlets  区别
            // Outlets  本身拥有的outlet   里面显示的是你的属性, 以及连接着的目标.
            // Reference Outlets 被哪些outlet引用了自己 当前View被连接到了别人的属性上面.
            MyTableViewController* tblVC = [[MyTableViewController alloc] initWithNibName:@"MyTableViewController" bundle:nil];
            [self.navigationController pushViewController:tblVC animated:YES];
            
            
        } break;
           
        default:
            NSLog(@"unknown selection %li", indexPath.row);
            break;
    }
}

//-----------------------------------------------------------------------------------------------
// UITableViewDataSource 只有两个方法 是 必须要的
// Only two methods of this protocol are required, and they are shown in the following example code.

// tableview 每一行的 cell
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [indexPath dumpInfo];
    // dequeueReusableCellWithIdentifier:forIndexPath:
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"]; // TableViewCell重用机制
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

// 返回行的数目
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"行的数目 %lu", _dataSource.count);
    return _dataSource.count;
}

/*  UITableViewDelegate协议 还有很多
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    <#code#>
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    <#code#>
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    <#code#>
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    <#code#>
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    <#code#>
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    <#code#>
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    <#code#>
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    <#code#>
}

- (void)setNeedsFocusUpdate {
    <#code#>
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    <#code#>
}

- (void)updateFocusIfNeeded {
    <#code#>
}
*/



@end
