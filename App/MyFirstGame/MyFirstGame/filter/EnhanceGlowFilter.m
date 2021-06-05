//
//  EnhanceGlowFilter.m
//  MyFirstGame
//
//  Created by hehanlong on 2021/6/5.
//

#import "EnhanceGlowFilter.h"

@implementation EnhanceGlowFilter

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


-(CIImage*) outputImage
{
    
    // self.inputImage;
    
    if (_outputImage != NULL)
    {
        return _outputImage;
    }
        
    
    CIImage* inputImage = [self valueForKey:@"inputImage"];
    if (!inputImage)
    {
        NSLog(@"inputImage is nil");
        return nil;
    }
    
    // 创建组成多个内置过滤器的CIFilter子类，在CoreImage中创建一个发光效果
    // 创建一个用作蓝色光晕的图像
    // Monochrome 一种是使用CIColorMatrix创建输入图像的单色版本
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [self.glowColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    CIFilter* monochromeFilter = [CIFilter filterWithName:@"CIColorMatrix"];
    [monochromeFilter setDefaults];
    [monochromeFilter setValue:[CIVector vectorWithX:0  Y:0  Z:0  W:red] forKey:@"inputRVector"];
    [monochromeFilter setValue:[CIVector vectorWithX:0  Y:0  Z:0  W:green] forKey:@"inputGVector"];
    [monochromeFilter setValue:[CIVector vectorWithX:0  Y:0  Z:0  W:blue] forKey:@"inputBVector"];
    [monochromeFilter setValue:[CIVector vectorWithX:0  Y:0  Z:0  W:alpha] forKey:@"inputAVector"];
    [monochromeFilter setValue:inputImage forKey:@"inputImage"]; // 输入纹理
    CIImage* glowImage = [monochromeFilter valueForKey:@"outputImage"];
    
    // Scale
    float centerX = [self.inputCenter X]; // CIVector
    float centerY = [self.inputCenter Y];
    if (centerX > 0)
    {
        CGAffineTransform transform = CGAffineTransformIdentity;// 仿射变换
        transform = CGAffineTransformTranslate(transform, centerX, centerY);
        transform = CGAffineTransformScale(transform, 1.2, 1.2); // 对于不在中心点 进行缩放
        transform = CGAffineTransformTranslate(transform, -centerX, -centerY);
        
        CIFilter* affineTransformFilter = [CIFilter filterWithName:@"CIAffineTransform"];
        [affineTransformFilter setDefaults];
        [affineTransformFilter setValue:[NSValue valueWithCGAffineTransform:transform] forKey:@"inputTransform"];
        [affineTransformFilter setValue:glowImage forKey:@"inputImage"];
        glowImage = [affineTransformFilter valueForKey:@"outputImage"];
    }
    
    
    // Blur 放大并模糊发光图像（CIAffineTransform + CIGaussianBlur）
    CIFilter* gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    [gaussianBlurFilter setValue:glowImage forKey:@"inputImage"];
    [gaussianBlurFilter setValue:self.inputRadius ?: @10.0 forKey:@"inputRadius"];
    glowImage = [gaussianBlurFilter valueForKey:@"outputImage"];
    
    
    // Blend 将原始输入图像合成在发光图像上（CISourceOverCompositing）
    CIFilter* blendFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [blendFilter setDefaults];
    [blendFilter setValue:glowImage forKey:@"inputBackgroundImage"];
    [blendFilter setValue:inputImage forKey:@"inputImage"];
    glowImage = [blendFilter valueForKey:@"outputImage"];
    
    
    _outputImage = glowImage;
    return glowImage;
}

/*
 高斯滤镜 半径越小越好, 或者换其他的模糊滤镜
    可能有一些方法可以从过滤器本身获得更好的性能。
    使用不同的CI滤镜，您可能会看到一些改进（Core Image中有几个模糊滤镜，其中一些肯定会比高斯滤镜更快）。
    另请注意，模糊效果往往是片段着色器绑定，因此图像越小，发光半径越小越好(!!!)
 
 如果您想在场景中有多个发光，请考虑将所有发光精灵制作为同一效果节点的子节点 - 将它们全部渲染到一个图像中，然后应用滤镜一次。
 
 
 
 
 
 */

@end
