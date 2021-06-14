//
//  FilterViewController.m
//  CoreImageView
//
//  Created by hehanlong on 2021/6/7.
//

#import "FilterViewController.h"

@interface FilterViewController ()
{
    UIImageView* effectedImageView ;
    UIButton* filterButton1;
    UIButton* filterButton2;
}

@end

@implementation FilterViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    [self setupUI];
    
    NSLog(@"FilterView viewDidLoad ");
    
}

-(void) setupUI
{
    //UIImage* uiImage = [UIImage imageWithContentsOfFile:@"tansongyun.jpg"]; // nil
    UIImage* uiImage = [UIImage imageNamed:@"tansongyun.jpg"]; // 搜索 the asset catalog,
    
    CGRect size = CGRectMake(0, 0, 200, 300);
    CGPoint point = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.25); // UI控件原点是左上角
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:uiImage];
    imageView.contentMode = UIViewContentModeScaleAspectFit ; // 按比例缩放到满图显示,view剩余其他地方都是透明的 所以这个500x500的图片,没有把整个imageview外框显示出来
    imageView.frame = size;
    imageView.center = point;
    
    [self.view addSubview:imageView];
    
    effectedImageView = [[UIImageView alloc] initWithFrame:size];
    effectedImageView.contentMode = UIViewContentModeScaleAspectFit;
    effectedImageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.75);
    NSLog(@"backgroundColor %@" , effectedImageView.backgroundColor); // The default value of this property is nil, which corresponds to the default background color.
    effectedImageView.backgroundColor = [UIColor whiteColor]; // 这样才会显示出ImageView的大小 默认情况是全透明(nil) 跟View的背景颜色一样
    NSLog(@"effectedImageView bounds is %f,%f",  effectedImageView.bounds.size.width, effectedImageView.bounds.size.height); // 200.000000,300.000000
    
    [self.view addSubview:effectedImageView];
    
    filterButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    filterButton1.center = CGPointMake(50, self.view.frame.size.height * 6 / 8);
    [filterButton1 setTitle:@"滤镜1" forState:UIControlStateNormal]; // 未按下
    [filterButton1 setTitle:@"按下滤镜1" forState:UIControlStateHighlighted]; // 按下
    [filterButton1 setBackgroundColor:[UIColor orangeColor]];
    [filterButton1 setAlpha:0.6];
    [filterButton1 addTarget:self action:@selector(filter1Button:forEvent:) forControlEvents:UIControlEventTouchDown];
    // setBackgroundImage setTitle 都有 按下 聚集 释放 平时 等各种状态下 应该显示的文字和图片切换
    [self.view addSubview:filterButton1];
    
    
    filterButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    filterButton2.center = CGPointMake(50, self.view.frame.size.height * 7 / 8);
    [filterButton2 setTitle:@"滤镜2" forState:UIControlStateNormal];
    [filterButton2 setTitle:@"按下滤镜2" forState:UIControlStateHighlighted];
    [filterButton2 setBackgroundColor:[UIColor orangeColor]];
    [filterButton2 setAlpha:0.6];
    [filterButton2 addTarget:self action:@selector(filter2Button:forEvent:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:filterButton2];
    
}

#pragma mark - Filer

- (IBAction) filter1Button:(UIButton*)sender forEvent:(UIEvent*)event
{
    NSLog(@"use filter 1");
    
    
}

- (IBAction) filter2Button:(UIButton*)sender forEvent:(UIEvent*)event
{
    NSLog(@"use filter 2");
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
