//
//  KSZCMediateRouter.m
//  KSIMUIKit
//
//  Created by 王铎睿 on 2018/4/23.
//

#import "KSZCMediateRouter.h"

#ifdef DEBUG
#define KSZCMediateRouterLog(FORMAT, ...) fprintf(stderr,"\n====== KSZCMediateRouter Module\n%s\n[%s %s]\nFile: %s\nLine: %d\ndesc: >>> Log info show up, on next line >>> \n%s\n======\n", __FUNCTION__, __DATE__, __TIME__, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define KSZCMediateRouterLog(FORMAT, ...) {}
#endif


@interface KSZCMediateRouterValue()
@property (nonatomic, strong) NSValue *val;
@property (nonatomic, assign) NSUInteger valueLength;
@end
@implementation KSZCMediateRouterValue
- (instancetype)initWithValue:(NSValue *)value valueLength:(NSUInteger)length
{
    self = [super init];
    if (self) {
        self.val = value;
        self.valueLength = length;
    }
    return self;
}

// !!!: Get a scalar value from NSValue
- (char)charValue
{
    if(strcmp(self.val.objCType, @encode(char)) == 0) {
        char result;
        [self.val getValue:&result];
        return result;
    }
    return CHAR_MIN;
}

- (BOOL)boolValue
{
    if(strcmp(self.val.objCType, @encode(BOOL)) == 0) {
        BOOL result;
        [self.val getValue:&result];
        return result;
    }
    return NO;
}

- (double)doubleValue
{
    if(strcmp(self.val.objCType, @encode(double)) == 0) {
        double result;
        [self.val getValue:&result];
        return result;
    }
    return DBL_MIN;
}

- (float)floatValue
{
    if(strcmp(self.val.objCType, @encode(float)) == 0) {
        float result;
        [self.val getValue:&result];
        return result;
    }
    return FLT_MIN;
}

- (int)intValue
{
    if(strcmp(self.val.objCType, @encode(int)) == 0) {
        int result;
        [self.val getValue:&result];
        return result;
    }
    return INT_MIN;
}

- (long)longValue
{
    if(strcmp(self.val.objCType, @encode(long)) == 0) {
        long result;
        [self.val getValue:&result];
        return result;
    }
    return LONG_MIN;
}

- (long long)longLongValue
{
    if(strcmp(self.val.objCType, @encode(long long)) == 0) {
        long long result;
        [self.val getValue:&result];
        return result;
    }
    return LONG_LONG_MIN;
}

- (short)shortValue
{
    if(strcmp(self.val.objCType, @encode(short)) == 0) {
        short result;
        [self.val getValue:&result];
        return result;
    }
    return (short)INT_MIN; // -32768
}

- (unsigned char)unsignedCharValue
{
    if(strcmp(self.val.objCType, @encode(unsigned char)) == 0) {
        unsigned char result;
        [self.val getValue:&result];
        return result;
    }
    return (unsigned char)0;// 0~255
}

- (unsigned int)unsignedIntValue
{
    if(strcmp(self.val.objCType, @encode(unsigned int)) == 0) {
        unsigned int result;
        [self.val getValue:&result];
        return result;
    }
    return (unsigned int)0;
}

- (unsigned long)unsignedLongValue
{
    if(strcmp(self.val.objCType, @encode(unsigned long)) == 0) {
        unsigned long result;
        [self.val getValue:&result];
        return result;
    }
    return (unsigned long)0;
}

- (unsigned long long)unsignedLongLongValue
{
    if(strcmp(self.val.objCType, @encode(unsigned long long)) == 0) {
        unsigned long long result;
        [self.val getValue:&result];
        return result;
    }
    return (unsigned long long)0;
}

- (unsigned short)unsignedShortValue
{
    if(strcmp(self.val.objCType, @encode(unsigned short)) == 0) {
        unsigned short result;
        [self.val getValue:&result];
        return result;
    }
    return (unsigned short)0;
}



// !!!: Get a struct value from NSValue. (UIGeometryExtensions)
- (CGPoint)pointValue
{
    return self.val.CGPointValue;
}

- (CGVector)vectorValue
{
    return self.val.CGVectorValue;
}

- (CGSize)sizeValue
{
    return self.val.CGSizeValue;
}

- (CGRect)rectValue
{
    return self.val.CGRectValue;
}

- (CGAffineTransform)affineTransformValue
{
    return self.val.CGAffineTransformValue;
}

- (UIEdgeInsets)edgeInsetsValue
{
    return self.val.UIEdgeInsetsValue;
}

- (NSDirectionalEdgeInsets)directionalEdgeInsetsValue API_AVAILABLE(ios(11.0),tvos(11.0),watchos(4.0))
{
    return self.val.directionalEdgeInsetsValue;
}

- (UIOffset)offsetValue NS_AVAILABLE_IOS(5_0)
{
    return self.val.UIOffsetValue;
}

@end

@interface NSObject (KSZCMediateRouter)

@end
@implementation  NSObject (KSZCMediateRouter)
- (id)diagnosticIgnoredLeaksPerformSelector:(SEL)aSelector withObject:(id)object
{
    // Ignored Leaks warnings, after LLVM 8.0+.
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
    NSMethodSignature *methodSign = [self methodSignatureForSelector:aSelector];
    const char *type = methodSign.methodReturnType;
    
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
        NSInvocation *invocation = [self kszc_invokeSelector:aSelector withParams:params];
        @try {
            //
            // Given a scalar or struct value, wraps it in NSValue.
            void *result;
            [invocation getReturnValue:&result];
            NSValue *val = [NSValue value:&result withObjCType:type];
            return [[KSZCMediateRouterValue alloc] initWithValue:val valueLength:methodSign.methodReturnLength];
        } @catch (NSException *exception) {
            // 其他类型 swift tuple、struct 等(包括 未知类型)
            KSZCMediateRouterLog(@"%@", exception);
        } @finally {
            
        }
    }
    return nil;
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
    NSAssert([target respondsToSelector:action], @"类目 [%@] 的实例不响应函数 >> %@", targetName, actionName);
    if ([target respondsToSelector:action]) {
        NSObject *obj = [target optimizedPerformSelector:action withParams:params];
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
    NSAssert([target respondsToSelector:action], @"类目 [%@] 的实例不响应函数 >> %@", targetName, actionName);
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

