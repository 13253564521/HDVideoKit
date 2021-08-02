//
//  HDMessagesComentCell.m
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/5.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDMessagesComentCell.h"
#import "Macro.h"
#import "YYWebImage.h"
#import "NSDate+MJ.h"

@interface HDMessagesComentCell ()
@property(nonatomic , strong)UIImageView *usericonImageView;
@property(nonatomic , strong)UILabel *userNameLabel;
@property(nonatomic , strong)UILabel  *subDesLabel;
@property(nonatomic , strong)UILabel  *contentLabel;
@property(nonatomic , strong)UIImageView  *contentImageView;
@end
@implementation HDMessagesComentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _usericonImageView = [[UIImageView  alloc]init];
        _usericonImageView.image = [UIImage imageNamed:HDBundleImage(@"testIcon.png")];
        [self.contentView addSubview:_usericonImageView];
        
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:15];
        _userNameLabel.textColor = [UIColor blackColor];
//        _userNameLabel.text = @"苏绣绣v";
        [self.contentView addSubview:_userNameLabel];
        
        _subDesLabel = [[UILabel alloc]init];
        _subDesLabel.font = [UIFont  systemFontOfSize:10];
        _subDesLabel.textColor = RGBA(102, 102, 102, 1);
//        _subDesLabel.text = @"评论了你的作品  55分钟前";
        [self.contentView addSubview:_subDesLabel];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont  systemFontOfSize:12];
        _contentLabel.textColor = RGBA(52, 52, 52, 1);
//        _contentLabel.text = @"对对对，我也这么觉得";
        [self.contentView addSubview:_contentLabel];
        
        _contentImageView = [[UIImageView alloc]init];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _contentImageView.backgroundColor = [UIColor redColor];
        _contentImageView.clipsToBounds = YES;
        [self.contentView addSubview:_contentImageView];
        [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-20);
            make.width.mas_equalTo(100);
        }];
        
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat userIconHW = 40;
    CGFloat uesrIconLM = 20;
    
    self.usericonImageView.frame = CGRectMake(uesrIconLM, 10, userIconHW, userIconHW);
    
    CGFloat userNameL = 5.5;
    CGFloat contentM = 10;
    CGFloat contentW = 80;
    CGFloat contentR = 20;
    self.userNameLabel.frame = CGRectMake(CGRectGetMaxX(self.usericonImageView.frame) + userNameL, self.usericonImageView.frame.origin.y, self.contentView.frame.size.width - CGRectGetMaxX(self.usericonImageView.frame) - userNameL - contentW - contentR, userIconHW * 0.5);
    self.subDesLabel.frame = CGRectMake(self.userNameLabel.frame.origin.x, CGRectGetMaxY(self.userNameLabel.frame), self.userNameLabel.frame.size.width, userIconHW *0.5);
    
    CGFloat contentLabelH = 12;
    self.contentLabel.frame = CGRectMake(self.userNameLabel.frame.origin.x, CGRectGetMaxY(self.usericonImageView.frame) + 2.5, self.userNameLabel.frame.size.width, contentLabelH);
  
//    self.contentImageView.frame = CGRectMake(self.contentView.frame.size.width - contentR - contentW, contentM, contentW, self.contentView.frame.size.height - contentM * 2);
    
    
    self.usericonImageView.layer.mask = [self cicleMaskLayerWithImageView:self.usericonImageView];
}

- (void)setModel:(HDMessagePinglunModel *)model {
    _model = model;
    [self.usericonImageView yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];

    _userNameLabel.text = model.nickName;
    
    NSDate *date = [[NSDate alloc]init];
    if (model.targetExt > 0) {
        _subDesLabel.text = [NSString stringWithFormat:@"回复了你的评论  %@",[date timeStringWithTimeInterval:model.createTime]];
    }else {
        _subDesLabel.text = [NSString stringWithFormat:@"评论了你的作品  %@",[date timeStringWithTimeInterval:model.createTime]];
    }
    

    _contentLabel.text = model.content;
    
    self.contentImageView.yy_imageURL = [NSURL URLWithString:model.targetInfo[@"coverUrl"]];

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
@end
