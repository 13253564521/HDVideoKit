//
//  HDMineCollectionViewCell.m
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/5.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDMineCollectionViewCell.h"
#import "Macro.h"
#import "YYWebImage.h"
#import "HDUkeInfoCenter.h"
@interface HDMineCollectionViewCell ()
@property(nonatomic , strong) UIImageView *imageView;
@property(nonatomic , strong) UIImageView *likeImageView;
@property(nonatomic , strong) UILabel *likeCountLabel;
@property(nonatomic , strong) UILabel *contentLabel;
@property(nonatomic , strong) UILabel *stateLabel;

@end
@implementation HDMineCollectionViewCell
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



- (void)setModel:(HDUserVideoListModel *)model {
    _model = model;
    for(UIView *view in [self.contentView subviews]) {
        [view removeFromSuperview];
    }

    NSLog(@"state :=%d",[model.state intValue]);
    [self initSubViews];
    if (self.isshow == YES) {
        
        if ([model.userUuid isEqualToString:[HDUkeInfoCenter sharedCenter].userModel.uuid]) {
            [self.stateLabel setHidden:NO];
            if ([model.state intValue] == 2 ) {
                self.stateLabel.text = @"审核中";
                self.stateLabel.backgroundColor = RGBA(116, 156, 255, 1);
            }else if ([model.state intValue] == 1){
                self.stateLabel.text = @"通过";
                self.stateLabel.backgroundColor = RGBA(0, 200, 202, 1);
            }else if ([model.state intValue] == 4 || [model.state intValue] == 9 || [model.state intValue] == 10 || [model.state intValue] == 3){
                self.stateLabel.text = @"未通过";
                self.stateLabel.backgroundColor = RGBA(255, 140, 6, 1);
            }else {
                [self.stateLabel setHidden:YES];
            }
        }
        
    }else {
        self.stateLabel.hidden = YES;
    }
    
    
    self.contentLabel.text = model.title;
    
    
    self.likeCountLabel.text = [self stringToInt:[model.likeCount stringValue]];
    self.imageView.yy_imageURL = [NSURL URLWithString:model.coverUrl];
    if (model.isLiked == NO) {
        self.likeImageView.image = [UIImage imageNamed:HDBundleImage(@"discover/icon_bicolor_zan")];
    }else {
        self.likeImageView.image = [UIImage imageNamed:HDBundleImage(@"discover/icon_hot")];
    }
    
}

@end
