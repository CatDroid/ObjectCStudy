//
//  EnhanceGlowFilter.m
//  MyFirstGame
//
//  Created by hehanlong on 2021/6/5.
//

#import "EnhanceGlowFilter.h"
#import <SpriteKit/SpriteKit.h>

// 创建组成多个内置过滤器的CIFilter子类，在CoreImage中创建一个发光效果
@implementation EnhanceGlowFilter
{
    BOOL logOnce ;
}

@synthesize outputImage = _outputImage;


-(instancetype) init
{
    self = [super init];
    if (self)
    {
        //self->_glowColor = [UIColor whiteColor];
        _glowColor = [UIColor whiteColor];// 可以不用->
    }
    return self;
}


-(CIImage*) outputImage // 这个重写了父类属性 outputImage 的get方法
{
    //---------------------------------------------------------------------------------------------------------------------
    //搜索属于 kCICategoryBuiltIn类别的所有滤镜名字，返回一个数组；
    if (!logOnce) {
        
        NSArray<NSString*>* filterNames = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
        [filterNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"filter %@", obj);
        }];
        
        // [CIFilter filterNamesInCategories:(nullable NSArray<NSString *> *)];//搜索所有可用的滤镜名称；
    }
 

    //---------------------------------------------------------------------------------------------------------------------
    
    // self.inputImage;
    
    if (_outputImage != NULL)
    {
        return _outputImage; // 本case输入没有变化 不再重复渲染
    }
        
    // CIImage是CoreImage框架中最基本代表图像的对象，他不仅包含元图像数据，还包含作用在原图像上的滤镜链。
    // 在CIImage被CIContext渲染出来之前，他是依赖于滤镜链的，滤镜是不会更改CIImage中的图像数据。
    //
    // Quick Look 可以直接看到CIImage整个滤镜链/卷积核参数
    //
    // CIImage*image=[CIImage imageWithContentsOfURL:myURL];
    // CIImage*image=[CIImage imageWithData:myData];
    // CIImage*image=[CIImage imageWithCGImage:myCgimage]; -- CGImage  CIImage是不能直接有UIImage转化而来的
    // CIImage*image=[CIImage imageWithCVPixelBuffer：CVBuffer]; -- CVPixelBuffer
    
    // CIImage* beginImage = [CIImage imageWithCVPixelBuffer:CMSampleBufferGetImageBuffer(imageSampleBuffer) options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], kCIImageColorSpace, nil]];

    // *** Quick Look ***
    // CIImage <0x2825a0300> 整个看不到图像 应该全部都是{r=0,g=0,b=0.a=0} 这时候 可能只是一个空的纹理 因为上一级还没有渲染
    // MTLTexture 0x2832f9fc0 RGBA8Unorm extent=[0 0 128 128](这个应该是大小) digest=1
    CIImage* inputImage = [self valueForKey:@"inputImage"];
    if (!inputImage)
    {
        NSLog(@"inputImage is nil");
        return nil;
    }
    else
    {
        NSLog(@"inputImage is %@", inputImage); // 每次都不一样的
    }
    
    // 用来测试 替换到上一级的输出 这样才可以看到滤镜的输出 保存滤镜输出 或者是使用quick lock
    
    // *** Quick Look ***
    // CIImage <0x28275c8d0> 可以看到图像 不只是全透明 不是全部{r=0,g=0,b=0,a=0}
    // affine [1 0 0 , 0 -1 123] (仿射变换)    extent=[0 0 144 123]  digest=D6E2CC4D84456A29
    // colormatch sRGB_to_workingspace        extent=[0 0 144 123]  digest=C7E772F3E8CF7B4A
    // IOSurface 0x28275c8c0(34) seed:1 RGBA8 extent=[0 0 144 123]  digest=2
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"Spaceship" withExtension:@"png"];
    inputImage = [CIImage imageWithContentsOfURL:url];
    
    //---------------------------------------------------------------------------------------------------------------------
    

    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [self.glowColor getRed:&red green:&green blue:&blue alpha:&alpha];
    

    // CIFilter用来表示CoreImage提供的各种滤镜。滤镜使用键-值来设置输入值
    
    // CIColorMatrix
    //      Monochrome 一种是使用CIColorMatrix创建输入图像的'单色版本' 创建一个用作蓝色光晕的图像
    //      颜色矩阵是一个 5x4 的矩阵
    //      第一行决定红色、第二行决定绿色、第三行决定蓝色、第四行决定了透明度。第五列是颜色的偏移量。
    //      图像的RGBA值则存储在一个5*1的颜色分量矩阵(向量) = {r,g,b,a,1}
    //
    //      color_matrix
    //          r=(0 0 0 1)    这样原来不透明的地方就变成 {r=1,g=1,b=0,a=0.5} 黄色 透明的地方就会是0
    //          g=(0 0 0 1)
    //          b=(0 0 0 0)
    //          a=(0 0 0 0.5)   这个矩阵乘 颜色向量 {r,g,b,a}
    //
    //      该滤镜可以很方便的调整图片中RGBA各分量的值
    //          设置inputImage为CIRandomGenerator生成的随机噪点图
    //          设置inputRVector、inputGVector和inputBVector为(0,1,0,0) // g分量不是0的地方 都是1
    //          设置inputBiasVector为(0,0,0,0)
    //          蓝绿色磨砂图滤镜
    CIFilter* monochromeFilter = [CIFilter filterWithName:@"CIColorMatrix"];
    NSLog(@"monochromeFilter = %@", [monochromeFilter class]); // monochromeFilter = CIColorMatrix
    [monochromeFilter setDefaults];
    [monochromeFilter setValue:[CIVector vectorWithX:0  Y:0  Z:0  W:red] forKey:@"inputRVector"];
    [monochromeFilter setValue:[CIVector vectorWithX:0  Y:0  Z:0  W:green] forKey:@"inputGVector"];
    [monochromeFilter setValue:[CIVector vectorWithX:0  Y:0  Z:0  W:blue] forKey:@"inputBVector"];
    [monochromeFilter setValue:[CIVector vectorWithX:0  Y:0  Z:0  W:alpha] forKey:@"inputAVector"]; // 与源颜色值相乘的alpha量
    // biasVector  A vector that’s added to each color component.
    [monochromeFilter setValue:inputImage forKey:kCIInputImageKey]; // 输入纹理 kCIInputImageKey = “inputImage”
    CIImage* glowImage = [monochromeFilter valueForKey:@"outputImage"]; // 输出纹理 coreImage = filter.outputImage;
    
    // 渲染时机
    //      这里获取输出的图像，不会进行实际的图像渲染，他只包含一个对输入图像的引用以及需要应用与数据上的滤镜链
    //      ??? IOS永远在最佳的时间选择渲染图像
    //      当你请求去输出图像时，Core Image组装并保存要生成一个输出图像的运算步骤（保存到一个CIImage对象中)。只有在你显式调用一个图像绘制方法时，实际的图像才会被渲染。
    //      ??? 将处理延迟到渲染的时候，使得Core Image 快速而高效。在渲染的时候，Core Image会判断是否有超过一个滤镜需要作用到一个图像上。如果是这样，它自动把多个配方连接成一个操作
    //      ??? 对于一个大图像，在大小调整之前，应用颜色调整，比先做大小调整，之后再应用颜色调整，需要更多的处理资源。 通过将滤镜处理操作延迟到渲染的时候，Core Image可以按照最高效的处理顺序来执行操作
    
    if (!logOnce) {
        /*
         调用[CIFilter attributes]会返回filter详细信息
         
         滤镜属性
                filer attribute CIAttributeReferenceDocumentation: // 参考文档
                    http://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIColorMatrix
         
                filer attribute inputAVector:{ // 滤镜输入参数inpuAVector的类型是CIVector
                    CIAttributeClass = CIVector;
                    CIAttributeDefault = "[0 0 0 1]";
                    CIAttributeDescription = "The amount of alpha to multiply the source color values by.";
                    CIAttributeDisplayName = "Alpha Vector";
                    CIAttributeIdentity = "[0 0 0 1]";
                }
                filer attribute inputBVector:{
                    CIAttributeClass = CIVector;
                    CIAttributeDefault = "[0 0 1 0]"; // 滤镜参数的默认值
                    CIAttributeDescription = "The amount of blue to multiply the source color values by.";
                    CIAttributeDisplayName = "Blue Vector";
                    CIAttributeIdentity = "[0 0 1 0]";
                }
                filer attribute inputImage: { // 滤镜输入参数 CIImage* inputImage
                    CIAttributeClass = CIImage;
                    CIAttributeDescription = "The image to use as an input image. For filters that also use a background image, this is the foreground image.";
                    CIAttributeDisplayName = Image;
                    CIAttributeType = CIAttributeTypeImage;
                }
                .....
         */
        NSDictionary<NSString *,id>* filterAttribute = [monochromeFilter attributes];
        [filterAttribute enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
                NSLog(@"filer attribute %@:%@", key, value);
        }];
    }

    

 
    // __block
    CIImage * _outImage = monochromeFilter.outputImage; // 区别 ??
    
    // 渲染时机
    //      如果到达滤镜末，则调用CIContext渲染CIImage对象。这个context可以是基于CPU或GPU的，
    //      基于CPU的产出CGImageRef对象，基于GPU的调用OpenGL ES在屏幕上画出结果，默认是基于CPU的。
    //      在使用CoreImage时，一定要记住CIImage对象在开始时不会操作图像数据，直到使用CIContext渲染图片是才会这么做
    //      最好在后台执行图像处理的操作，然后在主线程中修改界面
    
    // GCD(中央调度 多线程优化技术)
    //      GCD,全称是Grand Central Dispatch,它是C语言的API. GCD的核心 : 将block(任务)添加到queue(队列)中.
    //      为了防止阻塞主线程，用GCD异步执行滤镜与渲染操作，在获取渲染后的照片以后，返回主线程进行界面的更新
    
    // 调度方式dispatch_after  dispatch_async
    // 调度时间 dispatch_time
    // 调度队列 dispatch_get_global_queue dispatch_get_main_queue
   
#ifdef DISPATCH_MAIN
    dispatch_async(dispatch_get_main_queue(), ^{ // 在主线程中执行
        [self saveImage:_outImage ToFile:@"CIColorMatrix_main.png"];
    });
#elif defined(DISPATCH_BACKGOUND)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), // dispatch_time(dispatch_time_t when, int64_t delta);
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self saveImage:_outImage ToFile:@"CIColorMatrix_back.png"];
    });
#else
    [self saveImage:_outImage ToFile:@"CIColorMatrix_sync.png"];
#endif

 
    // Scale
    float centerX = [self.inputCenter X]; // CIVector
    float centerY = [self.inputCenter Y];
    if (centerX > 0)
    {
        CGAffineTransform transform = CGAffineTransformIdentity;// 仿射变换
        transform = CGAffineTransformTranslate(transform, centerX, centerY); // 64
        transform = CGAffineTransformScale(transform, 1.2, 1.2); // 对于不在中心点 进行缩放
        transform = CGAffineTransformTranslate(transform, -centerX, -centerY);
        
        CIFilter* affineTransformFilter = [CIFilter filterWithName:@"CIAffineTransform"];
        [affineTransformFilter setDefaults];
        [affineTransformFilter setValue:[NSValue valueWithCGAffineTransform:transform] forKey:@"inputTransform"];
        [affineTransformFilter setValue:glowImage forKey:@"inputImage"];
        glowImage = [affineTransformFilter valueForKey:@"outputImage"];
        
        // affine
        // 1.2 0    -12.8
        // 0   1.2  -12.8
        // extent=[-12.8 -12.8 172.8 147.6] digest=25CBAE5982BCBE5C  // 原来图片 [0 0 144 123] 144x1.2=172.8 123x1.2=147.6
        
        [self saveImage:glowImage ToFile:@"CGAffineTransform.png"];
    }
    
    
    // Blur 放大并模糊发光图像（CIAffineTransform + CIGaussianBlur）
    // CIImage <0x282820770>
    // crop [-43 -43 233 208] extent=[-43 -43 233 208] digest=61AFD4D33C4CAE74  裁剪  实际保存的只有233x208 没有负数部分
    // kernel _cubicUpsample10 src scale=[0.125 0.125] extent=[-64 -64 272 248] digest=5B84E4368B6FF0DB 上采样
    // kernel _gaussianBlur3  src offset0=[0 0.26353 0 0] extent=[-6 -6 30 27] digest=39CA70CA14B5E3BF
    // kernel _gaussianBlur3  src offset0=[0.26353 0 0 0] extent=[-6 -5 30 25] digest=52B1C13FCC6EDE99
    // kernel _gaussianReduce2 src scale=[1 2 0 1] extent=[-5 -5 28 25] digest=9DAEBE99116ACB27
    // kernel _gaussianReduce2 src scale=[2 1 1 0] extent=[-5 -5 28 41] digest=7AB0F3322FE1D482
    // kernel _gaussianReduce4 src scale=[1 4 0 1] extent=[-5 -5 47 41] digest=FE749FB7619A4AA3
    // kernel _gaussianReduce4 src scale=[4 1 1 0] extent=[-5 -13 47 148] digest=80420F4A8F63FA5A
    //
    CIFilter* gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    [gaussianBlurFilter setValue:glowImage forKey:@"inputImage"];
    [gaussianBlurFilter setValue:self.inputRadius ?: @10.0 forKey:@"inputRadius"];
    glowImage = [gaussianBlurFilter valueForKey:@"outputImage"];
    [self saveImage:glowImage ToFile:@"CIGaussianBlur.png"];
    
    
    // Blend 将原始输入图像合成在发光图像上（CISourceOverCompositing）
    // colorkernel _srcOver src=(0)  dst=(1) extent=[-43 -43 233 208] digest=84405ECE5C9F2CAE
    CIFilter* blendFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [blendFilter setDefaults];
    [blendFilter setValue:glowImage forKey:@"inputBackgroundImage"];
    [blendFilter setValue:inputImage forKey:@"inputImage"];
    glowImage = [blendFilter valueForKey:@"outputImage"];
    [self saveImage:glowImage ToFile:@"CISourceOverCompositing.png"];
    
    
    //[self saveImage:glowImage ToFile:@"final.png"];
    
    
    _outputImage = glowImage;
    
    logOnce = true ;
    
    return glowImage;
    
    /*
     CIDetector用来分析CIImage，得到CIFeature。
     每个CIDetector都要用一个探测器来初始化，这个类型高数探测器要在图像中寻找什么特征。
     当一个CIDetector分析一张图片时，返回一个探测到的CIFeature的数组，
     
     如果CIDetector 被初始化为寻找面孔，那么返回的数组会被填上CIFaceFeature对象，
     每个CIFaceFeature都包含一个面部的CGrect引用(按照图像的坐标系)，以及检测到的面孔的左眼，右眼，嘴部位置的CGPoint;
     
     +(NSArray *) featuresWithImage:(UIImage *)img content:(CIContext*)content
     {
         CIDetector * detector =[CIDetector detectorOfType:CIDetectorTypeFace context:content options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
         CIImage * ciImage =[CIImage imageWithCGImage:img.CGImage];
         NSArray * features =[detector featuresInImage:ciImage];
         return features;
     }
     
     CoreImage坐标系左下角为原点，UI坐标系左上角为圆点
     */
}

// 需要确保ciImage滤镜链上最开始的CIImage不是空纹理{r=0,g=0,b=0,a=0}
-(void) saveImage:(CIImage*) ciImage ToFile:(NSString*) fileName
{
    /*
     
     CIContext用来渲染CIImage，将作用在CIImage上的滤镜链应用到原始的图片数据中。CIContext可以是基于CPU的，也可以是基于GPU的。
     
     * 这两种渲染的区别是：
        使用CPU渲染的IOS会采用GCD来对图像进行渲染，这保证了CPU渲染在大部分情况下更可靠，比CPU渲染更容易使用，他可以在后台实现渲染过程；
        使用GPU渲染的IOS会采用OpenGL ES2.0来渲染图像，这种方式CPU完全没有负担，应用程序的运行循环不会受到图像渲染的影响，而且他渲染比CPU渲染更快但是GPU渲染无法在后台运行(当 App 切换到后台状态时 GPU 处理会被打断)。GPU受限于硬件纹理尺寸。

     * 对于如何选择更好的渲染方式，我认为应该视具体情况而定：
        对于复杂的图像滤镜使用GPU更好
        但是如果在处理视频并保存文件，或保存照片到照片库中时为避免程序退出对图片保存造成影响，这时应该使用CPU进行渲染。
     
     [CIContext contextWithOptions:] CPU或GPU都支持。
     要定义使用哪个，需要设置一个选项字典，增加键kCIContextUserSoftwareRenderer，并设置相应的布尔值。
     默认情况是用CPU渲染的。<<< 默认应该是GPU ???
     
     // 'EAGLContext' is deprecated: first deprecated in iOS 12.0
     EAGLContext * eagContent =[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
     CIContext * context =[CIContext contextWithEAGLContext:eagContent];
     
     第一种：基于CPU的CIContext对象
        CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:kCIContextUseSoftwareRenderer]];//CPU渲染
      
     第二种：基于GPU的CIContext对象
        CIContext * ciContext =[CIContext contextWithOptions:nil];
      
     第三种：基于OpenGL优化的CIContext对象。
        EAGLContext * eagContent =[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
        CIContext * context =[CIContext contextWithEAGLContext:eagContent]; // 基于原来的EAGLContext
     
     
     CGContextRef context = UIGraphicsGetCurrentContext(void); // 这个是UI的context 不是CIFilter的context:CIContext

     The OpenGL rendering context that SceneKit uses for rendering the scene.
        In macOS, the value of this property is a Core OpenGL CGLContextObj object.
        In iOS, the value of this property is an EAGLContext object.
     
     EAGLContext* context = [EAGLContext currentContext];
     'EAGLContext' is deprecated: first deprecated in iOS 12.0 - OpenGLES API deprecated. (Define GLES_SILENCE_DEPRECATION to silence these warnings)
      
     */
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGRect rect = [ciImage extent];
    
    NSLog(@"%@ rect = %f,%f  %f,%f", fileName, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    // 这里会触发真正的渲染操作
    CGImageRef cgImage = [context createCGImage:ciImage fromRect:[ciImage extent]];
    
    NSLog(@"%@ being saved has width of: %zu", fileName, CGImageGetWidth(cgImage));
    NSLog(@"%@ being saved has height of: %zu", fileName, CGImageGetHeight(cgImage));
    
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage];

    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:fileName];  // 保存文件的名称
    
    BOOL result = [UIImagePNGRepresentation(uiImage) writeToFile:filePath atomically:YES]; // 保存成功会返回YES
    if (result == YES)
    {
        NSLog(@"%@ 保存成功 ", fileName);
    }
    
    //ALAssetsLibrary *library = [ALAssetsLibrary new];
    //[library writeImageToSavedPhotosAlbum:cgimage metadata:[outputImage properties] completionBlock:^(NSURL *assetURL NSError *error) {
    // CGImageRelease(cgimg);
    //}];
    
    
}
/*
 高斯滤镜 半径越小越好, 或者换其他的模糊滤镜
    可能有一些方法可以从过滤器本身获得更好的性能。
    使用不同的CI滤镜，您可能会看到一些改进（Core Image中有几个模糊滤镜，其中一些肯定会比高斯滤镜更快）。
    另请注意，模糊效果往往是片段着色器绑定，因此图像越小，发光半径越小越好(!!!)
 
    ??? 如果您想在场景中有多个发光，请考虑将所有发光精灵制作为同一效果节点的子节点 - 将它们全部渲染到一个图像中，然后应用滤镜一次
    ??? 如果要发光的精灵没有太大变化（例如，如果我们的飞船没有旋转）， 在效果节点上将CIVector设置为shouldRasterize应该会有很大帮助。 （实际上，在这种情况下，您可以通过旋转效果节点而不是其中的精灵来获得一些改进。
 
 做成贴纸
    你真的需要实时发光吗？与游戏中的许多漂亮的图形效果一样，如果你伪造它，你会获得更好的性能。
    在你最喜欢的图形编辑器中制作一个模糊的蓝色太空船，并将其作为另一个精灵放在场景中
 
 */

@end
