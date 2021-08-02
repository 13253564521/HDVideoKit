//
//  HDDiscoverCollectionViewCell.m
//  HDVideoKit
//
//  Created by liugaosheng on 2020/8/30.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDDiscoverCollectionViewCell.h"
#import "Macro.h"
#import "YYWebImage.h"
#import "NSDate+MJ.h"
@interface HDDiscoverCollectionViewCell()
@property(nonatomic , strong) UIImageView *imageView;
@property(nonatomic , strong) UIImageView *userIconimageView;
@property(nonatomic , strong) UIImageView *hotImageView;
@property(nonatomic , strong) UILabel   *hotCountLabel;
@property(nonatomic , strong) UILabel   *logoLabel;
@property(nonatomic , strong) UILabel   *titleLabel;
@property(nonatomic , strong) UILabel   *nickNameLabel;


@property(nonatomic,strong)UILabel *playLabel;//播放次数
@property(nonatomic,strong)UIButton *pinglunBtn;//评论次数
@property(nonatomic,strong)UIImageView *pinglunImage;
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIButton *playButton;//播放按钮
@end
@implementation HDDiscoverCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.contentView.layer.cornerRadius = 15;
    self.contentView.layer.masksToBounds = YES;
    //添加渐变色
    CAGradientLayer *gradientLayer = [self getGradientLayerWithBounds:self.contentView.bounds colorsArray:[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil]];
    [self.contentView.layer insertSublayer:gradientLayer atIndex:0];
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(220);
    }];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[UIImage imageNamed:HDBundleImage(@"discover/icon_system_arrow_right")] forState:UIControlStateNormal];
    self.playButton.backgroundColor = RGBA(57, 60, 67, 0.56);
    self.playButton.layer.cornerRadius = 8;
    self.playButton.layer.masksToBounds = YES;
    [self.imageView addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_top).offset(12);
        make.right.equalTo(self.imageView.mas_right).offset(-12);
        make.width.height.mas_equalTo(16);
    }];

    
    self.logoLabel = [[UILabel alloc]init];
    self.logoLabel.backgroundColor = RGBA(116, 156, 255, 1);
    self.logoLabel.textAlignment = NSTextAlignmentCenter;
    self.logoLabel.textColor = [UIColor whiteColor];
    self.logoLabel.font = [UIFont systemFontOfSize:10];

    
   self.titleLabel = [[UILabel alloc]init];
   self.titleLabel.textColor = RGBA(57, 60, 67, 1);
   self.titleLabel.textAlignment = NSTextAlignmentLeft;
   self.titleLabel.font = [UIFont systemFontOfSize:14];
//   self.titleLabel.lineBreakMode = NSLineBreakByClipping;
   self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

   self.titleLabel.numberOfLines = 0;
   [self.contentView addSubview:self.titleLabel];
   [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.contentView.mas_left).offset(10);
       make.top.equalTo(self.imageView.mas_bottom).offset(8);
       make.right.equalTo(self.contentView.mas_right).offset(-10);
   }];
    
    UIImage *usericonImage = [UIImage imageNamed:HDBundleImage(@"testIcon")];
    self.userIconimageView = [[UIImageView alloc]init];
    self.userIconimageView.image = usericonImage;
    [self.contentView addSubview:self.userIconimageView];
    [self.userIconimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(18);
        
    }];
    
    self.hotCountLabel = [[UILabel alloc]init];
    self.hotCountLabel.textAlignment = NSTextAlignmentLeft;
    self.hotCountLabel.textColor = RGBA(51, 51, 51, 1);
    self.hotCountLabel.font = [UIFont systemFontOfSize:11];
//    self.hotCountLabel.text = @"123456";
    [self.contentView addSubview:self.hotCountLabel];


    self.hotImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.hotImageView];
    [self.hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.hotCountLabel);
        make.right.mas_equalTo(self.hotCountLabel.mas_left).offset(-5);
    }];
    
    self.nickNameLabel = [[UILabel alloc]init];
    self.nickNameLabel.textColor = RGBA(51, 51, 51, 1);
    self.nickNameLabel.textAlignment = NSTextAlignmentLeft;
    self.nickNameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.nickNameLabel];

    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIconimageView.mas_right).offset(4);
        make.centerY.equalTo(self.userIconimageView.mas_centerY);
    }];

    self.playLabel = [[UILabel alloc]init];
    self.playLabel.textColor = [UIColor whiteColor];
    self.playLabel.font = [UIFont systemFontOfSize:15];
    self.playLabel.hidden = YES;
    [self.contentView addSubview:self.playLabel];
    [self.playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.imageView).offset(-5);
        make.top.mas_equalTo(self.imageView).offset(5);
    }];
    
    self.pinglunImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:HDBundleImage(@"discover/icon_comment")]];
    self.pinglunImage.hidden = YES;
    [self.contentView addSubview:self.pinglunImage];
    [self.pinglunImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imageView).offset(-5);
        make.left.mas_equalTo(self.imageView).offset(5);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    self.pinglunBtn = [[UIButton alloc]init];
    [self.pinglunBtn setTitleColor:UkeColorHex(0xFFFFFF) forState:0];
    self.pinglunBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.pinglunBtn.hidden = YES;
    [self.contentView addSubview:self.pinglunBtn];


    self.timeLabel =[[UILabel alloc]init];
    self.timeLabel.font =[UIFont systemFontOfSize:12];
    self.timeLabel.textColor = UkeColorHex(0x333333);
    self.timeLabel.hidden = YES;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(self.nickNameLabel);
    }];
}

- (void)setModeldate:(HDUserVideoListModel *)model {
    
    [self.pinglunBtn setTitle:[self stringToInt:model.commentCount] forState:0];
    [self.pinglunBtn sizeToFit];

    [self.pinglunBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.pinglunImage);
        make.left.mas_equalTo(self.pinglunImage.mas_right).offset(0);
        make.width.mas_equalTo(self.pinglunBtn.frame.size.width + 5);
        make.height.mas_equalTo(self.pinglunBtn.frame.size.height);
    }];
    
    
    [self.hotImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pinglunBtn.mas_right).offset(5);
        make.centerY.mas_equalTo(self.pinglunImage);
        make.width.height.mas_equalTo(18);
    }];
    
    [self.hotCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hotImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.hotImageView);
    }];
    
    [self.nickNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userIconimageView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.userIconimageView);
        make.right.mas_equalTo(self.timeLabel.mas_left).offset(-5);
    }];

    [self setModelshuDat:model];
}

- (void)setModel:(HDUserVideoListModel *)model {
    _model = model;


    self.hotCountLabel.text = [model.likeCount isEqualToNumber:@(0)] ? @"喜欢" : [self stringToInt:[model.likeCount stringValue]];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:11]};
    CGSize size=[self.hotCountLabel.text sizeWithAttributes:attrs];
    
    [self.hotCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-3);
        make.centerY.equalTo(self.userIconimageView.mas_centerY);
        make.width.mas_equalTo(size.width + 5);
    }];

    
    [self.hotImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.hotCountLabel.mas_left).offset(-3);
        make.centerY.equalTo(self.hotCountLabel.mas_centerY);
        make.width.height.mas_equalTo(16);
    }];

    
    [self.nickNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIconimageView.mas_right).offset(4);
        make.centerY.equalTo(self.userIconimageView.mas_centerY);
        make.right.equalTo(self.hotImageView.mas_left).offset(-3);
    }];

    [self setModelshuDat:model];
    
}


-(void)setModelshuDat:(HDUserVideoListModel *)model {
    self.titleLabel.text = model.title;
    self.nickNameLabel.text = model.nickName;
    if ([model.likeCount isEqualToNumber:@(0) ]) {
        self.hotCountLabel.text = @"喜欢";
    }else{
        self.hotCountLabel.text = [self stringToInt:[model.likeCount stringValue]];
    }
    
    
    self.imageView.yy_imageURL = [NSURL URLWithString:model.coverUrl];
    [self.userIconimageView yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];
    
    if (model.isLiked == NO) {
        self.hotImageView.image = [UIImage imageNamed:HDBundleImage(@"discover/icon_bicolor_zan")];
    }else {
        self.hotImageView.image = [UIImage imageNamed:HDBundleImage(@"discover/icon_hot")];
    }
    
    self.playLabel.text = [self stringToInt:model.playCount];
    
    NSDate *date = [[NSDate alloc]init];
    self.timeLabel.text = [date timeStringWithTimeInterval:model.createTime];
}

-(void)setIshiddeView:(BOOL)ishiddeView {
    _ishiddeView = ishiddeView;
    self.playLabel.hidden = NO;
    self.pinglunBtn.hidden = NO;
    self.pinglunImage.hidden = NO;
    self.timeLabel.hidden = NO;
    
    self.playButton.hidden = YES;
    
    self.hotCountLabel.font = [UIFont systemFontOfSize:11];
    self.hotCountLabel.textColor = UkeColorHex(0xFFFFFF);


}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //设置圆角
    self.layer.mask = [self circleMaskLayerWithView:self byRoundingCorners:UIRectCornerAllCorners radius:2];
    self.userIconimageView.layer.mask = [self cicleMaskLayerWithImageView:self.userIconimageView];
    self.logoLabel.layer.mask = [self circleMaskLayerWithView:self.logoLabel byRoundingCorners:UIRectCornerBottomLeft  radius:4];
}


- (CALayer *)cicleMaskLayerWithImageView:(UIImageView *)imageView {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = imageView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    
    return maskLayer;
}

- (CALayer *)circleMaskLayerWithView:(UIView *)view byRoundingCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius * 2, radius * 2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = view.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    
    return maskLayer;
}

- (CAGradientLayer *)getGradientLayerWithBounds:(CGRect)bounds  colorsArray:(NSArray *)colorsArray {
    //添加渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = bounds;
    // 渐变色颜色数组,可多个
    gradientLayer.colors = colorsArray;//[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil];
    // 渐变的开始点 (不同的起始点可以实现不同位置的渐变,如图)
    gradientLayer.startPoint = CGPointMake(0, 0.5f); //(0, 0)
    // 渐变的结束点
    gradientLayer.endPoint = CGPointMake(1, 0.5f); //(1, 1)
    
    return gradientLayer;
}
@end

