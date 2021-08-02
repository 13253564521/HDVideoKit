//
//  HDMineHeaderView.m
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/5.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDMineHeaderView.h"
#import "HDCusTomSlelectView.h"
#import "Macro.h"
#import "HDServicesManager.h"
#import "YYWebImage.h"
#import "HDUkeInfoCenter.h"
@interface HDCusTomTextView : UIView
@property(nonatomic , strong) UILabel *titleLabel;
@property(nonatomic , strong) UILabel *countLabel;
@end

@implementation HDCusTomTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCusTomTextView];
    }
    return self;
}


- (void)initCusTomTextView {
    self.titleLabel = [[UILabel  alloc]init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.font = [UIFont systemFontOfSize:15];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.countLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, 10);
    self.countLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 13, self.frame.size.width, 10);
    
}



@end

@interface HDMineHeaderView()
@property(nonatomic , strong)UIView *backGroundView;
@property(nonatomic , strong)UIImageView *iconImageView;
@property(nonatomic , strong)UILabel *namelabel;
@property(nonatomic , strong)UILabel *phonelabel;
@property(nonatomic , strong)UIButton *modifynameButton;

@property(nonatomic , strong)HDCusTomTextView *fabulousView;
@property(nonatomic , strong)HDCusTomTextView *foucsView;
@property(nonatomic , strong)HDCusTomTextView *fansView;
@property(nonatomic , strong)UIView *lineView1;
@property(nonatomic , strong)UIView *lineView2;




@end
@implementation HDMineHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.backGroundView = [[UIView alloc]initWithFrame:self.bounds];
    self.backGroundView.backgroundColor = RGBA(116, 156, 255, 1);
    [self addSubview:self.backGroundView];
    
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.image = [UIImage imageNamed:HDBundleImage(@"testIcon")];
    [self addSubview:self.iconImageView];
    
    self.namelabel = [[UILabel alloc]init];
    self.namelabel.textColor = [UIColor whiteColor];
    self.namelabel.font  = [UIFont systemFontOfSize:18];
    self.namelabel.text = @"0";
    [self addSubview:self.namelabel];
    
    self.phonelabel = [[UILabel alloc]init];
    self.phonelabel.textColor = [UIColor whiteColor];
    self.phonelabel.font = [UIFont systemFontOfSize:12];
//    self.phonelabel.text = @"17717898569";
    [self addSubview:self.phonelabel];
    

    self.modifynameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.modifynameButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.modifynameButton addTarget:self  action:@selector(modifynameButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.modifynameButton];
    
    
    self.fabulousView = [[HDCusTomTextView alloc]init];
    self.fabulousView.titleLabel.text = @"获赞";
    self.fabulousView.countLabel.text = @"0";
    [self addSubview:self.fabulousView];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [self.fabulousView addGestureRecognizer:tapGesture];
    
    self.foucsView = [[HDCusTomTextView alloc]init];
    self.foucsView.titleLabel.text = @"关注";
    self.foucsView.countLabel.text = @"0";
    [self addSubview:self.foucsView];
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event1:)];
    [self.foucsView addGestureRecognizer:tapGesture1];
    
    self.fansView = [[HDCusTomTextView alloc]init];
    self.fansView.titleLabel.text = @"粉丝";
    self.fansView.countLabel.text = @"0";
    [self addSubview:self.fansView];
    UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event2:)];
    [self.fansView addGestureRecognizer:tapGesture2];
    
    self.lineView1 = [[UIView alloc]init];
    self.lineView1.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.lineView1];
    self.lineView2 = [[UIView alloc]init];
    self.lineView2.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.lineView2];
    
    if (self.userID) {
        self.selectView = [HDCusTomSlelectView initializeWithNames:@[@"视频",@"喜欢",@"直播"]];
    }else {
        if ( [HDUkeInfoCenter sharedCenter].userModel.liveVideo == 1) {
            self.selectView = [HDCusTomSlelectView initializeWithNames:@[@"视频",@"喜欢",@"直播"]];
            
        }else {
            self.selectView = [HDCusTomSlelectView initializeWithNames:@[@"视频",@"喜欢"]];
        }
    }
   
    [self addSubview:self.selectView];
    
    UIButton *leftBUtton = [[UIButton alloc]initWithFrame:CGRectMake(20, GS_StatusBarHeight, 30, 30)];
    [leftBUtton setImage:[UIImage imageNamed:HDBundleImage(@"video/btn_back")] forState:0];
    [leftBUtton addTarget:self action:@selector(leftdidbutton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBUtton];
}

-(void)leftdidbutton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftpopView" object:self userInfo:nil];
}

-(void)event:(UITapGestureRecognizer *)gesture
{
    [self.delegate hd_UserzanDidButton];
}

-(void)event1:(UITapGestureRecognizer *)gesture
{
    [self.delegate hd_UserguanzhuDidButton];
}

-(void)event2:(UITapGestureRecognizer *)gesture
{
    [self.delegate hd_UserfenxiDidButton];
}

-(void)setModel:(HDHDMyModel *)model {
    _model = model;

    self.namelabel.text = model.nickName;
    
    self.fabulousView.countLabel.text = [self stringToInt:model.likeCount];
    self.foucsView.countLabel.text = [self stringToInt:model.followCount];
    self.fansView.countLabel.text =[self stringToInt:model.fanCount];
    
   NSString *withStr = @"*****";
   NSInteger fromIndex = 3;
   NSRange range = NSMakeRange(fromIndex,  withStr.length);
    if (model.username.length >10) {
        NSString *phoneNumber = [model.username stringByReplacingCharactersInRange:range  withString:withStr];
        self.phonelabel.text = phoneNumber;
    }else {
        self.phonelabel.text = @"****";
    }
    
    if (self.userID) {
        
        
        if ([model.state intValue] == 8 || [model.state intValue] == 7) {
            [self.modifynameButton setTitle:@"已关注" forState:UIControlStateNormal];

        }else {
            [self.modifynameButton setTitle:@"关注" forState:UIControlStateNormal];

        }
          [self.modifynameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
          [self.modifynameButton setBackgroundColor:UkeColorHex(0xFF8C06)];
    }else {
        [self.modifynameButton setTitle:@"修改昵称" forState:UIControlStateNormal];
        [self.modifynameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.modifynameButton setBackgroundColor:[UIColor whiteColor]];
        self.modifynameButton.alpha = 0.6;

    }
    
    [HDServicesManager getusertouaxiangCouponDataWithResulblock:model.uuid black:^(BOOL isSuccess, NSString * _Nullable alertString) {
        
    } ];
    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat iconLeftM = 30;
    CGFloat iconW = 50;
    
    CGFloat nameMagin = 10;
    CGFloat nameH = iconW / 2;
    CGFloat nameW = 150;
    
    
    self.iconImageView.frame = CGRectMake(iconLeftM, GS_StatusBarHeight + 54, iconW, iconW);
    self.namelabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + nameMagin, self.iconImageView.frame.origin.y, nameW, nameH);
    self.phonelabel.frame = CGRectMake(self.namelabel.frame.origin.x, CGRectGetMaxY(self.namelabel.frame), nameW, nameH);
    
    CGFloat modifyR = 20;
    CGFloat modifyW = 80;
    CGFloat modifyH = 24;
    self.modifynameButton.frame = CGRectMake(self.frame.size.width - modifyR - modifyW,self.iconImageView.frame.origin.y +  (self.iconImageView.frame.size.height - modifyH) * 0.5, modifyW, modifyH);
    
    
    
    
    self.modifynameButton.layer.mask = [self circleMaskLayerWithView:self.modifynameButton byRoundingCorners:UIRectCornerAllCorners radius:12];
    self.iconImageView.layer.mask = [self circleMaskLayerWithView:self.iconImageView byRoundingCorners:UIRectCornerAllCorners radius:4];
    self.backGroundView.layer.mask = [self circleMaskLayerWithView:self.backGroundView byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight  radius:20];
    
    CGFloat customViewW = 100;
    CGFloat customViewH = 40;
    CGFloat customViewM = 20;
    
    self.foucsView.frame = CGRectMake(self.center.x - customViewW * 0.5, CGRectGetMaxY(self.iconImageView.frame)  + customViewM, customViewW, customViewH);
    self.fansView.frame = CGRectMake(CGRectGetMaxX(self.foucsView.frame) + 0.5, self.foucsView.frame.origin.y, customViewW, customViewH);
    self.fabulousView.frame = CGRectMake(self.foucsView.frame.origin.x - customViewW - 0.5, self.foucsView.frame.origin.y, customViewW, customViewH);
    
    self.lineView1.frame = CGRectMake(self.foucsView.frame.origin.x - 0.5, self.foucsView.frame.origin.y, 0.5, customViewH);
    self.lineView2.frame = CGRectMake(self.fansView.frame.origin.x - 0.5 , self.foucsView.frame.origin.y, 0.5, customViewH);
    
    CGFloat selectViewL = 20;
    CGFloat selectViewH = 50;
    
    self.selectView.frame = CGRectMake(selectViewL, self.frame.size.height - selectViewH, self.frame.size.width - selectViewL * 2, selectViewH);
    
}


#pragma mark - buttonClick
- (void)modifynameButtonAction {
    
    if (self.userID) {
        if ([self.model.state intValue] == 0) {
            [HDServicesManager getuserguanzhuCouponDataWithResulblock:self.userID black:^(BOOL isSuccess, NSString * _Nullable alertString) {
                self.model.state = [NSNumber numberWithInt:7];
                [self.modifynameButton setTitle:@"已关注" forState:UIControlStateNormal];

            }];
        }else if ([self.model.state intValue] == 8 || [self.model.state intValue] == 7) {
            [HDServicesManager getuserquxiaoguanzhuCouponDataWithResulblock:self.userID black:^(BOOL isSuccess, NSString * _Nullable alertString) {
                self.model.state = [NSNumber numberWithInt:0];
                [self.modifynameButton setTitle:@"关注" forState:UIControlStateNormal];
            }];
        }
        
    }else {
        if ([self.delegate respondsToSelector:@selector(hd_mineHeaderViewDidClickModifName)]) {
            [self.delegate hd_mineHeaderViewDidClickModifName];
        }
    }
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
@end
