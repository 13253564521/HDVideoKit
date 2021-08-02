//
//  HDMineCollectionViewCell1.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/13.
//

#import "HDMineCollectionViewCell1.h"
#import "Macro.h"
@interface HDMineCollectionViewCell1 ()
@property(nonatomic , strong) UIImageView *imageView;
@property(nonatomic , strong) UIImageView *likeImageView;
@property(nonatomic , strong) UILabel *likeCountLabel;
@property(nonatomic , strong) UILabel *contentLabel;
@property(nonatomic , strong) UILabel *stateLabel;

@end

@implementation HDMineCollectionViewCell1
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(145);
    }];
    
    self.stateLabel = [[UILabel alloc]init];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.font = [UIFont systemFontOfSize:11];
    self.stateLabel.textColor = [UIColor whiteColor];
    self.stateLabel.layer.cornerRadius = 10;
    self.stateLabel.layer.masksToBounds= YES;
    [self.imageView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView);
        make.left.mas_equalTo(self.imageView).offset(-8);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(25);
    }];
    
    self.likeCountLabel = [[UILabel alloc]init];
    self.likeCountLabel.textColor = [UIColor whiteColor];
    self.likeCountLabel.font = [UIFont systemFontOfSize:12];
    self.likeCountLabel.text = @"";
    [self.imageView addSubview:self.likeCountLabel];
    [self.likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imageView).offset(-5);
        make.right.mas_equalTo(self.imageView).offset(-5);
    }];
    
    self.likeImageView = [[UIImageView alloc]init];
    self.likeImageView.image = [UIImage imageNamed:HDBundleImage(@"discover/icon_hot")];
    [self.imageView addSubview:self.likeImageView];
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imageView).offset(-5);
        make.right.mas_equalTo(self.likeCountLabel.mas_left).offset(-5);
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    self.contentLabel.text = @"";
    self.contentLabel.numberOfLines = 2;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(5);
    }];
}

-(void)setModel1:(HDzhiboListModel *)model1 {
    _model1 = model1;
    for(UIView *view in [self.contentView subviews]) {
        [view removeFromSuperview];
    }

    [self initSubViews];
    self.contentLabel.text = model1.title;
    
    self.likeCountLabel.text = [self stringToInt:[model1.likeCount stringValue]];
    
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:model1.coverUrl] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];

    if (model1.isLiked == NO) {
        self.likeImageView.image = [UIImage imageNamed:HDBundleImage(@"discover/icon_bicolor_zan")];
    }else {
        self.likeImageView.image = [UIImage imageNamed:HDBundleImage(@"discover/icon_hot")];
    }
    
    
    if ([model1.state intValue] == 13) {
        self.stateLabel.text = @"预告";
        self.stateLabel.backgroundColor = UkeColorHex(0x00C8CA);
    }else if ([model1.state intValue] == 14) {
        self.stateLabel.text = @"直播中";
        self.stateLabel.backgroundColor = UkeColorHex(0xFF8C05);
    }else if ([model1.state intValue] == 15) {
        self.stateLabel.text = @"回看";
        self.stateLabel.backgroundColor = UkeColorHex(0x749CFF);
    }else {
        self.stateLabel.text = @"回看";
        self.stateLabel.backgroundColor = UkeColorHex(0x749CFF);
    }
}

@end
