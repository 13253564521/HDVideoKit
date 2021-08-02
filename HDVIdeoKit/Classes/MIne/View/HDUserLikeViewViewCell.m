//
//  HDUserLikeViewViewCell.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/9/28.
//

#import "HDUserLikeViewViewCell.h"
#import "Macro.h"
#import "HDServicesManager.h"

@interface HDUserLikeViewViewCell ()
@property(nonatomic , strong)UIImageView *usericonImageView;
@property(nonatomic , strong)UILabel *userNameLabel;
@property(nonatomic , strong)UIButton  *foucsButton;


@property(nonatomic , strong)UIButton  *rightButton;
@end

@implementation HDUserLikeViewViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _usericonImageView = [[UIImageView alloc]init];
        _usericonImageView.image = [UIImage imageNamed:HDBundleImage(@"testIcon.png")];
        _usericonImageView.layer.cornerRadius = 20;
        _usericonImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_usericonImageView];
        [_usericonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView).offset(20);
            make.width.height.mas_equalTo(40);
        }];
        
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:15];
        _userNameLabel.numberOfLines = 2;
        _userNameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_userNameLabel];
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.usericonImageView.mas_right).offset(5);
            make.centerY.mas_equalTo(self.usericonImageView);
            make.right.mas_equalTo(self.contentView).offset(-40);
        }];
        
        _foucsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _foucsButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_foucsButton setTitle:@"关注" forState:UIControlStateNormal];
        [_foucsButton setTitle:@"已互关" forState:UIControlStateSelected];
        [_foucsButton setTitleColor:[UIColor whiteColor] forState:0];
        [_foucsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _foucsButton.backgroundColor = UkeColorHex(0x749CFF);
        [_foucsButton addTarget:self action:@selector(foucsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_foucsButton];
        [_foucsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-20);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(56);
            make.height.mas_equalTo(25);
        }];
        _foucsButton.layer.cornerRadius = 12;
        _foucsButton.layer.masksToBounds = YES;
        
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightButton setImage:[UIImage imageNamed:HDBundleImage(@"navgation/btn_more")] forState:0];
        [self.contentView addSubview:self.rightButton ];
        [self.rightButton  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-20);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)foucsButtonAction:(UIButton *)sender {
    
    if (sender.selected == NO) {
        [HDServicesManager getuserguanzhuCouponDataWithResulblock:self.model.targetUserUuid black:^(BOOL isSuccess, NSString * _Nullable alertString) {
            if (isSuccess == YES) {
                sender.selected = YES;
//                [sender setBackgroundColor:RGBA(116, 156, 255, 1)];
            }
        }];
    }else {
        [HDServicesManager getuserquxiaoguanzhuCouponDataWithResulblock:self.model.targetUserUuid black:^(BOOL isSuccess, NSString * _Nullable alertString) {
            if (isSuccess == YES) {
                sender.selected = NO;
//                [sender setBackgroundColor:RGBA(255, 140, 6, 1)];
            }
        }];
    }
    
}

-(void)setModel:(HDMessageModel *)model {
    _model = model;
    _userNameLabel.text = model.nickName;
    
    if ([model.state intValue] == 8) {
        _foucsButton.selected = YES;
    }else {
        _foucsButton.selected = NO;
    }
    [self.usericonImageView yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];

    
    if (self.indext == 2 || self.indext == 3) {
        self.foucsButton.hidden = YES;
        self.rightButton.hidden = NO;
    }else {
        self.foucsButton.hidden = NO;
        self.rightButton.hidden = YES;
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
