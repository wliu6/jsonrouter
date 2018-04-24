//
//  KSZCMediateRouter.h
//  KSIMUIKit
//
//  Created by 王铎睿 on 2018/4/23.
//

#import <Foundation/Foundation.h>
@interface KSZCTestA: NSObject
- (void)aaa;
- (CGFloat)bbb;
- (CGSize)ccc;
@end

// !!!: 目前不考虑 swift cmd
@interface KSZCMediateRouter : NSObject
+ (instancetype)router;

- (id)performAction:(NSString *)actionName target:(NSString *)targetName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

@end
