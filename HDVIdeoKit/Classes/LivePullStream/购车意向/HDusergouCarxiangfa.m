//
//  HDusergouCarxiangfa.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/8.
//

#import "HDusergouCarxiangfa.h"
#import "Macro.h"
#import "HDUkeInfoCenter.h"
#import "HDServicesManager.h"
#import "HDusergouCarxiangfaModel.h"
#import "UKNetworkHelper.h"

#import "HDCustomMyPickerViewController.h"
#import "HDCityPikerViewController.h"
#import "HDDealerModel.h"
#import "HDCityBuyCarModel.h"


@interface HDusergouCarxiangfa()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *iphone;
@property (weak, nonatomic) IBOutlet UIButton *close;
@property (weak, nonatomic) IBOutlet UIButton *time;
@property (weak, nonatomic) IBOutlet UIButton *time1;
@property (weak, nonatomic) IBOutlet UIButton *time2;

@property (strong, nonatomic)NSString *provincecode;
@property (strong, nonatomic)NSString *citycode;


@property (strong, nonatomic)NSString *yixianggouche;//意向车型
@property (strong, nonatomic)NSString *gouchedidian;//购车地点
@property (strong, nonatomic)NSString *jiinxiaoshang;//经销商

@property (strong, nonatomic)NSString *model;//意向车型
@property (strong, nonatomic)NSString *kind;//品系

@property (weak, nonatomic) IBOutlet UILabel *goucardiqulabel;
@property (weak, nonatomic) IBOutlet UILabel *yixianggouchelabel;
@property (weak, nonatomic) IBOutlet UILabel *jingxiaoshanglabel;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

///购车意向view
@property (weak, nonatomic) IBOutlet UIView *goucheyixiangView;
///购车地点view
@property (weak, nonatomic) IBOutlet UIView *gochedidianView;
///经销商View
@property (weak, nonatomic) IBOutlet UIView *jingxiaoshangView;
///购车意向label
@property (weak, nonatomic) IBOutlet UILabel *goucheyixiangLabel;
///购车地点label
@property (weak, nonatomic) IBOutlet UILabel *gouchedidianLabel;
///经销商Label
@property (weak, nonatomic) IBOutlet UILabel *jingxiaoshangLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView2;




@end

@implementation HDusergouCarxiangfa

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat radius = 15; // 圆角大小
    UIRectCorner corner = UIRectCornerTopLeft|UIRectCornerTopRight; // 圆角位置，全部位置
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = path.CGPath;
    self.contentView.layer.mask = maskLayer;
    
    [self.time setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_unselected")] forState:0];
    [self.time setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_selected")] forState:UIControlStateSelected];
    self.time.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    
    
    [self.time1 setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_unselected")] forState:0];
    [self.time1 setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_selected")] forState:UIControlStateSelected];
    self.time1.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    
    [self.time2 setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_unselected")] forState:0];
    [self.time2 setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_selected")] forState:UIControlStateSelected];
    self.time2.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    
    [self.close setImage:[UIImage imageNamed:HDBundleImage(@"video/btn_x")] forState:0];
    
    self.arrowImageView.image = [UIImage imageNamed:HDBundleImage(@"paishe/icon_system_arrowline_right")];
    self.arrowImageView1.image = [UIImage imageNamed:HDBundleImage(@"paishe/icon_system_arrowline_right")];
    self.arrowImageView2.image = [UIImage imageNamed:HDBundleImage(@"paishe/icon_system_arrowline_right")];

    /**

    __weak typeof(self) weakSelf = self;

    HDUIPickerView *view1 = [[HDUIPickerView alloc]initWithFrame:CGRectZero];
    view1.changeBlock = ^(NSDictionary * _Nullable city, NSDictionary * _Nullable area) {
        
        if ([weakSelf.provincecode isEqualToString:city[@"code"]] && [weakSelf.citycode isEqualToString:area[@"code"]]) {
            return;
        }
        weakSelf.provincecode = city[@"code"];
        weakSelf.citycode = area[@"code"];
        
        self.gouchedidian = [NSString stringWithFormat:@"%@ %@", city[@"name"], area[@"name"]];
        [weakSelf diquxuanze];
    };
    [self addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goucardiqulabel.mas_right).offset(20);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.goucardiqulabel);
        make.height.mas_equalTo(70);
    }];
    
    
    HDUIPickerView1 *view2 = [[HDUIPickerView1 alloc]initWithFrame:CGRectZero];
    view2.changeBlock = ^(NSString * _Nullable city, NSString * _Nullable area) {
        
        weakSelf.model = city;
        weakSelf.kind = area;
    };

    [self addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.yixianggouchelabel.mas_right).offset(20);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.yixianggouchelabel);
        make.height.mas_equalTo(70);
    }];
    
    self.view3 = [[HDUIPickerView2 alloc]initWithFrame:CGRectZero];
    self.view3.changeBlock = ^(NSString * _Nullable city, NSString * _Nullable area) {
        weakSelf.jiinxiaoshang = area;
    };
    [self addSubview:self.view3];
    [self.view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.jingxiaoshanglabel.mas_right).offset(20);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.jingxiaoshanglabel);
        make.height.mas_equalTo(70);
    }];
     */
    
    ///添加事件
    UITapGestureRecognizer *yixiangGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yixiangGesClick)];
    [self.goucheyixiangView addGestureRecognizer:yixiangGes];
    
    UITapGestureRecognizer *gochedidianGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gochedidianGesClick)];
    [self.gochedidianView addGestureRecognizer:gochedidianGes];
    
    UITapGestureRecognizer *jinxiaoshangGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jinxiaoshangGesClick)];
    [self.jingxiaoshangView addGestureRecognizer:jinxiaoshangGes];
}

-(void)setTitlealpath:(CGFloat)titlealpath {
    _titlealpath = titlealpath;
    self.hintLabel.alpha = titlealpath;
}


#pragma mark - buttonClick
- (void)yixiangGesClick {
    NSArray *provinceArray = @[];
    NSArray *usedArray = @[];
    if ([HDUkeInfoCenter sharedCenter].configurationModel.carSource == 1) {
        provinceArray = @[@"天V",@"JH6",@"安捷",@"虎V",@"虎VH",@"龙V",@"悍V",@"龙VH",@"J6F",@"金陆",@"麟V",@"JK6"];
        usedArray = @[@"牵引",@"载货",@"自卸",@"专用"];
    }else {
        provinceArray = @[@"J7",@"J6P",@"J6M",@"J6L"];
        usedArray = @[@"牵引",@"载货",@"自卸",@"专用"];
    }
    
    HDCustomMyPickerViewController *vc = [[HDCustomMyPickerViewController alloc]initWithTitle:@"意向车型" leftDataArray:provinceArray rightData:usedArray componenttitle:@"车型" dataArraytitle:@"用途"];
    [self.superVc presentViewController:vc animated:NO completion:nil];
    
    @WeakObj(self);
    vc.getPickerValue = ^(NSString * _Nonnull compoentString, NSString * _Nonnull titileString) {
        selfWeak.yixianggouche = [NSString stringWithFormat:@"%@-%@", compoentString, titileString];
        selfWeak.goucheyixiangLabel.text = [NSString stringWithFormat:@"%@ %@", compoentString, titileString];
        selfWeak.model = compoentString;
        selfWeak.kind = titileString;
    };
    
}
- (void)gochedidianGesClick {
    HDCityPikerViewController *cityVc = [[HDCityPikerViewController alloc]initWithTitle:@"购车地点"];
    [self.superVc presentViewController:cityVc animated:cityVc completion:nil];
    @WeakObj(self);
    cityVc.getPickerValue = ^(HDCityBuyCarModel * _Nonnull province, HDCityBuyCarModel * _Nonnull city) {
        selfWeak.provincecode = province.cityID;
        selfWeak.citycode = city.cityID;
        if (selfWeak.citycode == NULL) {
            selfWeak.gouchedidian = [NSString stringWithFormat:@"%@", province.name];
            selfWeak.gouchedidianLabel.text = [NSString stringWithFormat:@"%@", province.name];
        }else{
            selfWeak.gouchedidian = [NSString stringWithFormat:@"%@ %@", province.name, city.name];
            selfWeak.gouchedidianLabel.text = [NSString stringWithFormat:@"%@ %@", province.name, city.name];
        }
    };

}
- (void)jinxiaoshangGesClick {
    [self diquxuanze];
}
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)time:(UIButton *)sender {
    self.time1.selected = NO;
    self.time.selected = NO;
    self.time2.selected = NO;
    
    sender.selected = YES;
}
- (IBAction)tijiao:(UIButton *)sender {
    if (self.name.text.length <= 0) {
        return [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
    }

    if (self.iphone.text.length <= 0) {
        return [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
    }

    if ([self PhoneNumberMobile:self.iphone.text] == NO) {
        return [SVProgressHUD showErrorWithStatus:@"请输入正确手机号"];
    }

    if (self.time.selected == NO && self.time1.selected == NO && self.time2.selected == NO) {
        return [SVProgressHUD showErrorWithStatus:@"请选择时间"];
    }

    if (self.yixianggouche.length == 0) {
        return [SVProgressHUD showErrorWithStatus:@"请选择车型"];
    }

    if (self.gouchedidian.length <= 0) {
        return [SVProgressHUD showErrorWithStatus:@"请选择地区"];
    }

    if (self.jiinxiaoshang.length <= 0) {
        return [SVProgressHUD showErrorWithStatus:@"请选择经销商"];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"name"] = self.name.text;
    dic[@"tel"] = self.iphone.text;
    if (self.time.selected == YES) {
        dic[@"ownTime"] = @"一个月内";
    }else if (self.time1.selected == YES) {
        dic[@"ownTime"] = @"3个月内";
    }else if (self.time2.selected == YES) {
        dic[@"ownTime"] = @"3个月以上";
    }
    
    dic[@"model"] = self.model;
    dic[@"address"] = self.gouchedidian;
    dic[@"dealer"] = self.jiinxiaoshang;
    dic[@"kind"] = self.kind;
    NSLog(@"self.jiinxiaoshang;==%@",dic);
    [SVProgressHUD show];
    [HDServicesManager getzhibodiaodanDataWithResulprovinceId:self.uuid dic:dic block:^(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString) {
        [SVProgressHUD dismiss];
        if (isSuccess == YES) {
            !self.Handler ?: self.Handler();

            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self removeFromSuperview];
        }else {
            [SVProgressHUD showErrorWithStatus:@"接口失败"];
        }
        
        
    }];
}

-(BOOL)PhoneNumberMobile:(NSString *)mobile{
    if (mobile.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,152,155,156,170,171,176,185,186
     * 电信号段: 133,134,153,170,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[01678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,152,155,156,170,171,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[256]|7[016]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,134,153,170,177,180,181,189
     */
    NSString *CT = @"^1(3[34]|53|7[07]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobile] == YES)
        || ([regextestcm evaluateWithObject:mobile] == YES)
        || ([regextestct evaluateWithObject:mobile] == YES)
        || ([regextestcu evaluateWithObject:mobile] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


-(void)diquxuanze {
    if (self.provincecode.length <= 0) {
        return [SVProgressHUD showErrorWithStatus:@"请选择地区"];
    }
    [SVProgressHUD show];
    @WeakObj(self);
    [HDServicesManager getjingxiaoshangDataWithResulprovinceId:self.provincecode block:^(BOOL isSuccess, NSArray * _Nonnull dataArray, NSString * _Nonnull alertStr) {
        [SVProgressHUD dismiss];
        if (isSuccess) {
            NSMutableArray *dealerNameArray = [NSMutableArray array];
            for (HDDealerModel *model in dataArray) {
                [dealerNameArray addObject:model.dealerName];
            }
            HDCustomMyPickerViewController *vc = [[HDCustomMyPickerViewController alloc]initWithTitle:@"经销商" leftDataArray:dealerNameArray rightData:@[] componenttitle:@"" dataArraytitle:@""];
            [selfWeak.superVc presentViewController:vc animated:NO completion:nil];


            vc.getPickerValue = ^(NSString * _Nonnull compoentString, NSString * _Nonnull titileString) {
                selfWeak.jiinxiaoshang = compoentString;
                selfWeak.jingxiaoshangLabel.text = compoentString;
            };
        }else{
            [SVProgressHUD showErrorWithStatus:@"经销商获取失败!"];
        }
    
        
    }];
}
@end
