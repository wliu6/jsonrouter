//
//  KSIMLoginAgent.h
//  kaiStart
//
//  Created by 王铎睿 on 2018/4/10.
//  Copyright © 2018年 KaiShiZhongChou. All rights reserved.
//

#import "NIMKit.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^KSIMLoginStatusTracingBlock)(BOOL needLogin);

/**
  login info 持久化独立于主(M)
 1. 登录、切换账号使用 + (void)login:(NSString *)account token:(NSString *)token completion:(NIMLoginHandler)completion;
 2. 退出登录使用 + (void)logout:(NIMLoginHandler)completion;
 */
@interface KSIMLoginAgent : NSObject
+ (void)login:(NSString *)account token:(NSString *)token completion:(NIMLoginHandler)completion;
+ (void)logout:(NIMLoginHandler)completion;

// 目前只做是否需要调主动登录作用
+ (void)traceLoginStatus:(KSIMLoginStatusTracingBlock)handler;
@end
NS_ASSUME_NONNULL_END
