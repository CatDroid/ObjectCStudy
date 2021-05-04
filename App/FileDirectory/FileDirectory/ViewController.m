//
//  ViewController.m
//  FileDirectory
//
//  Created by hehanlong on 2021/5/4.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"---viewDidLoad------");
    // NSSearchPathDirectory 重要目录的位置
    // NSApplicationDirectory Supported applications (/Applications).
    // NSLibraryDirectory Various user-visible documentation, support, and configuration files (/Library).
    // NSDocumentDirectory 文档目录
    // NSMoviesDirectory   电影 (~/Movies).
    // NSMusicDirectory    音乐 (~/Music).
    // NSPicturesDirectory 图片 (~/Pictures).
    
    // NSSearchPathDomainMask 域常量，用于指定搜索重要目录时要使用的基本位置。
    // NSUserDomainMask  The user’s home directory—the place to install user’s personal items (~) 当前登录用户的目录
    
    // expandTilde 展开路径 ~/Documents -> /Users/hohan/Documents/
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* docPath = paths.firstObject ;
    NSString* docPath2 = paths.lastObject ;
    NSLog(@"firstObject %@", docPath);
    NSLog(@"lastObject  %@", docPath2);
    
    // /var/mobile/Containers/Data/Application/EA863310-BDC9-4E69-B1F3-9D3164421E1E/Documents
    for (NSString* path in paths) {
        NSLog(@"path=%@", path);
    }
 
    // /var/mobile/Containers/Data/Application/CC36EC44-33DF-4548-BC37-90DF171F6805/Documents/my.txt
    NSString* fullPath = [docPath stringByAppendingPathComponent:@"my.txt"];
    NSLog(@"fullPath = %@", fullPath);
    

    ///---------------------------------------------------------------------------------------------------------------------------------------------

    NSProcessInfo* info = [NSProcessInfo processInfo]; // 只读属性 property
    
    // 设备信息
    NSLog(@"活跃核心数目 %lu", info.activeProcessorCount); // iphoneXR 6cores
    NSLog(@"处理器数目 %lu", info.processorCount);
    NSLog(@"物理内存 %llu", info.physicalMemory);
    NSLog(@"主机名 %@", info.hostName); // hanlong-de-iphone.local
    NSLog(@"是否低电模式 %i",  info.lowPowerModeEnabled); // 低电模式
    NSLog(@"系统版本 %@",   info.operatingSystemVersionString);
   
    
    // 进程信息
    NSLog(@"-----env----start");
    NSDictionary<NSString*, NSString*>* env = info.environment;
//    for (NSString* key in env){
//        NSString* value = env[key];
//        NSLog(@"%@ - %@", key, value);
//    }
    [env enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* value, BOOL* stop) {
        NSLog(@"%@ - %@", key, value); // 使用块方式 遍历
    }];
    NSLog(@"-----env----end");
    
    NSArray<NSString*>* args = info.arguments;
    NSLog(@"-----args----start");
    for(NSString* arg in args) {
        NSLog(@"%@", arg);
    }
    NSLog(@"-----args----end");
    
    NSLog(@"processName=%@", info.processName); // 进程名字
    
    NSLog(@"NSUserName %@", NSUserName()); // mobile
    NSLog(@"NSFullUserName %@", NSFullUserName()); // Mobile User
    NSLog(@"NSHomeDirectory %@",  NSHomeDirectory()); // 应用的目录
   
   
    
    ///---------------------------------------------------------------------------------------------------------------------------------------------
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    // /private/var/mobile/Containers/Data/Application/013479E3-6AB5-432C-A028-B08F5D788708/tmp/
    NSString* tmpPath = NSTemporaryDirectory();
    NSLog(@"tmpPath = %@", tmpPath);
    
    tmpPath = [tmpPath stringByAppendingPathComponent:@"myDir"];
    
    // withIntermediateDirectories:YES 中间目录不存在就会创建进 mkdir -p
    NSError* createError = NULL;
    if ([fm createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:&createError] )
    {
        NSLog(@"创建目录成功");
    }
    else
    {
        NSLog(@"创建目录失败 已经存在 %@", createError);
    }

    
    
    NSString* guid = [NSProcessInfo processInfo].globallyUniqueString;
    NSLog(@"globallyUniqueString = %@", guid);
    guid = [NSProcessInfo processInfo].globallyUniqueString; // 每次都不一样
    NSLog(@"globallyUniqueString = %@", guid);
    
    guid = @"123456789";
    
    // 用uuid来命名 避免冲突
    NSString* fullTxtPath = [tmpPath stringByAppendingPathComponent:guid];
    fullTxtPath = [fullTxtPath stringByAppendingPathExtension:@"txt"];
    NSLog(@"fullTxtPath = %@", fullTxtPath);
    
    

    
    BOOL isDir = FALSE ;
    NSLog(@"目录是否存在 %i", [fm fileExistsAtPath:tmpPath isDirectory:&isDir] );
    NSLog(@"是否目录 %i", isDir);
    
    NSLog(@"文件是否存在 %i", [fm fileExistsAtPath:fullTxtPath]);
    NSLog(@"文件是否可读 %i", [fm isReadableFileAtPath:fullTxtPath]);
    NSLog(@"文件是否可写 %i", [fm isWritableFileAtPath:fullTxtPath]);
    
    
    if (![fm fileExistsAtPath:fullTxtPath])
    {
        NSString* str = @"hello world, test write to file\nsecond line\nthird line";
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding]; // NString 转 NSData
        UInt8* db = (UInt8*)data.bytes;
        
        NSLog(@"NSData len:%i bytes:%c %c %c %c", data.length, db[1], db[2], db[3], db[4] );
        
        // 写入文件 YES 会创建临时文件 写入完整后 才替换fullTxtPath
        // [str writeToFile:fullTxtPath atomically:YES encoding:NSUTF8StringEncoding error:nil]; // 这个方法都为覆盖
        
        // 会覆盖掉原来的文件
        if ([fm createFileAtPath:fullTxtPath contents:data attributes:nil])
        {
            NSLog(@"Create file & write ok ");
            
            // NSString提供方法从文件读取字符串
            NSError *error = nil;
            NSString *fileStr = [NSString stringWithContentsOfFile:fullTxtPath encoding:NSUTF8StringEncoding error:&error];
            NSLog(@"read from file to NSString %@", fileStr);
            
            // 使用NSFileHandle 读写文件 文件大小
            {
                NSFileHandle* handle = [NSFileHandle fileHandleForUpdatingAtPath:fullTxtPath];
                [handle seekToEndOfFile];
                
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString* dateStr = [dateFormatter stringFromDate:[NSDate date]];
                
                NSData* dataOfStr = [dateStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSError* error = NULL;
                [handle writeData:dataOfStr error:&error];
                if (error != NULL) {
                    NSLog(@"NSFileHandle writeData NSData error %@", error);
                }
                
                [handle closeFile];
                
            }
            
            
            {
                // 只读  如果没有文件 返回handle为null 但是依旧可以执行其他方法(消息传递 target可以是nil)
                NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:fullTxtPath];
                unsigned long long offset = [handle offsetInFile];
                NSLog(@"offsetInFile %llu", offset);
                unsigned long long fileSize = [handle seekToEndOfFile];
                NSLog(@"fileSize %llu", fileSize);
                [handle seekToOffset:0 error:nil];
                NSData* data = [handle readDataOfLength:fileSize];
                if (data != nil) {
                    char* d = (char*)data.bytes;
                    int i = 0;
                    for ( ; i < fileSize/4 ; i++)
                    {
                        NSLog(@"NSFileHandle readDataOfLength %c %c %c %c", d[i*4], d[i*4+1], d[i*4+2], d[i*4+3]);
                    }
                    if (fileSize % 4 == 3)  NSLog(@"NSFileHandle readDataOfLength %c %c %c ", d[i*4], d[i*4+1], d[i*4+2]);
                    else if (fileSize % 4 == 2)  NSLog(@"NSFileHandle readDataOfLength %c %c ", d[i*4], d[i*4+1]);
                    else if (fileSize % 4 == 1)  NSLog(@"NSFileHandle readDataOfLength %c ", d[i*4]);
                }
                [handle closeFile];

            }
            
        
        }
        else
        {
            NSLog(@"Create file & write fail ");
        }
    }
    else
    {
        NSError* errorInfo;
        
        NSString* targetFullPath = [tmpPath stringByAppendingPathComponent:guid];
        targetFullPath = [NSString stringWithFormat:@"%@_bak.txt", targetFullPath];
     
        
        if ( [fm copyItemAtPath:fullTxtPath toPath:targetFullPath error:&errorInfo] ) // 拷贝文件
        {
            NSLog(@"copy ok");
        }
        else
        {
            // copy fail Error Domain=NSCocoaErrorDomain Code=516  不是这个 NSUnderlyingError=0x2822af690 {Error Domain=NSPOSIXErrorDomain Code=17 "File exists"}}
            NSLog(@"copy fail %@", errorInfo);
            if (errorInfo.domain == NSCocoaErrorDomain && errorInfo.code == NSFileWriteFileExistsError)
            {
                if ([fm contentsEqualAtPath:targetFullPath andPath:fullTxtPath] ) // 文件对比
                {
                    NSLog(@"contentsEqualAtPath OK");
                    

                    // 删除一个还有文件的目录
                    NSError* rmError = NULL;
                    if ([fm removeItemAtPath:tmpPath error:&rmError])
                    {
                        NSLog(@"删除目录成功");
                    }
                    else
                    {
                        NSLog(@"删除目录失败 %@", rmError);
                    }
                }
                else
                {
                    NSLog(@"contentsEqualAtPath Fail");
                }
            }
            
          
        }
        
    }
    

    {
        
        // NSArray NSData NSString 都有 arrayWithContentsOfFile
        NSArray* fileArray = [NSArray arrayWithContentsOfFile:fullTxtPath];
        [fileArray enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL* stop)
         {
            NSLog(@"%lu %@", idx, object);
        }]; // 字符串和集合类型 都有方法写入文件和读取
        if (fileArray == NULL) {
            NSLog(@"NSArray arrayWithContentsOfFile fail");
        }
        
        NSData* fileData = [NSData dataWithContentsOfFile:fullTxtPath];
        if (fileData == NULL) {
            NSLog(@"NSData dataWithContentsOfFile fail");
        } else {
            // {length = 54, bytes = 0x68656c6c 6f20776f 726c642c 20746573 ... 69726420 6c696e65 }
            NSLog(@"NSData dataWithContentsOfFile done %@", fileData);
        }
        
        NSData* fileData2 = [fm contentsAtPath:fullTxtPath]; // 跟 NSData dataWithContentsOfFile 一样
        if (fileData2 == NULL) {
            NSLog(@"read file fail");
        } else {
            NSLog(@"file manager contentsAtPath->NSData done %@", fileData2);
        }
        
    }
    
    
   
    
    
    
}


@end
