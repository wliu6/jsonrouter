//
//  KSZCMediateRouter.m
//  KSIMUIKit
//
//  Created by 王铎睿 on 2018/4/23.
//

#ifdef DEBUG
#define KSZCMediateRouterLog(FORMAT, ...) fprintf(stderr,"\n====== KSZCMediateRouter Module\n%s\n[%s %s]\nFile: %s\nLine: %d\ndesc: >>> Log info show up, on next line >>> \n%s\n======\n", __FUNCTION__, __DATE__, __TIME__, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define KSZCMediateRouterLog(FORMAT, ...) {}
#endif

@interface NSObject (KSZCMediateRouter)

@end
@implementation  NSObject (KSZCMediateRouter)
- (id)diagnosticIgnoredLeaksPerformSelector:(SEL)aSelector withObject:(id)object
{
    // Ignored Leaks warnings, after LLVM 8.2.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:aSelector withObject:object];
#pragma clang diagnostic pop
}

- (id)optimizedPerformSelector:(SEL)aSelector withObject:(id)object
{
    NSMethodSignature *ms = [self methodSignatureForSelector:aSelector];
    const char *type = ms.methodReturnType;
    
    // Given a scalar or struct value, wraps it in NSValue
    // Use for reference the famous Matcher Framework, that named "expecta"
    if ((strstr(type, @encode(id)) != NULL) || (strstr(type, @encode(Class)) != 0)) {
        // Class 和 NSObject 子类 -performSelector:withObject: 返回值正常。
        return [self diagnosticIgnoredLeaksPerformSelector:aSelector withObject:object];
    } else if(strcmp(type, @encode(__typeof__(nil))) == 0) {
        [self diagnosticIgnoredLeaksPerformSelector:aSelector withObject:object];
        return nil;
    } else if(strstr(type, @encode(void (^)(void))) != NULL) {
        // Blocks will be treated as vanilla objects, as of clang 4.1.
        return [self diagnosticIgnoredLeaksPerformSelector:aSelector withObject:object];
    } else if (strcmp(type, @encode(void)) == 0) {
        [self diagnosticIgnoredLeaksPerformSelector:aSelector withObject:object];
        void *result = (__bridge void *)@0;
        return (__bridge id)(result);
    }
    return nil;
}
@end

#import "KSZCMediateRouter.h"
@implementation KSZCTestA
- (void)aaa
{
    return;
}

- (CGFloat)bbb
{
    return 12.f;
}

- (CGSize)ccc
{
    return CGSizeZero;
}

- (instancetype)ddd
{
    return self.class.new;
}

- (id)eee
{
    return [UIColor redColor];
}

- (id)fff
{
    return KSZCMediateRouter.new;
}

- (Class)ggg
{
    return KSZCMediateRouter.class;
}

- (void (^)(void))hhh
{
    return ^(){
        
    };
}

- (NSSet *)iii
{
    return NSSet.new;
}

- (NSArray *)jjj
{
    return NSArray.new;
}

- (NSDictionary *)kkk
{
    return NSDictionary.new;
}
@end

#import <objc/runtime.h>
@interface KSZCMediateRouter ()
@property (nonatomic, strong) NSMutableDictionary *cachedTargets;
@end

@implementation KSZCMediateRouter

+ (instancetype)router
{
    static KSZCMediateRouter *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = KSZCMediateRouter.new;
    });
    return router;
}

- (id)performAction:(NSString *)actionName target:(NSString *)targetName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget
{
    // 验证 target class 是有存在
    Class targetClass = NSClassFromString(targetName);// NSClassFromString() 等同于 objc_lookUpClass()
    if (!targetClass) KSZCMediateRouterLog(@"%@", [NSThread callStackSymbols]);
    NSAssert(targetClass, @"类目 [%@] 不存在", targetName);
    if (!targetClass) return nil;
    
    NSObject *target = self.cachedTargets[targetName];
    if (!target) {
        target = targetClass.new;
    }
    if (!target) KSZCMediateRouterLog(@"%@", [NSThread callStackSymbols]);
    NSAssert(target, @"类目 [%@] 的实例无法捕获", target);
    if (!target) return nil;
    
    // TODO: 验证 action 能否响应
    SEL action = NSSelectorFromString(actionName);
    if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSObject *obj = [target performSelector:action withObject:params];
        KSZCMediateRouterLog(@"class:%@ === %@", obj.class, obj);
#pragma clang diagnostic pop
        if (shouldCacheTarget) {
            self.cachedTargets[targetName] = target;
        }
    }
    return nil;
}

- (instancetype)aaa
{
    return [self.class new];
}


#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTargets
{
    if (_cachedTargets == nil) {
        _cachedTargets = [@{} mutableCopy];
    }
    return _cachedTargets;
}
@end
