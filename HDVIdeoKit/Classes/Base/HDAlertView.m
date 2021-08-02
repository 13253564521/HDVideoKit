//
//  HDAlertView.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/21.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDAlertView.h"
#import "Macro.h"

@interface HDAlertView ()
@property(nonatomic,strong) UIView *alerkView;


@end

@implementation HDAlertView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIView *back = [[UIView alloc]init];
        back.alpha = 0.5;
        back.backgroundColor = [UIColor blackColor];
        [self addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        self.alerkView = [[UIView alloc]init];
        self.alerkView.layer.masksToBounds = YES;
        self.alerkView.layer.cornerRadius =6;
        self.alerkView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.alerkView];
        [self.alerkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(270);
            make.height.mas_equalTo(144);
        }];
        
        UILabel *titl = [[UILabel alloc]init];
        titl.text = @"个人信息保护指引";
        titl.font = [UIFont systemFontOfSize:15];
        titl.textColor = [UIColor blackColor];
        [self.alerkView addSubview:titl];
        [titl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.alerkView);
            make.top.mas_equalTo(self.alerkView).offset(10);
        }];
        
//        选择同意代表您已 阅读并同意《用户协议》
        UILabel *titl1 = [[UILabel alloc]init];
          titl1.text = @"选择同意代表您已";
          titl1.font = [UIFont systemFontOfSize:12];
          titl1.textColor = [UIColor blackColor];
          [self.alerkView addSubview:titl1];
          [titl1 mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerX.mas_equalTo(self.alerkView);
              make.top.mas_equalTo(titl.mas_bottom).offset(20);
          }];
        
        UILabel *titl2 = [[UILabel alloc]init];
        titl2.text = @"阅读并同意";
        titl2.font = [UIFont systemFontOfSize:12];
        titl2.textColor = [UIColor blackColor];
        [self.alerkView addSubview:titl2];
        [titl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(titl1.mas_centerX);
            make.top.mas_equalTo(titl1.mas_bottom).offset(5);
        }];
        
        
        UIButton *xieyiButton = [[UIButton alloc]init];
       [xieyiButton setTitle:@"《用户协议》" forState:0];
       [xieyiButton setTitleColor:UkeColorHex(0x749CFF) forState:0];
       xieyiButton.titleLabel.font = [UIFont systemFontOfSize:15];
       [xieyiButton addTarget:self action:@selector(xieyiButtonuDid) forControlEvents:UIControlEventTouchUpInside];
       [self.alerkView addSubview:xieyiButton];
       [xieyiButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(titl2.mas_right);
           make.centerY.mas_equalTo(titl2);
           
       }];
        
        UIButton *letButton = [[UIButton alloc]init];
        [letButton setTitle:@"不同意" forState:0];
        [letButton setTitleColor:[UIColor blackColor] forState:0];
        letButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [letButton addTarget:self action:@selector(lefuDid) forControlEvents:UIControlEventTouchUpInside];
        [self.alerkView addSubview:letButton];
        [letButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(self.alerkView);
            make.height.mas_equalTo(43);
            make.width.mas_equalTo(270/2);
        }];
        
       
        
        
        UIButton *rightButton = [[UIButton alloc]init];
        [rightButton setTitle:@"同意" forState:0];
        [rightButton setTitleColor:UkeColorHex(0x749CFF) forState:0];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightButton addTarget:self action:@selector(rightButtonDid) forControlEvents:UIControlEventTouchUpInside];
        [self.alerkView addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(self.alerkView);
            make.height.mas_equalTo(43);
            make.width.mas_equalTo(270/2);
        }];
    }
    return self;
}

+(instancetype)showView:(UIView *)view {
    HDAlertView *aler =[[HDAlertView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [view addSubview:aler];
    [aler mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
    return aler;
}

-(void)lefuDid {
    if ([self.dalegate respondsToSelector:@selector(dismms)]) {
        [self.dalegate dismms];
    }
    
    [self removeFromSuperview];
}


-(void)rightButtonDid {
    if ([self.dalegate respondsToSelector:@selector(tongyi)]) {
        [self.dalegate tongyi];
    }
     [self removeFromSuperview];
}

-(void)xieyiButtonuDid {
    if ([self.dalegate respondsToSelector:@selector(didxieyi)]) {
        [self.dalegate didxieyi];
    }
}
@end
