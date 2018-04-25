//
//  KSZCMediateRouter.h
//  KSIMUIKit
//
//  Created by 王铎睿 on 2018/4/23.
//

#import <Foundation/Foundation.h>

@interface KSZCMediateRouterValue: NSObject
// !!!: Get a scalar value from NSValue
- (char)charValue;
- (BOOL)boolValue;
- (double)doubleValue;
- (float)floatValue;
- (int)intValue;
- (long)longValue;
- (long long)longLongValue;
- (short)shortValue;
- (unsigned char)unsignedCharValue;
- (unsigned int)unsignedIntValue;
- (unsigned long)unsignedLongValue;
- (unsigned long long)unsignedLongLongValue;
- (unsigned short)unsignedShortValue;

// !!!: Get a struct value from NSValue.
- (CGPoint)pointValue;
- (CGVector)vectorValue;
- (CGSize)sizeValue;
- (CGRect)rectValue;
- (CGAffineTransform)affineTransformValue;
- (UIEdgeInsets)edgeInsetsValue;
- (NSDirectionalEdgeInsets)directionalEdgeInsetsValue API_AVAILABLE(ios(11.0),tvos(11.0),watchos(4.0));
- (UIOffset)offsetValue NS_AVAILABLE_IOS(5_0);
@end

// !!!: 目前不考虑 swift cmd
// !!!: 可以随意调 private method，但不建议
// !!!: URI解释器带封装，目前只用作 native router，并且参数需要去 model 化!!!
@interface KSZCMediateRouter : NSObject
+ (instancetype)router;

// default retun type KSZCMediateRouterValue（scalar or struct value）
- (id)performAction:(NSString *)actionName target:(NSString *)targetName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

// default retun type KSZCMediateRouterValue（scalar or struct value）
- (id)performClassAction:(NSString *)actionName target:(NSString *)targetName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

@end
