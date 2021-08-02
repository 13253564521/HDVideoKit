//
//  HDShareView.m
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/9/2.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDShareView.h"
#import "Macro.h"

@interface HDShareView()

/** 关闭按钮 */
@property(nonatomic,strong) UIButton *closeButton;

/** 容器 */
@property(nonatomic,strong) UIView *shareView;

/** lineView*/
@property(nonatomic,strong) UIView *lineView;

/** 微信f分享 */
@property(nonatomic , strong) UIButton *wchatshareButton;
/** 微信朋友圈分享 */
@property(nonatomic , strong) UIButton *wchatzoneshareButton;
/** WEB分享 */
@property(nonatomic , strong) UIButton *webshareButton;

@end
@implementation HDShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubVeiws];
    }
    return self;
}
- (void)initSubVeiws {
    self.backgroundColor = RGBA(0, 0, 0, 0.6);
    
    _shareView = [[UIView alloc]init];
    [self addSubview:_shareView];

    
    


    _wchatshareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _wchatshareButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_wchatshareButton setTitleColor:RGBA(57, 60, 67, 0.56) forState:UIControlStateNormal];
    [_wchatshareButton setImage:[UIImage imageNamed:HDBundleImage(@"share/icon_wechatshare")] forState:UIControlStateNormal];
    [_wchatshareButton setTitle:@"微信好友" forState:UIControlStateNormal];
    [_wchatshareButton addTarget:self action:@selector(wchatshareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:_wchatshareButton];
    
    _wchatzoneshareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _wchatzoneshareButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_wchatzoneshareButton setTitleColor:RGBA(57, 60, 67, 0.56) forState:UIControlStateNormal];
    [_wchatzoneshareButton setImage:[UIImage imageNamed:HDBundleImage(@"share/icon_wecrecleshare")] forState:UIControlStateNormal];
    [_wchatzoneshareButton setTitle:@"朋友圈" forState:UIControlStateNormal];
    [_wchatzoneshareButton addTarget:self action:@selector(wchatzoneshareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:_wchatzoneshareButton];
    
    _webshareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _webshareButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_webshareButton setTitleColor:RGBA(57, 60, 67, 0.56) forState:UIControlStateNormal];
    [_webshareButton setImage:[UIImage imageNamed:HDBundleImage(@"share/icon_shareUrl")] forState:UIControlStateNormal];
    [_webshareButton setTitle:@"复制链接" forState:UIControlStateNormal];
    [_webshareButton addTarget:self action:@selector(webshareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:_webshareButton];
    
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = RGBA(139, 143, 160, 0.1);
    [self.shareView addSubview:self.lineView];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setBackgroundColor:[UIColor clearColor]];
    [self.closeButton setTitle:@"取消" forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.closeButton setTitleColor:RGBA(0, 61, 227, 1) forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:self.closeButton];
    
    

    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat shareH = 190 + GS_TabbarSafeBottomMargin;
    _shareView.frame = CGRectMake(0, self.frame.size.height - shareH, self.frame.size.width, shareH);
    
    [self.wchatshareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareView.mas_centerX);
        make.top.equalTo(self.shareView.mas_top).offset(20);
        make.height.mas_equalTo(92);
        make.width.mas_equalTo(64);
    }];
    
    [self.wchatzoneshareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.wchatshareButton.mas_left).offset(-44);
        make.top.equalTo(self.wchatshareButton.mas_top);
        make.height.mas_equalTo(92);
        make.width.mas_equalTo(64);
    }];
    
    [self.webshareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wchatshareButton.mas_right).offset(44);
        make.top.equalTo(self.wchatshareButton.mas_top);
        make.height.mas_equalTo(92);
        make.width.mas_equalTo(64);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.shareView);
        make.top.equalTo(self.wchatshareButton.mas_bottom).offset(20);
        make.height.mas_equalTo(8);
        
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.shareView);
        make.top.equalTo(self.lineView.mas_bottom).offset(1);
        make.height.mas_equalTo(48);
    }];
    
    CAGradientLayer *shareViewdientLayer = [self getGradientLayerWithBounds:_shareView.bounds colorsArray:[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil]];
    [_shareView.layer insertSublayer:shareViewdientLayer atIndex:0];
    //切圆s角
    _shareView.layer.mask = [self circleMaskLayerWithView:_shareView byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:15];
    
    [self changeButtonType:self.wchatshareButton];
    [self changeButtonType:self.wchatzoneshareButton];
    [self changeButtonType:self.webshareButton];
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
#pragma mark - buttonAction

- (void)closeAction:(UIButton *)sender {
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(hd_shareViewdidClickClose)]) {
        [self.delegate hd_shareViewdidClickClose];
    }
}


- (void)wchatshareButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(hd_shareViewdidClickWchat)]) {
        [self.delegate hd_shareViewdidClickWchat];
    }
}
- (void)wchatzoneshareButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(hd_shareViewdidClickWchatZone)]) {
        [self.delegate hd_shareViewdidClickWchatZone];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(hd_shareViewdidClickClose)]) {
        [self.delegate hd_shareViewdidClickClose];
    }
}

- (void)webshareButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(hd_shareViewdidClickWebUrl)]) {
        [self.delegate hd_shareViewdidClickWebUrl];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CAGradientLayer *)getGradientLayerWithBounds:(CGRect)bounds  colorsArray:(NSArray *)colorsArray {
    //添加渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = bounds;
    // 渐变色颜色数组,可多个
    gradientLayer.colors = colorsArray;//[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil];
    // 渐变的开始点 (不同的起始点可以实现不同位置的渐变,如图)
    gradientLayer.startPoint = CGPointMake(0, 0.5f); //(0, 0)
    // 渐变的结束点
    gradientLayer.endPoint = CGPointMake(1, 0.5f); //(1, 1)
    
    return gradientLayer;
}

//图片在上，文字在下
- (void)changeButtonType:(UIButton *)button {
    CGFloat interval = 8.0;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    CGSize imageSize = button.imageView.bounds.size;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width), 0, 0)];
    CGSize titleSize = button.titleLabel.bounds.size;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + interval, -(titleSize.width))];
}

@end
