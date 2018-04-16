//
//  KSIMSessionViewController.m
//  kaiStart
//
//  Created by 王铎睿 on 2018/4/9.
//  Copyright © 2018年 KaiShiZhongChou. All rights reserved.
//

#import "KSIMSessionViewController.h"
#import "TZImageManager.h"
#import "TZImagePickerController.h"
#import "NIMAdvancedTeamCardViewController.h"
#import "NIMKitInfoFetchOption.h"
#import "KSIMUIKit/NIMKitUtil.h"
@interface NIMSession (Assistant)
@end
@implementation NIMSession (Assistant)
- (NSString *)title
{
    NSString *title = @"";
    switch (self.sessionType) {
        case NIMSessionTypeTeam:{
            NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.sessionId];
            title = team.teamName.copy;
        }
            break;
        case NIMSessionTypeP2P:{
            title = [NIMKitUtil showNick:self.sessionId inSession:self];
        }
            break;
        default:
            break;
    }
    return title;
}
@end

@class KSIMSessionTeamTitleView;
typedef void(^KSIMSessionTeamTitleViewBlock)(KSIMSessionTeamTitleView *sender);
@interface KSIMSessionTeamTitleView: UIButton
@property (nonatomic, copy) KSIMSessionTeamTitleViewBlock tapHandler;
@property (nonatomic, strong) UIImageView *signView;
@end
@implementation KSIMSessionTeamTitleView
- (instancetype)init
{
    self = [super init];
    if (self) {
        CGRect titleViewFrame = CGRectMake(0.f, 0.f, 200.f, 44.f);
        self.frame = titleViewFrame;
        [self setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        
        UIImageView *sign = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(titleViewFrame) - 3.f, CGRectGetMaxY(titleViewFrame) - 3.f - 5.f/*向上offset*/, 6.f, 3.f)];
        sign.image = [UIImage imageNamed:@"chat_groupConversation_3_0"];
        sign.highlightedImage = [UIImage imageNamed:@"chat_groupConversationHighlight_3_0"];
        [self addSubview:sign];
        _signView = sign;
        
        [self addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)tapAction:(KSIMSessionTeamTitleView *)sender
{
    self.signView.highlighted = !self.signView.highlighted;
    if (self.tapHandler) self.tapHandler(self);
}
@end

@interface KSIMSessionViewController (SendMessage)
@end

@implementation KSIMSessionViewController (SendMessage)
- (void)sendImageMessage:(UIImage *)image
{
    NIMSession *session = self.session;
    NIMMessage *message = NIMMessage.new;
    NIMImageObject *obj = [[NIMImageObject alloc] initWithImage:image];
    message.messageObject = obj;
    NSError *error = nil;
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
}
@end


#import "KSIMSessionBarButtonItemUtil.h"
@interface KSIMSessionViewController () 
@property (nonatomic,strong) UIBarButtonItem *teamRightItem;
@property (nonatomic, strong) KSIMSessionTeamTitleView *teamTitleView;
@end

@implementation KSIMSessionViewController
- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = self.ksimDefaultBackItem;
    if (self.sessionConfig.mode == KSIMSessionTeamMode) {
        self.navigationItem.rightBarButtonItem = self.teamRightItem;
        self.navigationItem.titleView = self.teamTitleView;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// !!! title-item related
- (KSIMSessionTeamTitleView *)teamTitleView;
{
    if (!_teamTitleView) {
        KSIMSessionTeamTitleView *view = KSIMSessionTeamTitleView.new;
        [view setTitle:self.session.title forState:UIControlStateNormal];
        view.tapHandler = ^(KSIMSessionTeamTitleView *sender) {
//            [MobClick event:@"message_2_6_3"];
            
            //    [sender setHighlighted: !sender.isHighlighted];
            //    if (!wself) return;
            //    if (!wself.topUsersInfoView) return;
            //    if (wself.topUsersInfoView.isShow) {
            //        [wself closeTopUsersInfoView];
            //        if (w_sign) w_sign.highlighted = NO;
            //    }else{
            //        [wself showTopUsersInfoView];
            //        if (w_sign) w_sign.highlighted = YES;
            //    }
        };
        _teamTitleView = view;
    }
    return _teamTitleView;
}


// !!!: bar-items related
- (UIBarButtonItem *)teamRightItem
{
    if (!_teamRightItem) {
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 60.f, 44.f)];
        UIButton *noticeBtn = UIButton.new;
        noticeBtn.frame = CGRectMake(0.f, 0.f, 30.f, 44.f);
        [noticeBtn setImage:[UIImage imageNamed:@"chat_groupNotice_3_0"] forState:UIControlStateNormal];
        [noticeBtn addTarget:self action:@selector(pushTeamNotice) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:noticeBtn];
        
        UIButton *settingBtn = UIButton.new;
        settingBtn.frame = CGRectMake(30.f, 0.f, 30.f, 44.f);
        [settingBtn addTarget:self action:@selector(pushTeamSetting) forControlEvents:UIControlEventTouchUpInside];
        [settingBtn setImage:[UIImage imageNamed:@"chat_setting"] forState:UIControlStateNormal];
        [customView addSubview:settingBtn];
        
        [settingBtn setImageEdgeInsets:UIEdgeInsetsMake(10.f, 3.f, 10.f, 3.f)];
        [noticeBtn setImageEdgeInsets:UIEdgeInsetsMake(10.f, 3.f, 10.f, 3.f)];
        _teamRightItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    }
    return _teamRightItem;
}

- (void)pushTeamNotice
{
    
}

- (void)pushTeamSetting
{
    NIMAdvancedTeamCardViewController *vc = [[NIMAdvancedTeamCardViewController alloc] initWithTeam:[[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId]];
    [self.navigationController pushViewController:vc animated:YES];
}


// !!!: private methods


// !!!: override super class
- (id<NIMSessionConfig>)sessionConfig
{
    if (_sessionConfig == nil) {
        _sessionConfig = KSIMSessionConfig.defaultConfig;
    }
    return _sessionConfig;
}

// !!!: mediaItem actions
- (void)onTapCamera:(NIMMediaItem *)item
{
    // 相机
    // FIXME: 这个操作是干啥的，必要吗？需要解耦
//    [[ApplicationSettigns instance] setChatControllerShownImagePicker:YES];
//    [wself hideKeyBoard];
    [self presentViewController:UIViewController.new animated:YES completion:nil];
//    [self.navigationController pushViewController:UIViewController.new animated:YES];
//#if TARGET_IPHONE_SIMULATOR
//    [self showHint:NSLocalizedString(@"模拟器不支持拍照", @"simulator does not support taking picture")];
//#elif TARGET_OS_IPHONE
//    NSString *mediaType = AVMediaTypeVideo;
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
//
//    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
//        KSTextAlert *alertvc = [KSTextAlert new];
//        alertvc.title = @"提示";
//        alertvc.detailText = @"请在设备的【设置-隐私-相机】中允许访问相机。";
//        [alertvc show];
//        return;
//    }
//    [MobClick event:@"KS_GroupContact_ClickCamera"];
//    [wself presentViewController:self.imagePicker animated:YES completion:NULL];
//    self.isInvisible = YES;
//#endif
    
}

- (void)onTapPhotos:(NIMMediaItem *)item
{
    __weak typeof(self) wself = self;
//    [MobClick event:@"KS_GroupContact_ClickPhoto"];
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:6 delegate:self];
    imagePickerVC.allowTakePicture = NO;
    [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (UIImage *image in photos) {
            [wself sendImageMessage:image];
        }
    }];
    [imagePickerVC setDidFinishPickingVideoHandle:^(UIImage *image, id asset) {
        [TZImageManager.manager getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [wself showHint:@"暂不支持发送视频"];
            });
            return;
        }];
    }];
    [wself presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)onTapRoadshow:(NIMMediaItem *)item
{
    // FIXME: 待解耦
//    [MobClick event:@"group_projectlive"];
    
    
    // FIXME: session id 可以拿到，缺少群角色
//    KSTeleviseLiveVC *vc = KSTeleviseLiveVC.new;
//    vc.crowdID = wself.groupExtInfo.crowdID;
//    vc.role = wself.groupExtInfo.groupRole;
//    [wself.navigationController pushViewController:vc animated:YES];
}

// !!!: NIMMessageCellDelegate
- (BOOL)onTapAvatar:(NIMMessage *)message
{
    NSString *userId = [self messageSendSource:message];
    UIViewController *vc = nil;
    if ([[NIMSDK sharedSDK].robotManager isValidRobot:userId]){
        // TODO: 跳转到机器人信息界面
        
    } else {
        // TODO: 跳转到用户个人主页

    }
    [self.navigationController pushViewController:vc animated:YES];
    return YES;
}

- (BOOL)onLongPressAvatar:(NIMMessage *)message
{
    NSString *userId = [self messageSendSource:message];
    if (self.session.sessionType == NIMSessionTypeTeam && ![userId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount])
    {
        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
        option.session = self.session;
        option.forbidaAlias = YES;
        
        NSString *nick = [[NIMKit sharedKit].provider infoByUser:userId option:option].showName;
        
        NIMInputAtItem *item = [[NIMInputAtItem alloc] init];
        item.uid  = userId;
        item.name = nick;
        [self.sessionInputView.atCache addAtItem:item];
        
        NSString *text = [NSString stringWithFormat:@"%@%@%@",NIMInputAtStartChar,nick,NIMInputAtEndChar];
        [self.sessionInputView.toolBar insertText:text];
    }
    return YES;
}

- (NSString *)messageSendSource:(NIMMessage *)message
{
    NSString *from = nil;
    if (message.messageType == NIMMessageTypeRobot)
    {
        NIMRobotObject *object = (NIMRobotObject *)message.messageObject;
        if (object.isFromRobot)
        {
            from = object.robotId;
        }
    }
    if (!from)
    {
        from = message.from;
    }
    return from;
}
@end
