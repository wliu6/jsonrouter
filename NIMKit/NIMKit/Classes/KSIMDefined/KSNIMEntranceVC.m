//
//  KSNIMEntranceVC.m
//  kaiStart
//
//  Created by 王铎睿 on 2018/4/8.
//  Copyright © 2018年 KaiShiZhongChou. All rights reserved.
//

#import "KSNIMEntranceVC.h"
#import "KSIMSessionListViewController.h"
#import "KSIMSessionViewController.h"
#import "KSIMLoginAgent.h"
#import <NIMKit.h>
#import "KSIMCellLayoutConfig.h"

#import "KSZCMediateRouter.h"
@interface KSNIMEntranceVC ()

@end

@implementation KSNIMEntranceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [NIMSDKConfig sharedConfig].shouldConsiderRevokedMessageUnreadCount = YES;
    [NIMSDKConfig sharedConfig].shouldSyncUnreadCount = YES;
    
    NSString *actionName = @"aaa";
    
    [[KSZCMediateRouter router] performAction:actionName target:@"KSZCTestA" params:@{} shouldCacheTarget:NO];
    
    
    NSString *appKey = @"3a407a02368fd5f49bd0a065efbd4e1d";
    NIMSDKOption *option = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername = nil;
    option.pkCername = nil;
    [[NIMSDK sharedSDK] registerWithOption:option];
    
    NIMServerSetting *setting    = [[NIMServerSetting alloc] init];
    setting.httpsEnabled = NO;
    [[NIMSDK sharedSDK] setServerSetting:setting];
    [[NIMKit sharedKit] registerLayoutConfig:KSIMCellLayoutConfig.new];
//    [[NIMKit sharedKit] registerLayoutConfig:NIMCellLayoutConfig.new];
//    [NIMKit sharedKit].config.recordMaxDuration = 15.f;
    [KSIMLoginAgent traceLoginStatus:^(BOOL needLogin) {
        NSString *account = @"12345123456";
        NSString *token = @"4477b85baa3a3ad97e9bb3100a4380e2";
        [KSIMLoginAgent login:account token:token completion:^(NSError *error) {
            if (!error) return NSLog(@"登录成功");
            NSLog(@"登录失败");
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(UIButton *)sender
{
    UIViewController *vc = [[KSZCMediateRouter router] performAction:@"new" target:@"KSGroupSettingVC" params:@{} shouldCacheTarget:NO];
    if (!vc) return;
    [self.navigationController pushViewController:vc animated:YES];
    return;
    NSString *account = @"12345123456";
    NSString *token = @"4477b85baa3a3ad97e9bb3100a4380e2";
    
    
    [KSIMLoginAgent login:account token:token completion:^(NSError *error) {
        if (!error) return NSLog(@"登录成功");
        NSLog(@"登录失败");
    }];
}

- (IBAction)enterIntoNIMConversationList:(UIButton *)sender
{
    [self.navigationController pushViewController:KSIMSessionListViewController.new animated:YES];
}

- (IBAction)enterIntoMyTeams:(UIButton *)sender
{
    NSArray<NIMTeam *> *teams = [NIMSDK sharedSDK].teamManager.allMyTeams;
    if (teams.count > 0) {
        KSIMSessionViewController *vc = [[KSIMSessionViewController alloc] initWithSession:[NIMSession session:teams[0].teamId type:NIMSessionTypeTeam]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
