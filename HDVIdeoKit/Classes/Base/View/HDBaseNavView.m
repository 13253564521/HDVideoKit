//
//  HDBaseNavView.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/14.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDBaseNavView.h"
#import "Macro.h"
@interface HDBaseNavView()
///返回按钮
@property(nonatomic,strong)UIButton *backButtn;
///导航标题
@property(nonatomic,strong)UILabel  *titleLabel;

@end


@implementation HDBaseNavView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self.title = title;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubVeiws];
    }
    return self;
}

- (void)initSubVeiws {
    UIColor *pageColor = RGBA(225, 228, 233, 1);
    self.backgroundColor = pageColor;
    self.backButtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButtn setImage:[UIImage imageNamed:HDBundleImage(@"navgation/btn_back1")] forState:UIControlStateNormal];
    [self.backButtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButtn];
    [self.backButtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(GS_StatusBarHeight + 10);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = RGB(57, 60, 67);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = self.title;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(100);
        make.right.equalTo(self.mas_right).offset(-100);
        make.centerY.equalTo(self.backButtn.mas_centerY);
    }];
    
    
}

- (void)backAction {
    !self.backBlock ? : self.backBlock();
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
