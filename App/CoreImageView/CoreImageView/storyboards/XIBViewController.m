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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
