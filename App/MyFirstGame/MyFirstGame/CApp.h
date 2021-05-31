//
//  CApp.h
//  MyFirstGame
//
//  Created by hehanlong on 2021/5/23.
//

#ifndef CApp_h
#define CApp_h


#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#define DT_IPHONE4 4
#define DT_IPHONE5 5
#define DT_IPAD 1000

extern int gDeviceType ;
extern CGSize gScreenSize ;

void deviceInit(void);

#endif /* CApp_h */
