//
//  KSIMCellLayoutConfig.m
//  KSIMUIKit
//
//  Created by 王铎睿 on 2018/4/17.
//

#import "KSIMCellLayoutConfig.h"
#import "NIMMessageModel.h"
#import "NIMMessage+KSTeamNotice.h"
#import "KSIMTeamNoticeContentView.h"
@implementation KSIMCellLayoutConfig
- (CGSize)contentSize:(NIMMessageModel *)model cellWidth:(CGFloat)width
{
    if (model.message.ks_isTeamNotice) {
        return KSIMTeamNoticeContentViewSize();
    }
    return [super contentSize:model cellWidth:width];
}

- (NSString *)cellContent:(NIMMessageModel *)model{
    if (model.message.ks_isTeamNotice) {
        return NSStringFromClass(KSIMTeamNoticeContentView.class);
    }
    return [super cellContent:model];
}
@end
