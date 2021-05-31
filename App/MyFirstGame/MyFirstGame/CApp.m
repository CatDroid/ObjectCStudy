//
//  CApp.m
//  MyFirstGame
//
//  Created by hehanlong on 2021/5/23.
//

#import <Foundation/Foundation.h>
#import "CApp.h"


int gDeviceType = DT_IPHONE4;
CGSize gScreenSize = {320, 480};

void deviceInit()
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (screenSize.width == 1024 || screenSize.height == 1024)
    {
        gDeviceType = DT_IPAD;
        gScreenSize = screenSize;
    }
    else if (screenSize.width == 480 || screenSize.height == 480)
    {
        gDeviceType = DT_IPHONE4;
        gScreenSize = screenSize;
    }
    else
    {
        // iphone5和更新的iphone 同一使用568*320 因为都是16:9的
        gDeviceType = DT_IPHONE5;
        if (screenSize.width > screenSize.height)
        {
            gScreenSize = CGSizeMake(568, 320);
        }
        else
        {
            gScreenSize = CGSizeMake(320, 586);
        }
    }
    
}


