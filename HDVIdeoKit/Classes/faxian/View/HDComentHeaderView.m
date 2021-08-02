//
//  HDComentHeaderView.m
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/6.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDComentHeaderView.h"
#import "Macro.h"
@interface HDComentHeaderView()
@property(nonatomic , strong)UIImageView *userIconImageView;
@property(nonatomic , strong)UILabel *userNameLabel;
@property(nonatomic , strong)UILabel *contentLabel;
@property(nonatomic , strong)UILabel *timelabel;
@property(nonatomic , strong)UIButton *replayButton;
@property(nonatomic , strong)UIButton *replaycountButton;

@end
@implementation HDComentHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ([super  initWithReuseIdentifier:reuseIdentifier]) {
        _userIconImageView = [[UIImageView  alloc]init];
        _userIconImageView.image = [UIImage imageNamed:HDBundleImage(@"testIcon")];
        [self.contentView addSubview:_userIconImageView];
        
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.font = [UIFont systemFontOfSize:12];
        _userNameLabel.textColor =  RGBA(154, 154, 154, 1);
        _userNameLabel.text = @"爱踩花的牛爱花";
        [self.contentView addSubview:_userNameLabel];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor =  RGBA(52, 52, 52, 1);
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈这里是评论想打多少就打多少";
        [self.contentView addSubview:_contentLabel];
        
        _timelabel = [[UILabel alloc]init];
        _timelabel.font = [UIFont systemFontOfSize:10];
        _timelabel.textColor = RGBA(154, 154, 154, 1);
        _timelabel.text = @"13分钟前";
        [self.contentView addSubview:_timelabel];
        
        
        _replaycountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replaycountButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_replaycountButton setTitleColor:RGBA(154, 154, 154, 1) forState:UIControlStateNormal];
        [_replaycountButton setTitle:@"-----展开90条回复" forState:UIControlStateNormal];
        [_replaycountButton addTarget:self action:@selector(replaycountButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_replaycountButton];
        
        _replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replayButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_replayButton setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        [_replayButton setTitle:@"回复" forState:UIControlStateNormal];
        [_replayButton addTarget:self action:@selector(replayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_replayButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat iconWH = 32;
    CGFloat iconTM = 12;
    CGFloat iconLM = 20;
    _userIconImageView.frame = CGRectMake(iconLM, iconTM, iconWH, iconWH);
    
    CGFloat nameLabelL = 10;
    CGFloat nameLabelT = 5;
    CGFloat nameLabelH = 12;
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userIconImageView.frame) + nameLabelL, _userIconImageView.frame.origin.y + 5, self.contentView.frame.size.width - CGRectGetMaxX(_userIconImageView.frame) - nameLabelL - iconLM, nameLabelH);

    CGFloat contentLabelT = 7;
    _contentLabel.frame = CGRectMake(_userNameLabel.frame.origin.x, CGRectGetMaxY(_userNameLabel.frame) + contentLabelT, _userNameLabel.frame.size.width, 40);
    
    CGFloat timelabelT = 14;
    CGFloat timeLabelH = 10;
    _timelabel.frame = CGRectMake(_userNameLabel.frame.origin.x, CGRectGetMaxY(_contentLabel.frame) + timelabelT, _userNameLabel.frame.size.width, timeLabelH);
    
    CGFloat replaycountW = 100;
    CGFloat replaycountH = 10;
    CGFloat replayCountT = 6;
    _replaycountButton.frame = CGRectMake(_userNameLabel.frame.origin.x, CGRectGetMaxY(_contentLabel.frame) + replayCountT, replaycountW, replaycountH);
    
    
    CGFloat replayButtonT = 12;
    CGFloat replayButtonW = 23;
    CGFloat replayButtonH = 12;
    CGFloat replayButtonR = 20;
    _replayButton.frame = CGRectMake(self.contentView.frame.size.width - replayButtonR - replaycountW, CGRectGetMaxY(_contentLabel.frame) + replayButtonT, replayButtonW, replayButtonH);

}

#pragma mark - buttonAction
- (void)replaycountButtonAction:(UIButton *)sender {
    NSLog(@"%s",__func__);
}

- (void)replayButtonAction:(UIButton *)sender {
    NSLog(@"%s",__func__);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
