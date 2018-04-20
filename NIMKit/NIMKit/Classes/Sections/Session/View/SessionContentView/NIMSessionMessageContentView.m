//
//  NIMSessionMessageContentView.m
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMSessionMessageContentView.h"
#import "NIMMessageModel.h"
#import "UIImage+NIMKit.h"
#import "UIView+NIM.h"
#import "NIMKit.h"

@interface NIMSessionMessageContentView()

@end

@implementation NIMSessionMessageContentView

- (instancetype)initSessionMessageContentView
{
    CGSize defaultBubbleSize = CGSizeMake(60, 35);
    if (self = [self initWithFrame:CGRectMake(0, 0, defaultBubbleSize.width, defaultBubbleSize.height)]) {
        
        [self addTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(onTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        _bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,defaultBubbleSize.width,defaultBubbleSize.height)];
        _bubbleImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_bubbleImageView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel*)data
{
    _model = data;
    UIImage *normal = [[self chatBubbleImageForState:UIControlStateNormal outgoing:data.message.isOutgoingMsg] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *highlight = [[self chatBubbleImageForState:UIControlStateHighlighted outgoing:data.message.isOutgoingMsg] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_bubbleImageView setImage:normal];
    [_bubbleImageView setHighlightedImage:highlight];
    [self setNeedsLayout];
    
    if (data.message.isOutgoingMsg) {
        self.bubbleImageView.tintColor = [UIColor colorWithRed:173.f/255.f green:220.f/255.f blue:186.f/255.f alpha:1.f];// addcba
    } else {
        if (data.message.session.sessionType == NIMSessionTypeTeam) {
            NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:data.message.session.sessionId];
            if ([data.message.from isEqualToString:team.owner]) {
                self.bubbleImageView.tintColor = [UIColor colorWithRed:255.f/255.f green:222.f/255.f blue:135.f/255.f alpha:1.f];// ffde87
            } else {
                self.bubbleImageView.tintColor = [UIColor colorWithRed:250.f/255.f green:250.f/255.f blue:250.f/255.f alpha:1.f];// fafafa
            }
        } else {
            self.bubbleImageView.tintColor = [UIColor colorWithRed:250.f/255.f green:250.f/255.f blue:250.f/255.f alpha:1.f];// fafafa
        }
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _bubbleImageView.frame = self.bounds;
}


- (void)updateProgress:(float)progress
{
    
}

- (void)onTouchDown:(id)sender
{
    
}

- (void)onTouchUpInside:(id)sender
{
    
}

- (void)onTouchUpOutside:(id)sender{
    
}


#pragma mark - Private
- (UIImage *)chatBubbleImageForState:(UIControlState)state outgoing:(BOOL)outgoing
{
    
    NIMKitSetting *setting = [[NIMKit sharedKit].config setting:self.model.message];
    if (state == UIControlStateNormal)
    {
        return setting.normalBackgroundImage;
    }
    else
    {
        return setting.highLightBackgroundImage;
    }
}


- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    _bubbleImageView.highlighted = highlighted;
}

@end
