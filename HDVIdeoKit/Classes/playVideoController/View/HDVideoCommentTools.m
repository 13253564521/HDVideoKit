//
//  HDVidoCommentTools.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/25.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDVideoCommentTools.h"
#import "Macro.h"

@interface HDVideoCommentTools ()
/** 内容视图 */
@property(nonatomic,strong) UIView *contentView;
/** 左侧图片 */
@property(nonatomic,strong) UIImageView *leftImageView;

/** 文字提示 */
@property(nonatomic,strong) UILabel *placeholderLabel;


@end

@implementation HDVideoCommentTools
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubVeiws];
    }
    return self;
}

- (void)initSubVeiws {

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = RGBA(57, 60, 67, 0.08);
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(12);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.mas_equalTo(32);
    }];
    
    self.leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:HDBundleImage(@"video/icon_bicolor_edit")]];
    [self.contentView addSubview:self.leftImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    self.placeholderLabel = [[UILabel alloc]init];
    self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.placeholderLabel];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(8);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    NSString *holderText = @"写评论...";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:RGBA(57, 60, 67, 0.56)
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, holderText.length)];
    self.placeholderLabel.attributedText = placeholder;
    
    
    //添加点击事件
    UITapGestureRecognizer *tapToolsViewGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toolsViewClick)];
    [self.contentView addGestureRecognizer:tapToolsViewGes];
}

- (void)toolsViewClick {
    NSLog(@"点击评论");
    !self.writeCommentBlock ? :  self.writeCommentBlock();
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface HDWriteCommentView ()<UITextViewDelegate>
@property (nonatomic , strong) UIView *contentView;
@property (nonatomic , strong) UIButton *cancleButton;
@property (nonatomic , strong) UIButton *sendButton;
@property (nonatomic , strong) UIView *lineView;

@property (nonatomic , strong) UITextView *textView;
@property (nonatomic , strong) UILabel *placeHolder;

@end


@implementation HDWriteCommentView
#pragma mark - 懒加载
- (UILabel *)placeHolder {
    if (!_placeHolder) {
        _placeHolder = [[UILabel alloc]init];
        _placeHolder.text = @"写点评论，说点什么吧…";
        _placeHolder.numberOfLines = 0;
        _placeHolder.font = [UIFont systemFontOfSize:14];
        _placeHolder.textColor = RGBA(57, 60, 67, 0.32);
    }
    return _placeHolder;
}
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {

    CGFloat contentViewH = 191;
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - contentViewH, self.frame.size.width, contentViewH)];
    CGFloat radius = 15; // 圆角大小
    UIRectCorner corner = UIRectCornerTopLeft|UIRectCornerTopRight; // 圆角位置，全部位置
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = path.CGPath;
    self.contentView.layer.mask = maskLayer;
    [self addSubview:self.contentView];
    //渐变色 圆角
    //    ///渐变色
    CAGradientLayer *gradientLayer = [self getGradientLayerWithBounds:self.contentView.bounds colorsArray:[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil]];
    [self.contentView.layer insertSublayer:gradientLayer atIndex:0];

    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:RGBA(57, 60, 67, 0.76) forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(cancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancleButton];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.height.mas_equalTo(22);
    }];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.sendButton setTitle:@"发布" forState:UIControlStateNormal];
    [self.sendButton setTitle:@"发布" forState:UIControlStateSelected];
    [self.sendButton setTitleColor:RGBA(57, 60, 67, 0.22) forState:UIControlStateNormal];
    [self.sendButton setTitleColor:RGBA(57, 60, 67, 0.76) forState:UIControlStateSelected];
    [self.sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.height.mas_equalTo(22);
    }];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = RGBA(50, 60, 67, 0.08);
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.sendButton.mas_bottom).offset(16);
        make.height.mas_equalTo(1);
    }];
    
    
    self.textView = [[UITextView alloc]init];
    self.textView.textColor = [UIColor clearColor];
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.backgroundColor = RGBA(225, 228, 233, 1);
    self.textView.delegate = self;
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.lineView.mas_bottom).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.height.mas_equalTo(104);
    }];
    
    [self.textView addSubview:self.placeHolder];
    [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textView.mas_left).offset(4);
        make.top.equalTo(self.textView.mas_top).offset(8);
    }];
    
}
#pragma mark - buttonClick
- (void)cancleButtonClick:(UIButton *)sender {
    !self.cancleBtnBlock ? : self.cancleBtnBlock();
    [self uke_resignFirstResponder];
}

- (void)sendButtonClick:(UIButton *)sender {
    !self.sendBtnBlock ? : self.sendBtnBlock(self.textView.text);
    self.textView.text = @"";
    
}
- (void)uke_resignFirstResponder {
    @try {
        if (self.textView.isFirstResponder == NO) {
            return;
        }

        [self.textView resignFirstResponder];
    } @catch (NSException *exception) {} @finally {}
}

- (void)uke_becomeFirstResponder {
    @try {
        if (self.textView.isFirstResponder) {
            return;
        }
    
        
        [self.textView becomeFirstResponder];
    } @catch (NSException *exception) {} @finally {}
}

- (CAGradientLayer *)getGradientLayerWithBounds:(CGRect)bounds  colorsArray:(NSArray *)colorsArray {
    //添加渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = bounds;
    // 渐变色颜色数组,可多个
    gradientLayer.colors = colorsArray;//[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil];
    // 渐变的开始点 (不同的起始点可以实现不同位置的渐变,如图)
    gradientLayer.startPoint = CGPointMake(0.5f, 0); //(0, 0)
    // 渐变的结束点
    gradientLayer.endPoint = CGPointMake(0.5f, 1.f); //(1, 1)
    
    return gradientLayer;
}
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeHolder.alpha = 0;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.text.length) {
        self.placeHolder.alpha = 1;
        self.sendButton.selected = NO;
        self.sendButton.userInteractionEnabled = NO;
    }else{
        self.sendButton.selected = YES;
        self.sendButton.userInteractionEnabled = YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (!textView.text.length) {
        self.placeHolder.alpha = 1;
        self.sendButton.selected = NO;
        self.sendButton.userInteractionEnabled = NO;
    } else {
        self.placeHolder.alpha = 0;
        self.sendButton.selected = YES;
        self.sendButton.userInteractionEnabled = YES;
    }
    
//    if (textView.markedTextRange == nil && textView.text.length + self.selecthuatiLabel.text.length  > 30) {
////        NSLog(@"ooo=%lu",30 - self.slecthuati.text.length);
////        if (30 - self.slecthuati.text.length > 0) {
//            textView.text = [textView.text substringToIndex:30 - self.selecthuatiLabel.text.length];
////        }
//
//    }
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    textView.textColor = RGBA(57, 60, 67, 1);
    textView.font = [UIFont systemFontOfSize:14];
    
    if ([text isEqualToString:@""] && range.length > 0) {
        // 删除字符肯定是安全的
        return YES;
    }
    return YES;
}
@end
