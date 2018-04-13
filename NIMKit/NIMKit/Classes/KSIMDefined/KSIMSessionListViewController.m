//
//  KSIMSessionListViewController.m
//  kaiStart
//
//  Created by 王铎睿 on 2018/4/9.
//  Copyright © 2018年 KaiShiZhongChou. All rights reserved.
//

#import "KSIMSessionListViewController.h"
#import "KSIMSessionViewController.h"
#import "KSIMSessionConfig.h"
@interface KSIMSessionListViewController ()

@end

@implementation KSIMSessionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// !!!: override super class
- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    NIMSession *target = recent.session;
    switch (target.sessionType) {
        case NIMSessionTypeP2P:
        {
            KSIMSessionViewController *vc = [[KSIMSessionViewController alloc] initWithSession:recent.session];
            vc.sessionConfig = KSIMSessionConfig.p2pConfig;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case NIMSessionTypeTeam:
        {
            KSIMSessionViewController *vc = [[KSIMSessionViewController alloc] initWithSession:recent.session];
            vc.sessionConfig = KSIMSessionConfig.teamConfig;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}

@end
