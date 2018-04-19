//
//  KSIMTeamNoticeContentView.m
//  KSIMUIKit
//
//  Created by 王铎睿 on 2018/4/19.
//

#import "KSIMTeamNoticeContentView.h"
#import <NIMKit.h>
CGSize KSIMTeamNoticeContentViewSize () {
    return CGSizeMake(200.f, 100.f);
}

CGFloat KSIMTeamNoticeContentViewVerticalEdge = 8.f;
CGFloat KSIMTeamNoticeContentViewHorizontalEdge = 12.f;
// 由于继承自三方类目，故添加prefix，避免OC不具备class name space导致编译异常的问题（后期开发对应两个remote，很必要!!!）
@interface KSIMTeamNoticeContentView ()
@property (nonatomic, strong) UILabel *ks_titleLabel;
@property (nonatomic, strong) UILabel *ks_markLabel;
@property (nonatomic, strong) UIView *ks_separatorLine;
@property (nonatomic, strong) UIImageView *ks_imageView;
@property (nonatomic, strong) UILabel *ks_detailLabel;
@end

@implementation KSIMTeamNoticeContentView
- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    self.frame = CGRectMake(0.f, 0.f, KSIMTeamNoticeContentViewSize().width, KSIMTeamNoticeContentViewSize().height);
    if (self) {
        UILabel *titleLabel = UILabel.new;
        titleLabel.font = [UIFont systemFontOfSize:12.f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:titleLabel];
        self.ks_titleLabel = titleLabel;
        
        
        UILabel *markLabel = UILabel.new;
        markLabel.textAlignment = NSTextAlignmentRight;
        markLabel.font = [UIFont systemFontOfSize:12.f];
        markLabel.backgroundColor = [UIColor clearColor];
        markLabel.textColor = [UIColor colorWithRed:111.f/255.f green:180.f/255.f blue:123.f/255.f alpha:1.f];//RGB(111, 180, 123);
        markLabel.text = @"@所有人";
        [self addSubview:markLabel];
        self.ks_markLabel = markLabel;
        
        
        UIView *separatorLine = UIView.new;
        separatorLine.frame = CGRectMake(0.f, 0.f, KSIMTeamNoticeContentViewSize().width, 1.f);
        [self addSubview:separatorLine];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:separatorLine.bounds];
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(separatorLine.frame) / 2, CGRectGetHeight(separatorLine.frame))];
        [shapeLayer setFillColor:[UIColor clearColor].CGColor];
        //  设置虚线颜色
        [shapeLayer setStrokeColor:[UIColor colorWithRed:112.f/255.f green:166/255.f blue:113/255.f alpha:1.f].CGColor];
        //  设置虚线宽度
        [shapeLayer setLineWidth:CGRectGetHeight(separatorLine.frame)];
        [shapeLayer setLineJoin:kCALineJoinRound];
        //  设置线宽，线间距
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:2], nil]];
        //  设置路径
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(separatorLine.frame), 0);
        [shapeLayer setPath:path];
        CGPathRelease(path);
        //  把绘制好的虚线添加上来
        [separatorLine.layer addSublayer:shapeLayer];
        self.ks_separatorLine = separatorLine;
        
        
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 48, 48)];
//        imageView.backgroundColor = [UIColor clearColor];
//        imageView.layer.cornerRadius = 6.f;
//        imageView.layer.masksToBounds = YES;
//        [self addSubview:imageView];
//        self.ks_imageView = imageView;
        
        UILabel *detailLabel = UILabel.new;
        detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        detailLabel.font = [UIFont systemFontOfSize:13];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textAlignment = NSTextAlignmentJustified;
        [self addSubview:detailLabel];
        self.ks_detailLabel = detailLabel;
    }
    return self;
}

- (void)refresh:(NIMMessageModel*)data{
    //务必调用super方法
    [super refresh:data];
    self.ks_titleLabel.text = self.model.message.text;
    self.ks_detailLabel.text = self.model.message.text;
//    if (data.message.session.sessionType == NIMSessionTypeTeam) {
//        UIImage *tmp = self.bubbleImageView.image;
//        self.bubbleImageView.image = [tmp imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        self.bubbleImageView.tintColor = [UIColor redColor];
//    }
    if (!self.model.message.isOutgoingMsg) {
//        self.titleLabel.textColor = [UIColor blackColor];
//        self.subTitleLabel.textColor = [UIColor blackColor];
    }else{
//        self.titleLabel.textColor = [UIColor whiteColor];
//        self.subTitleLabel.textColor = [UIColor whiteColor];
    }
    
    [self.ks_titleLabel sizeToFit];
    [self.ks_detailLabel sizeToFit];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat topLineHeight = 20.f;
    
    self.ks_titleLabel.frame = CGRectMake(KSIMTeamNoticeContentViewHorizontalEdge, KSIMTeamNoticeContentViewVerticalEdge, CGRectGetWidth(self.ks_titleLabel.frame), topLineHeight);
    
    CGFloat markLabelWidth = 60.f;
    self.ks_markLabel.frame = CGRectMake(width - markLabelWidth - KSIMTeamNoticeContentViewHorizontalEdge, KSIMTeamNoticeContentViewVerticalEdge, markLabelWidth, topLineHeight);
    
    CGFloat separatorLineX = CGRectGetMinX(self.ks_titleLabel.frame);
    self.ks_separatorLine.frame = CGRectMake(separatorLineX, CGRectGetMaxY(self.ks_titleLabel.frame), CGRectGetMaxX(self.ks_markLabel.frame) - separatorLineX, CGRectGetHeight(self.ks_separatorLine.bounds));
    
    CGFloat detailLabelY = CGRectGetMaxY(self.ks_separatorLine.frame) + 10.f;
    CGFloat detailLabelHeightMaximin = height - detailLabelY - KSIMTeamNoticeContentViewVerticalEdge;
    CGFloat detailLabelHeight = CGRectGetHeight(self.ks_detailLabel.bounds);
    self.ks_detailLabel.frame = CGRectMake(separatorLineX, detailLabelY, CGRectGetWidth(self.ks_separatorLine.frame), detailLabelHeight >  detailLabelHeightMaximin ? detailLabelHeightMaximin : detailLabelHeight);
}

@end

