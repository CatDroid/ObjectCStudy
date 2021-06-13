//
//  XIBViewController.h
//  CoreImageView
//
//  Created by hehanlong on 2021/6/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XIBViewController : UIViewController
{
@public
    int paramtersFromLastViewController;
}

@property BOOL (^feedback) (int paramters, NSString* hints) ;

-(int) paramtersFromLastViewController;
-(void) setParamtersFromLastViewController:(int)paramId;

@end

NS_ASSUME_NONNULL_END
