//
//  KSIMSessionConfig.h
//  kaiStart
//
//  Created by 王铎睿 on 2018/4/11.
//  Copyright © 2018年 KaiShiZhongChou. All rights reserved.
//
#import "NIMKit.h"

typedef NS_ENUM(NSUInteger, KSIMSessionMode) {
    KSIMSessionDefaultMode,
    // 以下按业务应用场景划分
    KSIMSessionP2PMode, // 私聊
    KSIMSessionTeamMode, // 共建群
    KSIMSessionCommentMode, // 评论
    KSIMSessionSystemNoticeMode, // 系统通知
};

@interface KSIMSessionConfig : NSObject <NIMSessionConfig>
@property (nonatomic, assign) KSIMSessionMode mode;
+ (instancetype)defaultConfig;
+ (instancetype)p2pConfig;
+ (instancetype)teamConfig;
@end
