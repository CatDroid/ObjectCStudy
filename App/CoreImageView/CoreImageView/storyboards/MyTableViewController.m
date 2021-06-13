//
//  MyTableViewController.m
//  CoreImageView
//
//  Created by hehanlong on 2021/6/12.
//

#import "MyTableViewController.h"
#import "ViewController.h"

@interface MyTableViewController ()

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"MyTableViewController viewDidLoad %p", self);
    
    // view controls stack 0 is <ViewController: 0x105e0ae10>
    // view controls stack 1 is <MyTableViewController: 0x106f05430>
    NSArray<UIViewController*> * ctrls = self.navigationController.viewControllers;
    [ctrls enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"view controls stack %lu is %@", idx, obj);
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    
    switch(row)
    {
        case 0:
            cell.textLabel.text = @"navigation controller pop to LAST view";
            cell.textLabel.textColor = [UIColor redColor];
            break;
        case 1:
            cell.textLabel.text = @"navigation controller pop to TOP view";
            cell.textLabel.textColor = [UIColor redColor];
            break;
    }
            
   return cell;

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// 在基于 xib-based 的应用
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = indexPath.row ;
    switch(row)
    {
        case 0:
        {
            UIViewController* vc= self.navigationController.viewControllers[ self.navigationController.viewControllers.count - 2];
            // 可以在这里设置返回参数
            [self.navigationController popToViewController:vc animated:NO];
            
            // 或者直接
            // [self.navigationController popViewControllerAnimated:YES];
        } break;
        case 1:
        {
            // 从任何页面 立刻返回 根页面
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } break;
    }
    
}



#pragma mark - Navigation

 // 在基于 storyboard的应用
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


-(void) viewWillDisappear:(BOOL)animated
{
   
    NSLog(@"MyTableViewController viewWillDisappear %p", self);
 
    // 到这里 stack已经没有了 当前这个页面
    NSArray<UIViewController*> * ctrls = self.navigationController.viewControllers;
    [ctrls enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"view controls stack %lu is %@", idx, obj);
    }];
    
    [super viewWillDisappear:animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"MyTableViewController viewDidDisappear %p", self);
    [super viewDidDisappear:animated];
}

@end
