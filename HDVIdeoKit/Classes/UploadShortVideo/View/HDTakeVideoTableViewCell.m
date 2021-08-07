//
//  HDTakeVideoTableViewCell.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/14.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDTakeVideoTableViewCell.h"
#import "HDTakeVideoModel.h"
#import "Macro.h"

@interface HDTakeVideoTableViewCell()
@property (nonatomic,strong)UIImageView *leftImageView;
@property (nonatomic,strong)UILabel *tileLabel;
@property (nonatomic,strong)UILabel *subtileLabel;
@property (nonatomic,strong)UIImageView *accessImageView;
@end

@implementation HDTakeVideoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        ///左侧图片
        self.leftImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.leftImageView];
        ////左侧主标题
        self.tileLabel = [[UILabel alloc]init];
        self.tileLabel.font = [UIFont boldSystemFontOfSize:14];
        self.tileLabel.textAlignment = NSTextAlignmentLeft;
        self.tileLabel.textColor = RGB(57, 60, 67);
        [self.contentView addSubview:self.tileLabel];
        ///副标题
        self.subtileLabel = [[UILabel alloc]init];
        self.subtileLabel.font = [UIFont boldSystemFontOfSize:14];
        self.subtileLabel.textAlignment = NSTextAlignmentRight;
        self.subtileLabel.textColor = RGB(57, 60, 67);
        [self.contentView addSubview:self.subtileLabel];
        ///箭头
        self.accessImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_system_arrowline_right")]];
        [self.contentView addSubview:self.accessImageView];
        
    }
    return  self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(24);
    }];
    
    [self.tileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.leftImageView.mas_right).offset(12);
        make.width.mas_equalTo(90);
    }];
    
    [self.subtileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.tileLabel.mas_right).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-40);
    }];
    
    [self.accessImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];
}

- (void)setModel:(HDTakeVideoModel *)model {
    _model = model;
    self.leftImageView.image = [UIImage imageNamed:HDBundleImage(model.imageName)];
    self.tileLabel.text = model.title;
    self.subtileLabel.text = model.subtitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
