//
//  KSIMFileAssistant.m
//  kaiStart
//
//  Created by 王铎睿 on 2018/4/10.
//  Copyright © 2018年 KaiShiZhongChou. All rights reserved.
//

#import "KSIMFileAssistant.h"

@implementation KSIMFileAssistant
+ (NSString *)basicDocumentPath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/KSIMUtil"];
    NSFileManager *manager = NSFileManager.defaultManager;
    if (![manager fileExistsAtPath:path]) {
        NSError *error;
        BOOL success = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        NSAssert(success && !error, @"目录 KSIMUtil 创建失败");
    }
    return path;
}

+ (NSString *)loginInfoFilePath
{
    return [KSIMFileAssistant subpath:@"/LoginInfo.ksb"];
}

// !!!: private methods
+ (NSString *)subpath:(NSString *)subpath
{
    return [KSIMFileAssistant.basicDocumentPath stringByAppendingPathComponent:subpath];
}
@end
