//
//  HDLiveReleaseView.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/14.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDLiveReleaseView.h"
#import "Macro.h"
@interface HDLiveReleaseView()<UITextViewDelegate>
/** baseScroller */
@property(nonatomic,strong) UIScrollView *baseScrolleView;
/** 内容视图 */
@property(nonatomic,strong) UIView  *contentView;

/** textView */
@property(nonatomic,strong) UITextView *textView;

/** placeHolder */
@property(nonatomic,strong) UILabel  *placeHolder;


/** 专辑封面 */
@property(nonatomic,strong) UIImageView  *albumcoverImageView;

/** 添加专辑封面按钮 */
@property(nonatomic,strong) UIButton  *addCoverButton;


/** 选中图片 */
@property(nonatomic,strong) UIView  *selectedCoverView;
/** 删除选中封面图片 */
@property(nonatomic,strong) UIButton  *deleteCoverButton;



/** 提示 */
@property(nonatomic,strong) UILabel  *hintLabel;
/** 分割线 */
@property(nonatomic,strong) UIView  *lineView;

/** 话题选择*/
@property(nonatomic,strong) UIView  *huatiView;

/** 话题选择 === 图片*/
@property(nonatomic,strong) UIImageView  *huatiImageView;
/** 话题选择 === 标题*/
@property(nonatomic,strong) UILabel  *huatiLabel;
/** 话题选择 === 选中话题*/
@property(nonatomic,strong) UILabel  *selecthuatiLabel;
/** 话题选择 === 箭头*/
@property(nonatomic,strong) UIImageView  *huatiarrowImageView;


/** 位置选择*/
@property(nonatomic,strong) UIView  *locationView;

/** 位置选择 === 图片*/
@property(nonatomic,strong) UIImageView  *locationImageView;
/** 位置选择=== 标题*/
@property(nonatomic,strong) UILabel  *locationLabel;
/** 位置选择 === 选项*/
@property(nonatomic,strong) UIButton  *locationuseSwitchButton;





/**使用表单功能 */
@property(nonatomic,strong) UIButton  *formliveButton;

/**使用抽奖功能 */
@property(nonatomic,strong) UIButton  *lotteryButton;


/** 直播预告试图*/
@property(nonatomic,strong) UIView  *livepreView;
/** 直播预告 === 图片*/
@property(nonatomic,strong) UIImageView  *livepreImageView;
/** 直播预告 === 标题*/
@property(nonatomic,strong) UILabel  *livepreLabel;
/** 直播预告 === 选中话题*/
@property(nonatomic,strong) UILabel  *selectlivepreLabel;
/** 直播预告 === 箭头*/
@property(nonatomic,strong) UIImageView  *liveprearrowImageView;



/** 硬件直播直播点击子视图*/
@property(nonatomic,strong) UIView  *hardwareliveView;
/** 硬件直播直播 === 标题*/
@property(nonatomic,strong) UILabel  *hardwareliveLabel;
/** 硬件直播直播 === url*/
@property(nonatomic,strong) UILabel  *hardwareliveurlLabel;
/** 硬件直播直播 === 点击复制*/
@property(nonatomic,strong) UIButton  *replicateUrlButton;


/**
 lottery 抽奖预加载视图
 */
@property(nonatomic,strong) UIView  *lotteryView;
/**
 lottery textfield
 */
@property(nonatomic,strong) UITextField  *lotteryTextField;

/**
 lottery 下划线
 */
@property(nonatomic,strong) UIView  *lotterylineView;



/** 下一步*/
@property(nonatomic,strong) UIView  *nextView;
/**下一步 按钮*/
@property(nonatomic,strong) UIButton  *nextButton;
@end

@implementation HDLiveReleaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.baseScrolleView = [[ UIScrollView alloc]init];
    [self addSubview:self.baseScrolleView];
    [self.baseScrolleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = RGBA(225, 228, 233, 1);
    [self.baseScrolleView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.baseScrolleView);
        make.width.equalTo(self.baseScrolleView);
    }];
    
    self.textView = [[UITextView alloc]init];
    self.textView.textColor = [UIColor clearColor];
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.backgroundColor = RGBA(225, 228, 233, 1);
    self.textView.delegate = self;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.height.mas_equalTo(134);
    }];
    
    [self.textView addSubview:self.placeHolder];
    [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textView);
        make.top.equalTo(self.textView.mas_top).offset(8);
    }];
    
    ////专辑封面模块
    self.albumcoverImageView = [[UIImageView alloc]init];
    self.albumcoverImageView.backgroundColor = RGBA(57, 60, 67, 0.06);
    self.albumcoverImageView.userInteractionEnabled = YES;
    self.albumcoverImageView.layer.cornerRadius = 5;
    self.albumcoverImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.albumcoverImageView];
    [self.albumcoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.textView.mas_bottom).offset(20);
        make.width.mas_offset(111);
        make.height.mas_equalTo(111);
    }];
    
    self.addCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addCoverButton setBackgroundImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_system_plus")] forState:UIControlStateNormal];
    [self.addCoverButton addTarget:self action:@selector(addcoverImageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.albumcoverImageView addSubview:self.addCoverButton];
    [self.addCoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.albumcoverImageView.mas_centerX);
        make.centerY.equalTo(self.albumcoverImageView.mas_centerY);
    }];
    
    ///设置选中后的视图操作界面
    self.selectedCoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    self.selectedCoverView.backgroundColor = RGBA(72, 90, 117, 1);
    
    ///设置圆角
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.selectedCoverView.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(16, 16)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];

    //设置大小
    maskLayer.frame = self.selectedCoverView.bounds;

    //设置图形样子
    maskLayer.path = maskPath.CGPath;

    self.selectedCoverView.layer.mask = maskLayer;
    [self.albumcoverImageView addSubview:self.selectedCoverView];
    [self.selectedCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.albumcoverImageView.mas_right);
        make.top.equalTo(self.albumcoverImageView.mas_top);
        make.height.width.mas_equalTo(32);
    }];
    
    
    ///删除封面按钮
    self.deleteCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteCoverButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_system_coverx")] forState:UIControlStateNormal];
    [self.deleteCoverButton addTarget:self action:@selector(deleteCoverButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.selectedCoverView addSubview:self.deleteCoverButton];
    [self.deleteCoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.selectedCoverView);
    }];
    
    self.selectedCoverView.hidden = YES;
    
    
    
    
    
    self.hintLabel = [[UILabel alloc]init];
    self.hintLabel.font = [UIFont systemFontOfSize:12];
    self.hintLabel.textColor = RGBA(57, 60, 67, 0.56);
    self.hintLabel.numberOfLines = 2;
    self.hintLabel.text = @"添加直播封面，封面尺寸000*000，上传非指定尺寸将等比居中显示~";
    [self.hintLabel sizeToFit];
    [self.contentView addSubview:self.hintLabel];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.top.equalTo(self.albumcoverImageView.mas_bottom).offset(8);
    }];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = RGBA(57, 60, 67, 0.08);
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hintLabel.mas_left);
        make.right.equalTo(self.hintLabel.mas_right);
        make.top.equalTo(self.hintLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(1);
    }];
    
    ///话题
    self.huatiView = [[UIView alloc]init];
    self.huatiView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.huatiView];
    [self.huatiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.lineView.mas_bottom).offset(12);
        make.height.mas_equalTo(56);
    }];
    
    self.huatiImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_bicolor_huati")]];
    [self.huatiView addSubview:self.huatiImageView];
    [self.huatiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.huatiView.mas_left).offset(16);
        make.centerY.equalTo(self.huatiView.mas_centerY);
        make.width.mas_equalTo(self.huatiImageView.image.size.width);
        make.height.mas_equalTo(self.huatiImageView.image.size.height);
    }];
    
    self.huatiLabel = [[UILabel alloc]init];
    self.huatiLabel.font = [UIFont boldSystemFontOfSize:14];
    self.huatiLabel.textAlignment = NSTextAlignmentLeft;
    self.huatiLabel.textColor = RGB(57, 60, 67);
    self.huatiLabel.text = @"选择话题";
    [self.huatiView addSubview:self.huatiLabel];
    [self.huatiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.huatiView);
        make.left.equalTo(self.huatiImageView.mas_right).offset(12);
        make.width.mas_equalTo(90);
    }];
    
    self.selecthuatiLabel = [[UILabel alloc]init];
    self.selecthuatiLabel.font = [UIFont systemFontOfSize:14];
    self.selecthuatiLabel.textAlignment = NSTextAlignmentRight;
    self.selecthuatiLabel.textColor = RGB(57, 60, 67);
    self.selecthuatiLabel.text = @"";
    [self.huatiView addSubview:self.selecthuatiLabel];
    [self.selecthuatiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.huatiView);
        make.right.equalTo(self.huatiView.mas_right).offset(-40);
        make.left.equalTo(self.huatiLabel.mas_right).offset(16);
    }];
    
    self.huatiarrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_system_arrowline_right")]];
    [self.huatiView addSubview:self.huatiarrowImageView];
    [self.huatiarrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.huatiView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];
    
    ///位置
    self.locationView = [[UIView alloc]init];
    self.locationView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.locationView];
    [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.huatiView.mas_bottom);
        make.height.mas_equalTo(56);
    }];
    
    self.locationImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_bicolor_location")]];
    [self.locationView addSubview:self.locationImageView];
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationView.mas_left).offset(16);
        make.centerY.equalTo(self.locationView.mas_centerY);
        make.width.mas_equalTo(self.locationImageView.image.size.width);
        make.width.mas_equalTo(self.locationImageView.image.size.height);
    }];
    
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.font = [UIFont boldSystemFontOfSize:14];
    self.locationLabel.textAlignment = NSTextAlignmentLeft;
    self.locationLabel.textColor = RGB(57, 60, 67);
    self.locationLabel.text = @"选择位置";
    [self.locationView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.locationView);
        make.left.equalTo(self.locationImageView.mas_right).offset(12);
        make.right.equalTo(self.locationView.mas_right).offset(-72);
    }];
    
    self.locationuseSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.locationuseSwitchButton setBackgroundImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_system_kaiguan_guan")]  forState:UIControlStateNormal];
    [self.locationuseSwitchButton setBackgroundImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_switch_on_bg")]  forState:UIControlStateSelected];
    [self.locationuseSwitchButton addTarget:self action:@selector(locationuseSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.locationView addSubview:self.locationuseSwitchButton];
    [self.locationuseSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.locationView.mas_right).offset(-16);
        make.centerY.equalTo(self.locationView.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(24);
    }];
    
    
    ///立即开始直播
    self.liveStartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.liveStartButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_unselected")] forState:UIControlStateNormal];
    [self.liveStartButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_selected")] forState:UIControlStateSelected];
    [self.liveStartButton setTitle:@"立即开始手机直播" forState:UIControlStateNormal];
    [self.liveStartButton setTitle:@"立即开始手机直播" forState:UIControlStateSelected];
    [self.liveStartButton setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateNormal];
    [self.liveStartButton setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateSelected];
    self.liveStartButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.liveStartButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    self.liveStartButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    self.liveStartButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [self.liveStartButton addTarget:self action:@selector(liveStartButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.liveStartButton];
    [self.liveStartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.locationView.mas_bottom).offset(16);
        make.width.mas_equalTo(160);
    }];

    
    ///设置直播预告
    self.livepreviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.livepreviewButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_unselected")] forState:UIControlStateNormal];
    [self.livepreviewButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_selected")] forState:UIControlStateSelected];
    [self.livepreviewButton setTitle:@"设置直播预告" forState:UIControlStateNormal];
    [self.livepreviewButton setTitle:@"设置直播预告" forState:UIControlStateSelected];
    [self.livepreviewButton setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateNormal];
    [self.livepreviewButton setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateSelected];
    self.livepreviewButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.livepreviewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    self.livepreviewButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    self.livepreviewButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [self.livepreviewButton addTarget:self action:@selector(livepreviewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.livepreviewButton];
    
    [self.livepreviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-60);
        make.top.equalTo(self.locationView.mas_bottom).offset(16);
        make.width.mas_equalTo(140);
    }];
    
    ///设置直播预告隐藏视图
    
    [self settingLivepreView];
    
    ///手机直播
    self.phoneliveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.phoneliveButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_unselected")] forState:UIControlStateNormal];
    [self.phoneliveButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_selected")] forState:UIControlStateSelected];
    [self.phoneliveButton setTitle:@"手机直播" forState:UIControlStateNormal];
    [self.phoneliveButton setTitle:@"手机直播" forState:UIControlStateSelected];
    [self.phoneliveButton setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateNormal];
    [self.phoneliveButton setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateSelected];
    self.phoneliveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.phoneliveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    self.phoneliveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    self.phoneliveButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [self.phoneliveButton addTarget:self action:@selector(phoneliveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.phoneliveButton];
    [self.phoneliveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo( self.livepreviewButton.mas_bottom).offset(32);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(24);
    }];

    
    self.hardwareliveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hardwareliveButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_unselected")] forState:UIControlStateNormal];
    [self.hardwareliveButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_selected")] forState:UIControlStateSelected];
    [self.hardwareliveButton setTitle:@"硬件直播" forState:UIControlStateNormal];
    [self.hardwareliveButton setTitle:@"硬件直播" forState:UIControlStateSelected];
    [self.hardwareliveButton setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateNormal];
    [self.hardwareliveButton setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateSelected];
    self.hardwareliveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.hardwareliveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    self.hardwareliveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    self.hardwareliveButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [self.hardwareliveButton addTarget:self action:@selector(hardwareliveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.hardwareliveButton];
    [self.hardwareliveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-60);
        make.top.equalTo(self.phoneliveButton.mas_top);
        make.width.mas_equalTo(140);
    }];

    
    [self settingHardwareliveView];
    
    
    self.formliveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.formliveButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_unselected")] forState:UIControlStateNormal];
    [self.formliveButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_selected")] forState:UIControlStateSelected];
    [self.formliveButton setTitle:@"使用表单功能" forState:UIControlStateNormal];
    [self.formliveButton setTitle:@"使用表单功能" forState:UIControlStateSelected];
    [self.formliveButton setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateNormal];
    [self.formliveButton setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateSelected];
    self.formliveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.formliveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    self.formliveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    self.formliveButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [self.formliveButton addTarget:self action:@selector(formliveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.formliveButton];
    [self.formliveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.hardwareliveButton.mas_bottom).offset(32);
        make.width.mas_equalTo(160);
    }];

    
    self.lotteryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lotteryButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_unselected")] forState:UIControlStateNormal];
    [self.lotteryButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_selected")] forState:UIControlStateSelected];
    [self.lotteryButton setTitle:@"使用抽奖功能" forState:UIControlStateNormal];
    [self.lotteryButton setTitle:@"使用抽奖功能" forState:UIControlStateSelected];
    [self.lotteryButton setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateNormal];
    [self.lotteryButton setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateSelected];
    self.lotteryButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.lotteryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    self.lotteryButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    self.lotteryButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [self.lotteryButton addTarget:self action:@selector(lotteryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.lotteryButton];
    [self.lotteryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.formliveButton.mas_bottom).offset(32);
        make.width.mas_equalTo(160);
    }];

    
    [self settingLotteryView];
    
    
    self.nextView = [[UIView alloc]init];
    self.nextView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.nextView];
    [self.nextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.lotteryButton.mas_bottom).offset(47);
        make.height.mas_equalTo(87);
    }];
    

    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setBackgroundColor:RGBA(0, 61, 227, 1)];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = 24;
    self.nextButton.layer.shadowColor = RGBA(0, 61, 227, 0.8).CGColor;
    self.nextButton.layer.shadowOffset = CGSizeMake(0,10);
    self.nextButton.layer.shadowOpacity = 1;
    self.nextButton.layer.shadowRadius = 10;
    [self.nextButton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextView addSubview:self.nextButton];

    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nextView.mas_top);
        make.left.equalTo(self.nextView.mas_left).offset(16);
        make.right.equalTo(self.nextView.mas_right).offset(-16);
        make.height.mas_equalTo(46);
    }];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nextView.mas_bottom);
    }];
    

    UITapGestureRecognizer *livepreViewGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(livepreViewGesClick)];
    [self.livepreView addGestureRecognizer:livepreViewGes];
    
    UITapGestureRecognizer *huatiViewGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huatiViewGesClick)];
    [self.huatiView addGestureRecognizer:huatiViewGes];

}
- (void)settingLivepreView {
    ///直播预告显示视图
    self.livepreView = [[UIView alloc]init];
    self.livepreView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.livepreView];
    [self.livepreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.livepreviewButton.mas_bottom).offset(16);
        make.height.mas_equalTo(56);
    }];
    
    self.livepreImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_bicolor_shijian")]];
    [self.livepreView addSubview:self.livepreImageView];
    [self.livepreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.livepreView.mas_left).offset(16);
        make.centerY.equalTo(self.livepreView.mas_centerY);
    }];
    
    self.livepreLabel = [[UILabel alloc]init];
    self.livepreLabel.font = [UIFont boldSystemFontOfSize:14];
    self.livepreLabel.textAlignment = NSTextAlignmentLeft;
    self.livepreLabel.textColor = RGB(57, 60, 67);
    self.livepreLabel.text = @"开始直播时间";
    [self.livepreView addSubview:self.livepreLabel];
    [self.livepreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.livepreView);
        make.left.equalTo(self.livepreImageView.mas_right).offset(12);
        make.width.mas_equalTo(90);
    }];
    
    self.selectlivepreLabel = [[UILabel alloc]init];
    self.selectlivepreLabel.font = [UIFont systemFontOfSize:14];
    self.selectlivepreLabel.textAlignment = NSTextAlignmentRight;
    self.selectlivepreLabel.textColor = RGB(57, 60, 67);
    self.selectlivepreLabel.text = @"";
    [self.livepreView addSubview:self.selectlivepreLabel];
    [self.selectlivepreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.livepreView);
        make.right.equalTo(self.livepreView.mas_right).offset(-40);
    }];
    
    self.liveprearrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_system_arrowline_right")]];
    [self.livepreView addSubview:self.liveprearrowImageView];
    [self.liveprearrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.livepreView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];
    
    [self.livepreView setHidden:YES];
}


- (void)settingHardwareliveView {
    ///硬件直播
    self.hardwareliveView = [[UIView alloc]init];
    self.hardwareliveView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.hardwareliveView];
    [self.hardwareliveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.hardwareliveButton.mas_bottom).offset(16);
        make.height.mas_equalTo(71);
    }];
    
    
    self.hardwareliveLabel = [[UILabel alloc]init];
    self.hardwareliveLabel.font = [UIFont boldSystemFontOfSize:14];
    self.hardwareliveLabel.textAlignment = NSTextAlignmentLeft;
    self.hardwareliveLabel.textColor = RGB(57, 60, 67);
    self.hardwareliveLabel.text = @"复制生成链接";
    [self.hardwareliveView addSubview:self.hardwareliveLabel];
    [self.hardwareliveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hardwareliveView.mas_top).offset(16);
        make.left.equalTo(self.hardwareliveView.mas_left).offset(16);
    }];
    
    self.hardwareliveurlLabel = [[UILabel alloc]init];
    self.hardwareliveurlLabel.font = [UIFont systemFontOfSize:14];
    self.hardwareliveurlLabel.textAlignment = NSTextAlignmentLeft;
    self.hardwareliveurlLabel.textColor = RGB(57, 60, 67);
    self.hardwareliveurlLabel.text = @"http://t.cn/A6Uoeoga";
    [self.hardwareliveView addSubview:self.hardwareliveurlLabel];
    [self.hardwareliveurlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hardwareliveLabel.mas_bottom).offset(2);
        make.left.equalTo(self.hardwareliveLabel.mas_left);
    }];
    
    
    self.replicateUrlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replicateUrlButton setTitle:@"点击复制" forState:UIControlStateNormal];
    [self.replicateUrlButton setTitleColor:RGBA(0, 61, 227, 1) forState:UIControlStateNormal];
    self.replicateUrlButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.replicateUrlButton addTarget:self action:@selector(replicateUrlButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.hardwareliveView addSubview:self.replicateUrlButton];
    [self.replicateUrlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hardwareliveLabel.mas_top);
        make.right.equalTo(self.hardwareliveView.mas_right).offset(-16);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.hardwareliveView setHidden:YES];
}

- (void)settingLotteryView {
    ///抽奖预加载视图
    self.lotteryView = [[UIView alloc]init];
    self.lotteryView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.lotteryView];
    [self.lotteryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.lotteryButton.mas_bottom).offset(16);
        make.height.mas_equalTo(44 + 31);
    }];
    
    self.lotteryTextField = [[UITextField alloc]init];
    self.lotteryTextField.placeholder = @"添加活动ID";
    self.lotteryTextField.font = [UIFont systemFontOfSize:14];
    self.lotteryTextField.borderStyle = UITextBorderStyleNone;
    self.lotteryTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.lotteryView addSubview:self.lotteryTextField];
    [self.lotteryTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lotteryView.mas_left).offset(52);
        make.top.equalTo(self.lotteryView.mas_top);
        make.height.mas_equalTo(44);
        make.right.equalTo(self.lotteryView.mas_right).offset(-16);
    }];
    
    
    self.lotterylineView = [[UIView alloc]init];
    self.lotterylineView.backgroundColor =  RGBA(57, 60, 67, 0.08);
    [self.lotteryView addSubview:self.lotterylineView];
    [self.lotterylineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lotteryTextField.mas_left);
        make.right.equalTo(self.lotteryView.mas_right);
        make.bottom.equalTo(self.lotteryTextField.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.lotteryView setHidden:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}


#pragma mark - customfunc
- (void)livepreViewGesClick {
    if ([self.delegate respondsToSelector:@selector(liveReleaseViewDidClicklivepreViewGes)]) {
        [self.delegate liveReleaseViewDidClicklivepreViewGes];
    }
}
- (void)addcoverImageAction
{
    if ([self.delegate respondsToSelector:@selector(liveReleaseViewDidClickAddcoverImage)]) {
        [self.delegate liveReleaseViewDidClickAddcoverImage];
    }
    
}

- (void)locationuseSwitchAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        self.locationLabel.text = @"选择位置";
    }
    
    if ([self.delegate respondsToSelector:@selector(liveReleaseViewDidClickisUselocation:)]) {
        [self.delegate liveReleaseViewDidClickisUselocation:sender];
    }
}

- (void)liveStartButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.livepreviewButton.selected = NO;
        if (!self.livepreView.isHidden) {
            [self.livepreView setHidden:YES];
            [self.phoneliveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(16);
                make.top.equalTo( self.livepreviewButton.mas_bottom).offset(32);
                make.width.mas_equalTo(160);
            }];
        }
    }else{
        sender.selected = YES;
    }
    
}
- (void)livepreviewButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {///重新布局
        self.liveStartButton.selected = NO;
        [self.livepreView setHidden:NO];
        [self.phoneliveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(16);
            make.top.equalTo( self.livepreView.mas_bottom).offset(16);
            make.width.mas_equalTo(160);
        }];

    }else{
        self.liveStartButton.selected = YES;
        [self.livepreView setHidden:YES];
        [self.phoneliveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(16);
            make.top.equalTo( self.livepreviewButton.mas_bottom).offset(32);
            make.width.mas_equalTo(160);
        }];

    }
 
    [self layoutIfNeeded];

}

- (void)phoneliveButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.hardwareliveButton.selected = NO;
        if (!self.hardwareliveView.isHidden) {
            [self.hardwareliveView setHidden:YES];
            [self.formliveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(16);
                make.top.equalTo(self.hardwareliveButton.mas_bottom).offset(32);
                make.width.mas_equalTo(160);
            }];
        }

    }else{
        sender.selected = YES;
    }
    
}
- (void)formliveButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)hardwareliveButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {///重新布局
        self.phoneliveButton.selected = NO;
//        [self.hardwareliveView setHidden:NO];
//        [self.formliveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).offset(16);
//            make.top.equalTo(self.hardwareliveView.mas_bottom).offset(16);
//            make.width.mas_equalTo(160);
//        }];

    }else{
        self.phoneliveButton.selected = YES;
//        [self.hardwareliveView setHidden:YES];
//        [self.formliveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).offset(16);
//            make.top.equalTo(self.hardwareliveButton.mas_bottom).offset(32);
//            make.width.mas_equalTo(160);
//        }];

    }
 
//    [self layoutIfNeeded];
}

- (void)lotteryButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {///重新布局
        [self.lotteryView setHidden:NO];
        [self.nextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.lotteryView.mas_bottom);
            make.height.mas_equalTo(87);
        }];

    }else{
        [self.lotteryView setHidden:YES];
        [self.nextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.lotteryButton.mas_bottom).offset(47);
            make.height.mas_equalTo(87);
        }];

    }
 
    [self layoutIfNeeded];
}

- (void)nextClick:(UIButton *)sender {
    if (self.selectImage == nil) {
        return [SVProgressHUD showErrorWithStatus:@"请选择背景图"];
    }
    
    if (self.liveStartButton.selected == NO && self.livepreviewButton.selected == NO) {
        return [SVProgressHUD showErrorWithStatus:@"请选择直播时间"];
    }
    
    if (self.livepreviewButton.selected == YES && self.livePrewTimeString.length<1) {
        return [SVProgressHUD showErrorWithStatus:@"请选择直播预告时间"];
    }
    
    if (self.phoneliveButton.selected == NO && self.hardwareliveButton.selected == NO) {
        return [SVProgressHUD showErrorWithStatus:@"请选择直播方式"];
    }
    
    if (self.textView.text.length <= 0) {
        return [SVProgressHUD showErrorWithStatus:@"请输入直播标题"];
    }
    
    
    if (self.lotteryButton.selected == YES && self.lotteryTextField.text.length <= 0) {
        return [SVProgressHUD showErrorWithStatus:@"请输入活动ID"];
    }
    
    if ([self.delegate respondsToSelector:@selector(liveReleaseViewDidClickNextButtonTitle:livePrewTimeString:liveType:useForm:activityId:)]) {
        [self.delegate liveReleaseViewDidClickNextButtonTitle:self.textView.text livePrewTimeString:self.livePrewTimeString liveType:self.phoneliveButton.selected ? @(2) : @(1) useForm:self.formliveButton.selected ? @(1):@(0)  activityId:self.lotteryTextField.text];
    }
}

- (void)replicateUrlButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(liveReleaseViewDidClickCopyUrl:)]) {
        [self.delegate liveReleaseViewDidClickCopyUrl:self.hardwareliveurlLabel.text];
    }
}

- (void)deleteCoverButtonClick {
    self.albumcoverImageView.image = nil;
    self.addCoverButton.hidden = NO;
    self.selectedCoverView.hidden = YES;
}
- (void)huatiViewGesClick {
    if ([self.delegate respondsToSelector:@selector(liveReleaseViewDidClickhuatiViewGes)]) {
        [self.delegate liveReleaseViewDidClickhuatiViewGes];
    }
}
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeHolder.alpha = 0;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.text.length) {
        self.placeHolder.alpha = 1;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (!textView.text.length) {
        self.placeHolder.alpha = 1;
    } else {
        self.placeHolder.alpha = 0;
    }
    
    if (textView.markedTextRange == nil && textView.text.length + self.selecthuatiLabel.text.length  > 30) {
//        NSLog(@"ooo=%lu",30 - self.slecthuati.text.length);
//        if (30 - self.slecthuati.text.length > 0) {
            textView.text = [textView.text substringToIndex:30 - self.selecthuatiLabel.text.length];
//        }
        
    }
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
#pragma mark - 懒加载
- (UILabel *)placeHolder {
    if (!_placeHolder) {
        _placeHolder = [[UILabel alloc]init];
        _placeHolder.text = @"您可以在此设置合适的标题以及话题，让更多人看到...";
        _placeHolder.numberOfLines = 0;
        _placeHolder.font = [UIFont systemFontOfSize:14];
        _placeHolder.textColor = RGBA(57, 60, 67, 0.32);
    }
    return _placeHolder;
}


#pragma mark - setter
- (void)setLivePrewTimeString:(NSString *)livePrewTimeString {
    _livePrewTimeString = livePrewTimeString;
    self.selectlivepreLabel.text = livePrewTimeString;
}

- (void)setLocationStr:(NSString *)locationStr {
    _locationStr = locationStr;
    self.locationLabel.text = locationStr;
}
- (void)setSelectImage:(UIImage *)selectImage {
    _selectImage = selectImage;
    self.selectedCoverView.hidden = NO;
    self.addCoverButton.hidden = YES;
    self.albumcoverImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.albumcoverImageView.image = selectImage;
}
- (void)setSelectedHuatiText:(NSString *)selectedHuatiText {
    _selectedHuatiText = selectedHuatiText;
    self.selecthuatiLabel.text = selectedHuatiText;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
