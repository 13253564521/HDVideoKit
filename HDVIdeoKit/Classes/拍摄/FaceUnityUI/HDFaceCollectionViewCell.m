
//  HDFaceCollectionViewCell.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/12.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDFaceCollectionViewCell.h"
#import "Macro.h"

@interface HDFaceCollectionViewCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconimage;
@property (nonatomic, strong) UILabel *label;

@end
@implementation HDFaceCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = RGBA(57, 60, 67, 0.56);
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).offset(-20);
            make.width.height.mas_equalTo(48);
        }];

        self.iconimage = [[UIImageView alloc] init];
        self.iconimage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.iconimage];
        [self.iconimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.bgView);
        }];
        
        
        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont systemFontOfSize:14];
         self.label.textColor = [UIColor lightTextColor];
         self.label.textAlignment = NSTextAlignmentCenter;
         [self.contentView addSubview:self.label];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView);
            make.top.mas_equalTo(self.bgView.mas_bottom).offset(10);
        }];
    }
    return self;
}


- (void)setModel:(HDFaceModel *)model {
    _model = model;
    
    self.label.text = model.title;
    self.iconimage.image = [UIImage imageNamed:model.imageName];
    
    if (model.isselection == NO) {
        self.bgView.layer.borderWidth = 0;
    }else {
        self.bgView.layer.borderWidth = 2;
    }
}


@end
