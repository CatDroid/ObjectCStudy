//
//  XIBViewController.m
//  CoreImageView
//
//  Created by hehanlong on 2021/6/12.
//

#import "XIBViewController.h"

@interface XIBViewController ()

@end

@implementation XIBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
