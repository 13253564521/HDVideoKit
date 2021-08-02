//
//  HDPOIsTableViewCell.m
//  HDVideoKitDemok
//
//  Created by LiuGaoSheng on 2021/7/21.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDPOIsTableViewCell.h"
#import "Macro.h"
#import "HDPOIModel.h"

@interface HDPOIsTableViewCell()
@property(nonatomic , strong) UILabel *titleLabel;
@property(nonatomic , strong) UILabel *subTitleLabel;
@property(nonatomic , strong) UIImageView *selectImageView;
@end
@implementation HDPOIsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel =  [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = RGBA(57, 60, 67, 1);
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];

        
        self.subTitleLabel =  [[UILabel alloc]init];
        self.subTitleLabel.font = [UIFont systemFontOfSize:12];
        self.subTitleLabel.textColor = RGBA(57, 60, 67, 0.6);
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.subTitleLabel];
        
        
        self.selectImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_system_duigou")]];
        [self addSubview:self.selectImageView];
        [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-16);
            make.centerY.equalTo(self.mas_centerY);
        }];

    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(HDPOIModel *)model {
    _model = model;
    if ([model.name isEqualToString:@""]) {
        [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.right.equalTo(self.selectImageView.mas_right).offset(-16);
            make.top.bottom.equalTo(self);
        }];
    }else{
        [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.right.equalTo(self.selectImageView.mas_right).offset(-16);
            make.top.equalTo(self.mas_top).offset(16);
            
        }];
    }
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
        make.right.equalTo(self.titleLabel.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-16);
    }];
    
    self.selectImageView.hidden = YES;
    
    
    if ([model.name isEqualToString:@"不显示位置"]) {
        self.titleLabel.textColor = [UIColor blueColor];
    }else{
        self.titleLabel.textColor = RGBA(57, 60, 67, 1);
    }
    
    self.titleLabel.text = model.name;
    self.subTitleLabel.text = model.address;
    
    
}
- (void)showSelectedView:(BOOL)show {
    self.selectImageView.hidden = !show;
}
@end
