//
//  KSZCTestA.m
//  KSIMUIKit
//
//  Created by 王铎睿 on 2018/4/24.
//

#import "KSZCTestA.h"
#import "KSZCMediateRouter.h"
@implementation KSZCTestA
- (void)aaa
{
    return;
}

- (CGFloat)bbb
{
    return 12.f;
}

- (CGSize)ccc
{
    return CGSizeMake(12.f, 12.f);
}

- (instancetype)ddd
{
    return self.class.new;
}

- (id)eee
{
    return [UIColor redColor];
}

- (id)fff
{
    return KSZCMediateRouter.new;
}

- (Class)ggg
{
    return KSZCMediateRouter.class;
}

- (void (^)(void))hhh
{
    return ^(){
        
    };
}

- (NSSet *)iii
{
    return NSSet.new;
}

- (NSArray *)jjj
{
    return NSArray.new;
}

- (NSDictionary *)kkk
{
    return NSDictionary.new;
}
@end

