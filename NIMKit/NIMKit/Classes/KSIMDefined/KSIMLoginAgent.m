//
//  KSIMLoginAgent.m
//  kaiStart
//
//  Created by 王铎睿 on 2018/4/10.
//  Copyright © 2018年 KaiShiZhongChou. All rights reserved.
//

#import "KSIMLoginAgent.h"
#import "KSIMFileAssistant.h"

NSString * const KSIMLoginAccount = @"account";
NSString * const KSIMLoginToken = @"token";

@interface KSIMLoginInfo: NSObject <NSCoding>
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *token;
@end

@implementation KSIMLoginInfo
+ (instancetype)loginInfoWithAccount:(NSString *)account token:(NSString *)token
{
    KSIMLoginInfo *info = KSIMLoginInfo.new;
    if (info) {
        info.account = account.copy;
        info.token = token.copy;
    }
    return info;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _account = [aDecoder decodeObjectForKey:KSIMLoginAccount];
        _token = [aDecoder decodeObjectForKey:KSIMLoginToken];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    if ([_account length]) {
        [encoder encodeObject:_account forKey:KSIMLoginAccount];
    }
    if ([_token length]) {
        [encoder encodeObject:_token forKey:KSIMLoginToken];
    }
}
@end


@interface NIMAutoLoginData (KSIMAssistant)
@end
@implementation NIMAutoLoginData (KSIMAssistant)
+ (instancetype)_ksim_loginData:(KSIMLoginInfo *)loginInfo
{
    NIMAutoLoginData *data = NIMAutoLoginData.new;
    data.account = loginInfo.account;
    data.token = loginInfo.token;
    data.forcedMode = YES;
    return data;
}
@end


@interface KSIMLoginAgent ()
@property (nonatomic, strong) KSIMLoginInfo *currenLoginInfo;
@end

static KSIMLoginStatusTracingBlock __ksim_tracingHandler;
@interface KSIMLoginAgent (NIMLoginManagerDelegate)
@end
@implementation KSIMLoginAgent (NIMLoginManagerDelegate)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[KSIMLoginAgent agent] monitoringLoginManagerDelegate];
    });
}

+ (instancetype)agent
{
    static KSIMLoginAgent *agent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = KSIMLoginAgent.new;
        
    });
    return agent;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NIMSDK sharedSDK].loginManager addDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}

- (void)monitoringLoginManagerDelegate { }

// !!!:NIMLoginManagerDelegate
- (void)onAutoLoginFailed:(NSError *)error
{
    if (error) {
        __ksim_tracingHandler(YES);
    }
}
- (void)onLogin:(NIMLoginStep)step
{
    
}
@end

@interface KSIMLoginAgent (Archiver)

@end

@implementation KSIMLoginAgent (Archiver)

- (void)writeLoginInfoToDisk:(NSString *)account token:(NSString *)token
{
    [self writeLoginInfoToDisk:[KSIMLoginInfo loginInfoWithAccount:account token:token]];
}

- (void)writeLoginInfoToDisk:(KSIMLoginInfo *)info
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:info];
    if (data) {
        BOOL succeed = [data writeToFile:KSIMFileAssistant.loginInfoFilePath atomically:YES];
        if (succeed) self.currenLoginInfo = info;
    }
}

- (KSIMLoginInfo *)readLoginInfoFromDisk
{
    NSData *data = [NSData dataWithContentsOfFile:KSIMFileAssistant.loginInfoFilePath];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!obj) return obj;
    NSAssert([obj isKindOfClass:KSIMLoginInfo.class], @"读取登录信息 Model 错误！");
    KSIMLoginInfo *info = (KSIMLoginInfo *)obj;
    return info;
}

- (BOOL)removeLoginInfoOnDisk
{
    NSFileManager *manager = NSFileManager.defaultManager;
    NSString *targetPath = KSIMFileAssistant.loginInfoFilePath;
    NSError *error;
    if ([manager fileExistsAtPath:targetPath]) {
        BOOL succeed = [manager removeItemAtPath:targetPath error:&error];
        if (succeed) self.currenLoginInfo = nil;
        return succeed;
    }
    return YES;
}
@end


//#define KSIMLoginAgentPublicMethodPrecondition [[KSIMLoginAgent agent] monitoringLoginManagerDelegate];
@implementation KSIMLoginAgent
+ (void)login:(NSString *)account token:(NSString *)token completion:(NIMLoginHandler)completion
{
//    KSIMLoginAgentPublicMethodPrecondition
	// 作为 *切换账号* 的切换 IM 账号接口，故不做 if (self.im_isLogined) return; 处理
    [[[NIMSDK sharedSDK] loginManager] login:account token:token  completion:^(NSError *error) {
        completion(error);
        if (error) {
            __ksim_tracingHandler(YES);
            return;
        }
        [[KSIMLoginAgent agent] writeLoginInfoToDisk:account token:token];
    }];
}

+ (void)logout:(NIMLoginHandler)completion
{
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError * _Nullable error) {
        completion(error);
        if (!error) [[KSIMLoginAgent agent] removeLoginInfoOnDisk];
    }];
}

+ (void)traceLoginStatus:(KSIMLoginStatusTracingBlock)handler
{
//    KSIMLoginAgentPublicMethodPrecondition
    __ksim_tracingHandler = handler;
    if (self.im_isLogined) return;
    KSIMLoginInfo *tmp = KSIMLoginAgent.agent.currenLoginInfo;
    if (!tmp) {
        __ksim_tracingHandler(YES);
        return;
    }
    [KSIMLoginAgent autoLogin:[NIMAutoLoginData _ksim_loginData:tmp]];
}

// !!!: private methods
+ (BOOL)im_isLogined
{
    return [[NIMSDK sharedSDK] loginManager].isLogined;
}

+ (void)autoLogin:(NIMAutoLoginData *)loginData
{
    if (self.im_isLogined) return;
    [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
}

- (KSIMLoginInfo *)currenLoginInfo
{
    if (!_currenLoginInfo) {
        _currenLoginInfo = [self readLoginInfoFromDisk];
    }
    return _currenLoginInfo;
}
@end
