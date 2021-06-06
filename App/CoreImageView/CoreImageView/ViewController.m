//
//  ViewController.m
//  CoreImageView
//
//  Created by hehanlong on 2021/6/6.
//

#import "ViewController.h"


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
 
    _dataSource = @[
        @"Filter的使用",
        @"采用GPU方式实时绘制",
        @"转场效果",
        @"人脸识别"
    ];
    
    // self.view.frame 和 self.view.bounds 区别 ??  创建TableView 指定大小 还有样式
    _tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableview.delegate = self ;    // 需要实现 <UITableViewDelegate> 协议
    _tableview.dataSource = self;   // 需要实现 <UITableViewDataSource> 协议
    _tableview.tableFooterView = [UIView new];
    [self.view addSubview:_tableview]; // 增加子View控件
}

// UITableViewDataSource 只有两个方法 是 必须要的
// Only two methods of this protocol are required, and they are shown in the following example code.

// tableview 每一行的 cell
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [indexPath dumpInfo];
    // dequeueReusableCellWithIdentifier:forIndexPath:
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row)
    {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            NSLog(@"unknown selection %li", indexPath.row);
            break;
    }
}

@end
