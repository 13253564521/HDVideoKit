//
//  HDCustomTabBar.m
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/28.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDCustomTabBar.h"
#import "Macro.h"

#define kBadgeWidth  8  // 红点宽高

@interface HDCustomTabBar()
/**中间AR按钮*/
@property (nonatomic,strong) UIButton *addBtn;
/**预留lable*/
@property (nonatomic,strong) UILabel *addLable;
@property (nonatomic,strong) UIView *badgeView;
@end
@implementation HDCustomTabBar

+ (instancetype)sharedManager {
    static HDCustomTabBar *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HDCustomTabBar alloc] init];
    });
    return instance;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:HDBundleImage(@"tabbar/add")] forState:normal];
        [addBtn addTarget:self action:@selector(arBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        self.addBtn = addBtn;
        
        self.badgeView = [[UIView alloc]init];
        self.badgeView.layer.cornerRadius = kBadgeWidth / 2;
        self.badgeView.backgroundColor = [UIColor redColor];
        self.badgeView.hidden = YES;
        [self addSubview:self.badgeView];
    }
    return self;
}

- (void)arBtnClick {
    
    if ([self.delegate respondsToSelector:@selector(addButtonClick:clickItem:)]) {
        [self.delegate addButtonClick:self clickItem:self.addBtn];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger i = 0;
    CGFloat width = self.frame.size.width / 5;
    
    //设置AR按钮的位置
    self.addBtn.frame = CGRectMake(0, 5, 40, 40);
    self.addBtn.center = CGPointMake(self.center.x,self.addBtn.center.y);
    
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            btn.frame = CGRectMake(width * i, btn.frame.origin.y, width, 49);
            
            if (i == 3) {
                CGFloat x = btn.frame.origin.x + btn.frame.size.width / 2 + 9;
                CGFloat y = 6;
                self.badgeView.frame = CGRectMake(x, y, kBadgeWidth, kBadgeWidth);
            }
            i++;
            if (i == 2) {
                i++;
            }
            
        }
        
    }
    
    [self bringSubviewToFront:self.addBtn];
    [self bringSubviewToFront:self.badgeView];
    
    
    
}
 //重写hitTest方法，去监听"+"按钮和“添加”标签的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {
        CGPoint newBtnPoint = [self convertPoint:point toView:self.addBtn];
        if ([self.addBtn pointInside:newBtnPoint withEvent:event]) {
            return self.addBtn;
        }else{
            
            return [super hitTest:point withEvent:event];
            
        }
    }else{
        
        return [super hitTest:point withEvent:event];
        
    }
    
    
}

//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    float  spacing = 0;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}

- (void)showxiaoxi {
    self.badgeView.hidden = NO;
}

- (void)dismmxiaoxi {
    self.badgeView.hidden = YES;
}

@end
