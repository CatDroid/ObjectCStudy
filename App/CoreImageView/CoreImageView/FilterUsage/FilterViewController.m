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
    NSInteger filer1Index ;
    UIButton* filterButton0;
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
    NSString * path = [[NSBundle mainBundle] pathForResource:@"tansongyun.jpg" ofType:nil];
    UIImage* uiImage = [UIImage imageWithContentsOfFile:path]; // 这个path是个绝对路径 指向app容器中
    //UIImage* uiImage = [UIImage imageNamed:@"tansongyun.jpg"]; // 搜索 the asset catalog,
    
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
    
    
    filterButton0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    filterButton0.center = CGPointMake(50, self.view.frame.size.height * 5 / 8);
    [filterButton0 setTitle:@"bridge测试" forState:UIControlStateNormal]; // 未按下
    [filterButton0 setTitle:@"按下bridge" forState:UIControlStateHighlighted]; // 按下
    [filterButton0 setBackgroundColor:[UIColor orangeColor]];
    [filterButton0 setAlpha:0.6];
    [filterButton0 addTarget:self action:@selector(bridgeStringTest) forControlEvents:UIControlEventTouchDown];
    // setBackgroundImage setTitle 都有 按下 聚集 释放 平时 等各种状态下 应该显示的文字和图片切换
    [self.view addSubview:filterButton0];
    
    
    filterButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    filterButton1.center = CGPointMake(50, self.view.frame.size.height * 6 / 8);
    [filterButton1 setTitle:@"系统滤镜" forState:UIControlStateNormal]; // 未按下
    [filterButton1 setTitle:@"按下滤镜1" forState:UIControlStateHighlighted]; // 按下
    [filterButton1 setBackgroundColor:[UIColor orangeColor]];
    [filterButton1 setAlpha:0.6];
    [filterButton1 addTarget:self action:@selector(filter1Button:forEvent:) forControlEvents:UIControlEventTouchDown];
    // setBackgroundImage setTitle 都有 按下 聚集 释放 平时 等各种状态下 应该显示的文字和图片切换
    [self.view addSubview:filterButton1];
    
    
    filterButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    filterButton2.center = CGPointMake(50, self.view.frame.size.height * 7 / 8);
    [filterButton2 setTitle:@"图像增强" forState:UIControlStateNormal];
    [filterButton2 setTitle:@"按下滤镜2" forState:UIControlStateHighlighted];
    [filterButton2 setBackgroundColor:[UIColor orangeColor]];
    [filterButton2 setAlpha:0.6];
    [filterButton2 addTarget:self action:@selector(filter2Button:forEvent:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:filterButton2];
    
}


#pragma mark - CFAllocator

void *customAlloc(CFIndex size, CFOptionFlags hint, void *info)
{
    void* ptr = malloc(size);
    NSLog(@"分配内存 %p size = %ld", ptr, size);
    return ptr;
}

void *customRealloc(void *ptr, CFIndex newsize, CFOptionFlags hint, void *info)
{
    NSLog(@"警告:发生了内存重新分配");
    return NULL;//不写这个回调系统也是返回NULL的。这里简单的打句log。
}

void customDealloc(void *ptr, void *info)
{
    NSLog(@"释放内存 %p", ptr);
    free(ptr);
}

CFAllocatorRef customAllocator(void* contextInfo)
{
    CFAllocatorRef allocator = NULL;
    if (NULL == allocator)
    {
        /*
         typedef struct {
             CFIndex                                version;
             void *                                 info;
             CFAllocatorRetainCallBack              retain;
             CFAllocatorReleaseCallBack             release;
             CFAllocatorCopyDescriptionCallBack     copyDescription;
             CFAllocatorAllocateCallBack            allocate;
             CFAllocatorReallocateCallBack          reallocate;
             CFAllocatorDeallocateCallBack          deallocate;
             CFAllocatorPreferredSizeCallBack       preferredSize;
         } CFAllocatorContext;
         
         */
        CFAllocatorContext context = {0, contextInfo, NULL, NULL, NULL, customAlloc, customRealloc, customDealloc, NULL};
        allocator = CFAllocatorCreate(kCFAllocatorSystemDefault, &context);
    }
    return allocator ;
}

void releaseCustomAllocator(CFAllocatorRef allocator)
{
    CFAllocatorDeallocate(kCFAllocatorSystemDefault, (void*)allocator); // 不需要&取地址
}

-(void) bridgeStringTest
{
    CFAllocatorRef allocator = customAllocator(NULL);
    [self __bridgeStringTest: allocator];
    NSLog(@"return from __bridgeStringTest");
    // releaseCustomAllocator(allocator); // [testNS UTF8String]; 加上这里 release了 就不会出现 CFString释放??
}


-(void) __bridgeStringTest:(CFAllocatorRef) allocator
{
    
    //------------------------------------------------------------------------------------------------------------
    // char* <------> NSString
    //
    //
    const char *cString2 = "I am char";
    NSString* aNSString1 = [NSString stringWithUTF8String:cString2];
    NSLog(@"char* ------> CFStringRef:%@", aNSString1);
    

    //------------------------------------------------------------------------------------------------------------
    // NSString <------> CFString
    //
    //
    NSString *aNSString = @"NSString"; // typedef struct __CFString CFStringRef;
    CFStringRef aCFString = (__bridge CFStringRef)aNSString; // NSString -> CFStringRef
    NSString *bNSString = (__bridge NSString *)aCFString;    // CFStringRef -> NSString
    NSLog(@"NSString %p", aNSString);
    NSLog(@"NSString ------> CFStringRef : %@ ", aCFString );
    NSLog(@"CFStringRef ------> NSString : %@ %p class is %@", bNSString, bNSString, [bNSString class]); // __NSCFConstantString bNSString就是aNSString

    //------------------------------------------------------------------------------------------------------------
    // char* ------> CFStringRef
    //
    //
   
    char* cStringA = malloc(256); // char *cStringA = "测试字符串"; // 实际是const char*
    snprintf(cStringA, 256, "字符串-%s","测试字符串");
    NSLog(@"%s length is %lu", cStringA, strlen(cStringA)); // =  25 allocator分配给NSString 64
    
    //CFStringRef bCFString = CFStringCreateWithCString(NULL, cStringA, kCFStringEncodingUTF8);
    CFStringRef bCFString = CFStringCreateWithCString(allocator, cStringA, kCFStringEncodingUTF8); // 使用自己的Allocator来分析内存的释放
    free(cStringA);
    NSLog(@"char* ------> CFStringRef:%@", bCFString);
    
    // CFRelease(bCFString); // 放在这里 下面一句会 EXC_BAD_ACCESS 地址不是0
   
   
    //------------------------------------------------------------------------------------------------------------
    // CFStringRef ------> NSString
    //
    //
    NSString *testNS = (__bridge NSString *)bCFString;
    // CFRetain(CFTypeRef cf)
    
    // CFRelease和CGImageRelease的区别在于
    // CFRelease的参数不能为NULL，
    // CGImageRelease可以接受NULL参数
    
    CFRelease(bCFString); // 因为上面有NSString 所以到这里都不会释放 CFStringCreateWithCString 但如果没有了NSString 就会在这里返回前释放
    NSLog(@"调用 CFRelease 之后, __bridge的NSString %@ class:%@", testNS, [testNS class]); // __NSCFConstantString
    
    //------------------------------------------------------------------------------------------------------------
    // CFStringRef ------> char*
    //
    //
    const char *testC = [testNS UTF8String]; // !!! 这个返回的是NSString内部的 所以指针不用释放 但是要用到其他地方就要copy
    char *testCNew = (char *)malloc(strlen(testC) + 1); //  [testNS UTF8String]; 会导致 释放时间更加晚 在调用函数再返回之后才释放
    memcpy(testCNew, testC, strlen(testC) + 1);
    NSLog(@"CFStringRef ------> char* :%s",testCNew);
    free(testCNew);
    

    //------------------------------------------------------------------------------------------------------------
    CFStringRef justCFString = CFStringCreateWithCString(allocator, "hello world", kCFStringEncodingUTF8);
    NSLog(@"CFStringRef 没有__bridge转化成NSString %@", justCFString);
    CFRelease(justCFString);
    NSLog(@"因此, 上面的调用返回之前 就会释放了(观察allocator的dealloc打印)");
    
    // 要等所有使用的地方释放了，才能释放！
    // releaseCustomAllocator(allocator);
}

#pragma mark - Filer

- (UIImage*) addEffectName:(NSString*) filterName ToImage:(UIImage*) image
{
    // UIImage类的Core Graphics版本是CGImage（CGImageRef）
    // 这两个类之间很容易进行转换，因为一个UIImage类有一个CGImage的属性
    
    // 只有在UIImage是由CIImage提供时（比如它是由imageWithCIImage:生成的, UIImage的CIImage才不会是空值。
    //CIImage* ciImageIn = [image CIImage];
    CIImage* ciImageIn = [[CIImage alloc] initWithImage:image];
    
    CIFilter* filter = [CIFilter filterWithName:filterName];
    [filter setDefaults];
    [filter setValue:ciImageIn forKey:kCIInputImageKey]; // input的image是 CIImage, 需要从UIImage转换到CIImage
    CIImage* ciImage = [filter valueForKey:kCIOutputImageKey];
    
    UIImage* newImage;
    
    if (false)
    {
        // 需要真正获取输出 就必须通过CIContext
        CIContext* ciContext = [CIContext contextWithOptions:nil]; // GPU Context
        
        // CGImageRef是个结构体
        // C类对象的内存管理,不是由ARC管理的,所以需要考虑手动管理内存
        // CGImageRef 保存了 CIImage对象的强引用
        CGImageRef cgImage = [ciContext createCGImage:ciImage fromRect:ciImage.extent]; // 可以对图片进行裁剪
        newImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
    }
    else
    {
        // 这里不用CIContext也可以拿到UIImage和保存png图片
        newImage = [UIImage imageWithCIImage:ciImage]; // 这样设置给imageView.image也可以
        NSData* data = UIImagePNGRepresentation(newImage);
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* path = [paths.firstObject stringByAppendingPathComponent:@"imageWithCIImage.png"];
        BOOL success = [data writeToFile:path atomically:YES];
        if (success) {
            NSLog(@"imageWithCIImage.png done");
        } else {
            NSLog(@"imageWithCIImage.png fail");
        }
        
        NSLog(@"UIImage中的CIImage属性(只有通过imageWithCIImage创建才会有) %@ ", newImage.CIImage); // 跟ciImage是同一个对象 强引用
        NSLog(@"并且UIImage里就是引用imageWithCIImage传入的参数(强引用) %@ ", ciImage);
    }

    
    return newImage;
}

- (IBAction) filter1Button:(UIButton*)sender forEvent:(UIEvent*)event
{
    NSLog(@"use filter 1");
    
    NSArray<NSString*> * filterNameArray = @[
        @"CIPhotoEffectFade",
        @"CIPhotoEffectInstant",
        @"CIPhotoEffectMono",
        @"CIPhotoEffectNoir",
        @"CIPhotoEffectProcess",
        @"CIPhotoEffectTonal",
        @"CIPhotoEffectTransfer"];

    UIImage* originImage = [UIImage imageNamed:@"tansongyun.jpg"];
    
    UIImage* lastImage = originImage ;
    //for (int i = 0 ; i < 4 ; i++ ) {
    //    lastImage  = [self addEffectName:filterNameArray[i] ToImage:lastImage];
    //}
  
    lastImage  = [self addEffectName:filterNameArray[filer1Index] ToImage:lastImage];
    
    effectedImageView.image = lastImage ;
    
    filer1Index += 1;
    filer1Index = filer1Index % filterNameArray.count;
}

- (IBAction) filter2Button:(UIButton*)sender forEvent:(UIEvent*)event
{
    NSLog(@"use filter 2");
    
    
    
    // 从Cocoa Foundation转Core Foundation，ARC管理内存，不需要释放：
    // 从Core Foundation转Cocoa Foundation，需要开发者手动释放，不归ARC管：
    
    //
    
    
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
