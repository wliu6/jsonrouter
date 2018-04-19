//
//  NIMMessage+KSTeamNotice.m
//  KSIMUIKit
//
//  Created by 王铎睿 on 2018/4/17.
//

#import "NIMMessage+KSTeamNotice.h"

@implementation NIMMessage (KSTeamNotice)
- (BOOL)ks_isTeamNotice
{
    if (self.session.sessionType != NIMSessionTypeTeam) return NO;
    if (self.messageType == NIMMessageTypeCustom) return YES;
    if (!self.remoteExt) return NO;
    if ([self.remoteExt objectForKey:@"type"]) return YES;
    return NO;
}
@end
