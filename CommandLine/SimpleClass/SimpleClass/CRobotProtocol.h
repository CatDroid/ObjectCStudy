#ifndef CROBOT_PROTOCOL
#define CROBOT_PROTOCOL

@protocol CRobotProtocol

// 如果不实现,其实也不会报错.编译器只是会报警告
// 无论是@required还是@optional你都可以不实现. 编译器是不会报错的. 仍然可以编译 运行.
// 被@required修饰,不实现 编译器会发出警告
// 被@optional修饰,不实现 编译器也不会报警告
-(void)fire ;
-(void)recoveryToX:(int)x Y:(int)y ;

-(void)noImplementProtocolMethod ;

@end

#endif
