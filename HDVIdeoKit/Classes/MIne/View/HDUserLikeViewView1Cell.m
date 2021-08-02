//
//  HDUserLikeViewView1Cell.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/9/30.
//

#import "HDUserLikeViewView1Cell.h"
#import "Macro.h"

@interface HDUserLikeViewView1Cell ()
@property(nonatomic , strong)UIImageView *usericonImageView;
@property(nonatomic , strong)UILabel *userNameLabel;
@property(nonatomic , strong)UILabel *timeLabel;
@property(nonatomic , strong)UIButton  *rightButton;
@end

@implementation HDUserLikeViewView1Cell

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
        _userNameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_userNameLabel];
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.usericonImageView.mas_right).offset(5);
            make.centerY.mas_equalTo(self.usericonImageView).offset(-8);
        }];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = [UIFont boldSystemFontOfSize:12];
        self.timeLabel.textColor = UkeColorHex(0x333333);
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userNameLabel);
            make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(0);
        }];
        
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

-(void)setModel:(HDUserVideoListModel *)model {
    _model = model;
    _userNameLabel.text = model.nickName;
    [self.usericonImageView yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];

    NSDate * myDate= [NSDate dateWithTimeIntervalSince1970:[model.createTime floatValue]];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeStr=[formatter stringFromDate:myDate];
    self.timeLabel.text = timeStr;
}
@end
