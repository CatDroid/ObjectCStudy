//
//  ArgumentsViewController.m
//  CoreImageView
//
//  Created by hehanlong on 2021/6/13.
//

#import "ArgumentsViewController.h"

@interface ArgumentsViewController ()

@end

@implementation ArgumentsViewController

- (void)viewDidLoad { // 这里先执行，然后才是tableview的创建 
    [super viewDidLoad];
    
    // 由于ArgumentViewController 是 UITableViewContorller
    // 所以 如果storyboard下 对应这个ViewContorller的View 只是个UIView 就会崩溃
    // from storyboard "MyFirstStoryboard", but didn't get a UITableView.'
    
    // 所以要删除原来 storyboard 对应 viewcontroller scene下的view
    // 创建table view 并且和视图控制器的view outlet的关联（右键视图控制器 可以看到当前控制器所有outlet的关联）
    
    NSLog(@"通过segue传递的参数 tableDataSource %@", _tableDataSource);
    
    // tableViewCell使用重用机制 需要先注册id对应class
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mycell"];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // 通过ViewController传递的参数 来作为显示tableview的数据
    return _tableDataSource == NULL ? 0 : 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return _tableDataSource == NULL ? 0 : _tableDataSource.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // _dequeueReusableCellWithIdentifier:forIndexPath:usingPresentationValues:], UITableView.m:9037
    // 'NSInternalInconsistencyException', reason: 'unable to dequeue a cell with identifier cell
    // - must register a nib or a class for the identifier or connect a prototype cell in a storyboard'
    // 需要在 viewDidLoad 中 为一个id 注册对应的类(UITableViewCell或其派生类)
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    
    cell.textLabel.text = _tableDataSource[indexPath.row];
    
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
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.row;
    NSLog(@"ArgumentsViewController table cell seleted : %@", _tableDataSource[row]);
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
