//
//  KSIMSessionConfig.m
//  kaiStart
//
//  Created by 王铎睿 on 2018/4/11.
//  Copyright © 2018年 KaiShiZhongChou. All rights reserved.
//

#import "KSIMSessionConfig.h"

@implementation KSIMSessionConfig
+ (instancetype (^)(KSIMSessionMode mode))newInstance
{
    return ^(KSIMSessionMode mode){
        KSIMSessionConfig *config = KSIMSessionConfig.new;
        config.mode = mode;
        return config;
    };
}

+ (instancetype)defaultConfig
{
    return KSIMSessionConfig.newInstance(KSIMSessionDefaultMode);
}

+ (instancetype)p2pConfig
{
    return KSIMSessionConfig.newInstance(KSIMSessionP2PMode);
}

+ (instancetype)teamConfig
{
    return KSIMSessionConfig.newInstance(KSIMSessionTeamMode);
}

- (NSArray<NSNumber *> *)inputBarItemTypes
{
    return @[
             @(NIMInputBarItemTypeMore),
             @(NIMInputBarItemTypeEmoticon),
             @(NIMInputBarItemTypeTextAndRecord),
             @(NIMInputBarItemTypeVoice)
             ];
}

- (NSArray<NIMMediaItem *> *)mediaItems
{
    NSMutableArray *items = [@[] mutableCopy];
    NIMMediaItem *camera = [NIMMediaItem item:@"onTapCamera:" normalImage:[UIImage imageNamed:@"chat_camera"] selectedImage:[UIImage imageNamed:@"chat_camera"] title:@"拍照"];
    NIMMediaItem *photo = [NIMMediaItem item:@"onTapPhotos:" normalImage:[UIImage imageNamed:@"chat_photo"] selectedImage:[UIImage imageNamed:@"chat_photo"] title:@"相册"];
    NIMMediaItem *liveStreaming = [NIMMediaItem item:@"onTapRoadshow:" normalImage:[UIImage imageNamed:@"chat_liveStreaming"] selectedImage:[UIImage imageNamed:@"chat_liveStreaming"] title:@"路演直播"];
    switch (self.mode) {
        case KSIMSessionDefaultMode:
        {
            [items addObject:camera];
            [items addObject:photo];
            [items addObject:liveStreaming];
        }
            break;
        case KSIMSessionP2PMode:
        {
            [items addObject:camera];
            [items addObject:photo];
        }
            break;
        case KSIMSessionTeamMode:
        {
            [items addObject:camera];
            [items addObject:photo];
            [items addObject:liveStreaming];
        }
            break;
        default:
        {
            [items addObject:camera];
            [items addObject:photo];
            [items addObject:liveStreaming];
        }
            break;
    }
    return items.copy;
}
@end
