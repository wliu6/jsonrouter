//
//  KSIMSessionBarButtonItemUtil.m
//  kaiStart
//
//  Created by 王铎睿 on 2018/4/11.
//  Copyright © 2018年 KaiShiZhongChou. All rights reserved.
//

#import "KSIMSessionBarButtonItemUtil.h"

@implementation NIMSessionViewController (KSIM_UIBarButtonItem)
- (UIBarButtonItem *)ksimDefaultBackItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"common_backarrow"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"common_backarrow"] forState:UIControlStateHighlighted];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(13, 5, 13, 27)];
    [backButton addTarget:self action:@selector(_ksim_backAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *tmp = self.navigationItem.leftBarButtonItem.customView;
    tmp.userInteractionEnabled = YES;
    [tmp insertSubview:backButton atIndex:0];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:tmp];
    // FIXME: 由于云信的UI方案下，session vc 返回action会受到以下两个状态影响，自定制UI方案实施，故做如此操作
    tmp.translatesAutoresizingMaskIntoConstraints = YES;
    self.navigationItem.leftItemsSupplementBackButton = NO;
    return item;
}

- (void)_ksim_backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end


@implementation KSIMSessionBarButtonItemUtil
+ (NSArray <UIBarButtonItem *> *)teamRightItems
{
    return nil;
}
@end

