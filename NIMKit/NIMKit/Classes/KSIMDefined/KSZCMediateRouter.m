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

- (NSInvocation *)kszc_invokeSelector:(SEL)aSelector withParams:(NSDictionary *)params
{
    NSMethodSignature *methodSign = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSign];
    [invocation setSelector:aSelector];
    [invocation setTarget:self];
    if (methodSign.numberOfArguments > 2) {
        [invocation setArgument:&params atIndex:2];
    }
    [invocation invoke];
    return invocation;
}

- (id)optimizedPerformSelector:(SEL)aSelector withParams:(NSDictionary *)params
{
    // Use for reference the famous Matcher Framework, that named Expecta. >>> https://github.com/specta/expecta/blob/master/Expecta/ExpectaSupport.m
    
    // FIXME: 获取返回值，记得校验！！！！！！
    NSMethodSignature *methodSign = [self methodSignatureForSelector:aSelector];
    const char *type = methodSign.methodReturnType;
    
    // Given a scalar or struct value, wraps it in NSValue
//    NSValue *value;
    // C99 or C99+ 不支持 void *(C指针) 转 scalar
//    if(strcmp(type, @encode(char)) == 0) {
//        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
//        char result;
//        [invocation getReturnValue:&result];
//        value = [NSNumber numberWithChar:result];
//    } else if(strcmp(type, @encode(BOOL)) == 0) {
//        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
//        BOOL result;
//        [invocation getReturnValue:&result];
//        value = [NSNumber numberWithBool:result];
//    } else if(strcmp(type, @encode(double)) == 0) {
//        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
//        double result;
//        [invocation getReturnValue:&result];
//        value = [NSNumber numberWithDouble:result];
//    } else if(strcmp(type, @encode(float)) == 0) {
//        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
//        float result;
//        [invocation getReturnValue:&result];
//        value = [NSNumber numberWithFloat:result];
//    } else if(strcmp(type, @encode(int)) == 0) {
//        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
//        int result;
//        [invocation getReturnValue:&result];
//        value = [NSNumber numberWithInt:result];
//    } else if(strcmp(type, @encode(long)) == 0) {
//        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
//        long result;
//        [invocation getReturnValue:&result];
//        value = [NSNumber numberWithLong:result];
//    } else if(strcmp(type, @encode(long long)) == 0) {
//        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
//        long long result;
//        [invocation getReturnValue:&result];
//        value = [NSNumber numberWithLongLong:result];
//    } else if(strcmp(type, @encode(short)) == 0) {
//        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
//        short result;
//        [invocation getReturnValue:&result];
//        value = [NSNumber numberWithShort:result];
//    } else if(strcmp(type, @encode(unsigned char)) == 0) {
//        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
//        unsigned char result;
//        [invocation getReturnValue:&result];
//        value = [NSNumber numberWithUnsignedChar:result];
//    } else if(strcmp(type, @encode(unsigned int)) == 0) {
//        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
//        unsigned int result;
//        [invocation getReturnValue:&result];
//        value = [NSNumber numberWithUnsignedInt:result];
//    } else if(strcmp(type, @encode(unsigned long)) == 0) {
//        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
//        unsigned long result;
//        [invocation getReturnValue:&result];
//        value = [NSNumber numberWithUnsignedLong:result];
//    } else if(strcmp(type, @encode(unsigned long long)) == 0) {
//        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
//        unsigned long long result;
//        [invocation getReturnValue:&result];
//        value = [NSNumber numberWithUnsignedLongLong:result];
//    } else if(strcmp(type, @encode(unsigned short)) == 0) {
//        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
//        unsigned short result;
//        [invocation getReturnValue:&result];
//        value = [NSNumber numberWithUnsignedShort:result];
//    }
//
//    if (value) {
//        return value;
//    }
    
    
    if ((strstr(type, @encode(id)) != NULL) || (strstr(type, @encode(Class)) != 0)) {
        // Class 和 NSObject 子类 -performSelector:withObject: 返回值正常。
        return [self diagnosticIgnoredLeaksPerformSelector:aSelector withObject:params];
    } else if(strcmp(type, @encode(__typeof__(nil))) == 0) {
        [self diagnosticIgnoredLeaksPerformSelector:aSelector withObject:params];
        return nil;
    } else if(strstr(type, @encode(void (^)(void))) != NULL) {
        // Blocks will be treated as vanilla objects, as of clang 4.1.
        return [self diagnosticIgnoredLeaksPerformSelector:aSelector withObject:params];
    } else if (strcmp(type, @encode(void)) == 0) {
        [self kszc_invokeSelector:aSelector withParams:params];
        void *result = (__bridge void *)@0;
        return (__bridge id)(result);
    } else {
        // 其他类型 swift tuple、struct 等
        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
        void *result;
        [invocation getReturnValue:&result];
        // ObjcType >>> NSInvocation，结构体得到返回值为NSValue nil
        NSValue *val = [NSValue value:&result withObjCType:type];
        return val;
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
    return CGSizeMake(12.f, 12.f);
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

/**
 *  缓存的目标对象，cell等
 *  @note   Class 不要 cache !!!
 */
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
    
    // 验证 action 能否响应
    SEL action = NSSelectorFromString(actionName);
    if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic pop
        NSObject *obj = [target optimizedPerformSelector:action withParams:params];
        KSZCMediateRouterLog(@"class:%@ === %@", obj.class, obj);
        if (shouldCacheTarget) {
            self.cachedTargets[targetName] = target;
        }
        return obj;
    }
    return nil;
}



- (id)performClassAction:(NSString *)actionName target:(NSString *)targetName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget
{
    // 验证 target class 是有存在
    Class target = NSClassFromString(targetName);// NSClassFromString() 等同于 objc_lookUpClass()
    if (!target) KSZCMediateRouterLog(@"%@", [NSThread callStackSymbols]);
    NSAssert(target, @"类目 [%@] 不存在", targetName);
    if (!target) return nil;
    
    // 验证 action 能否响应
    SEL action = NSSelectorFromString(actionName);
    if ([target respondsToSelector:action]) {
        NSObject *obj = [target optimizedPerformSelector:action withParams:params];
        return obj;
    }
    return nil;
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

