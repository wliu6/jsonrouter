//
//  KSIMSessionViewController.h
//  kaiStart
//
//  Created by 王铎睿 on 2018/4/9.
//  Copyright © 2018年 KaiShiZhongChou. All rights reserved.
//

#import "NIMKit.h"
#import "KSIMSessionConfig.h"

// 目前应对Mode >> KSIMSessionP2PMode(私聊) | KSIMSessionTeamMode(共建群)
@interface KSIMSessionViewController : NIMSessionViewController
@property (nonatomic,strong) KSIMSessionConfig *sessionConfig;
@end
