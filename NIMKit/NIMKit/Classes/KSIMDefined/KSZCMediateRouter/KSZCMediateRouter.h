//
//  KSZCMediateRouter.h
//  KSIMUIKit
//
//  Created by 王铎睿 on 2018/4/23.
//

#import <Foundation/Foundation.h>

@interface KSZCMediateRouterValue: NSObject
@end

// !!!: 目前不考虑 swift cmd
// !!!: 可以随意调 private method，但不建议
@interface KSZCMediateRouter : NSObject
+ (instancetype)router;

// default retun type KSZCMediateRouterValue（scalar or struct value）
- (id)performAction:(NSString *)actionName target:(NSString *)targetName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

// default retun type KSZCMediateRouterValue（scalar or struct value）
- (id)performClassAction:(NSString *)actionName target:(NSString *)targetName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

@end
