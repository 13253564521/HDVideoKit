//
//  HDMessagesTableViewCell.m
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/5.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDMessagesTableViewCell.h"
#import "Macro.h"
#import "HDServicesManager.h"
#import "YYWebImage.h"
#import "NSDate+MJ.h"

@interface HDMessagesTableViewCell()
@property(nonatomic , strong)UIImageView *usericonImageView;
@property(nonatomic , strong)UILabel *userNameLabel;
@property(nonatomic , strong)UILabel  *subDesLabel;
@property(nonatomic , strong)UIButton  *foucsButton;

@property(nonatomic , strong)UILabel  *time1;
@end

@implementation HDMessagesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _usericonImageView = [[UIImageView  alloc]init];
        _usericonImageView.image = [UIImage imageNamed:HDBundleImage(@"testIcon.png")];
        [self.contentView addSubview:_usericonImageView];
        
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:15];
        _userNameLabel.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:_userNameLabel];
        
        _subDesLabel = [[UILabel alloc]init];
        _subDesLabel.font = [UIFont  systemFontOfSize:12];
        _subDesLabel.textColor = RGBA(52, 52, 52, 1);
        [self.contentView addSubview:_subDesLabel];
        
        
        _foucsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _foucsButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_foucsButton setTitle:@"回关" forState:UIControlStateNormal];
        [_foucsButton setTitle:@"已互关" forState:UIControlStateSelected];
        [_foucsButton addTarget:self action:@selector(foucsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_foucsButton];
        
        
        self.time1 = [[UILabel alloc]init];
        self.time1.font = [UIFont  systemFontOfSize:12];
        self.time1.textColor = RGBA(52, 52, 52, 1);
        [self.contentView addSubview:self.time1];
        [self.time1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-20);
        }];
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat userIconHW = 40;
    CGFloat uesrIconLM = 20;
    
    self.usericonImageView.frame = CGRectMake(uesrIconLM, (self.contentView.frame.size.height - userIconHW) * 0.5, userIconHW, userIconHW);
    
    CGFloat userNameL = 5.5;
    CGFloat foucsW = 56;
    CGFloat foucsH = 24;
    CGFloat foucsR = 20;
    self.userNameLabel.frame = CGRectMake(CGRectGetMaxX(self.usericonImageView.frame) + userNameL, self.usericonImageView.frame.origin.y, self.contentView.frame.size.width - CGRectGetMaxX(self.usericonImageView.frame) - userNameL - foucsW - foucsR, userIconHW * 0.5);
    self.subDesLabel.frame = CGRectMake(self.userNameLabel.frame.origin.x, CGRectGetMaxY(self.userNameLabel.frame), self.userNameLabel.frame.size.width, userIconHW *0.5);
    
    
    self.foucsButton.frame = CGRectMake(self.contentView.frame.size.width - foucsR - foucsW, (self.contentView.frame.size.height - foucsH) * 0.5, foucsW, foucsH);
    
    
    self.usericonImageView.layer.mask = [self cicleMaskLayerWithImageView:self.usericonImageView];
    self.foucsButton.layer.mask = [self circleMaskLayerWithView:self.foucsButton byRoundingCorners:UIRectCornerAllCorners radius:12];

    
    
    
}

- (void)foucsButtonAction:(UIButton *)sender {
    
    if (sender.selected == NO) {
        [HDServicesManager getuserguanzhuCouponDataWithResulblock:self.model.targetUserUuid black:^(BOOL isSuccess, NSString * _Nullable alertString) {
            if (isSuccess == YES) {
                sender.selected = YES;
                [sender setBackgroundColor:RGBA(116, 156, 255, 1)];
            }
        }];
    }else {
        [HDServicesManager getuserquxiaoguanzhuCouponDataWithResulblock:self.model.targetUserUuid black:^(BOOL isSuccess, NSString * _Nullable alertString) {
            if (isSuccess == YES) {
                sender.selected = NO;
                [sender setBackgroundColor:RGBA(255, 140, 6, 1)];
            }
        }];
    }
    
}


-(void)setModel:(HDMessageModel *)model {
    _model = model;
    
    if (model.isguangfangtongzhi == YES) {
//        _subDesLabel.hidden = YES;
        _foucsButton.hidden = YES;
        
        self.time1.hidden = NO;
        NSDate *date = [[NSDate alloc]init];
        self.time1.text = [date timeStringWithTimeInterval:model.createTime];
        
        _userNameLabel.text = @"解放行官方";
        self.usericonImageView.image = [UIImage imageNamed:HDBundleImage(@"currency/icon_jiefang")];
        
        if (model.target == 14) {
            self.subDesLabel.text = @"您被多次举报，您已被禁止发布视频/评论消息";
        }else if (model.target == 5) {
            self.subDesLabel.text = [NSString stringWithFormat:@"%@点赞了你的视频/直播",model.nickName];
        }else if (model.target == 6 || model.target == 7) {
            self.subDesLabel.text = @"您举报的内容已做处理，感谢您的真实反馈";
        }else if (model.target == 8) {
            self.subDesLabel.text = @"您的账号被用户举报";
        }else if (model.target == 9) {
            self.subDesLabel.text = @"您的短视频被用户举报";
        }else if (model.target == 12) {
            self.subDesLabel.text = @"您有一个视频被下架";
        }
    }else {
        _subDesLabel.hidden = NO;
        _foucsButton.hidden = NO;
        self.time1.hidden = YES;
        NSDate *date = [[NSDate alloc]init];
        _subDesLabel.text = [date timeStringWithTimeInterval:model.createTime];
        
        if ([model.state intValue] == 8) {
            _foucsButton.selected = YES;
            [_foucsButton setBackgroundColor:RGBA(116, 156, 255, 1)];

        }else {
            _foucsButton.selected = NO;
            [_foucsButton setBackgroundColor:RGBA(255, 140, 6, 1)];
        }
        
        _userNameLabel.text = model.nickName;
        [self.usericonImageView yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];
    }
    
   

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
