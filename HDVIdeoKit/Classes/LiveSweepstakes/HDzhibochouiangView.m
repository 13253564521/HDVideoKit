//
//  HDzhibochouiangView.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/1.
//

#import "HDzhibochouiangView.h"
#import "Macro.h"
#import "UKNetworkHelper.h"
#import "HDactivityRulesView.h"
#import "HDLotterySuccessView.h"


@interface HDzhibochouiangView()<HDLotterySuccessViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentbgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *disMiassBtn;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *chouBtn;

@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UIImageView *erroImageView;
@property (strong, nonatomic)  HDLotterySuccessView *successView;



@property (strong, nonatomic)NSString *prizeUuid;
@property (weak, nonatomic) IBOutlet UIButton *huodongbutton;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic)NSDictionary *dicData;
@property (assign, nonatomic)BOOL isNetwork;
///主标题
@property (weak, nonatomic) IBOutlet UILabel *maintitle;

@end

@implementation HDzhibochouiangView
#pragma mark - 懒加载
- (HDLotterySuccessView *)successView {
    if (!_successView) {
        _successView = [[HDLotterySuccessView alloc]initWithFrame:self.bounds];
        _successView.delegate = self;
    }
    return _successView;
}


-(void)awakeFromNib {
    [super awakeFromNib];
    
//    self.layer.cornerRadius = 15;
//    self.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 15;
    self.backView.layer.masksToBounds = YES;
    self.backView.backgroundColor = [UIColor clearColor];
    self.contentbgView.layer.cornerRadius = 15;
    self.contentbgView.layer.masksToBounds = YES;
    self.contentbgView.backgroundColor = RGBA(222, 225, 231, 1);
    
    self.errorView.layer.cornerRadius = 15;
    self.errorView.layer.masksToBounds = YES;
    self.errorView.backgroundColor = RGBA(222, 225, 231, 1);
    self.selectIndex = 1;
    for (UIButton *btn in self.chouBtn) {
        [btn setImage:[UIImage imageNamed:HDBundleImage(@"video/icon_box")] forState:0];
    }
    [self.huodongbutton setImage:[UIImage imageNamed:HDBundleImage(@"video/icon_zhibo_choujiang_jiantou2")] forState:0];
    // 取出 titleLabel 的宽度
    CGFloat labelWidth_huodong = self.huodongbutton.titleLabel.bounds.size.width;
    // 取出 imageView 的宽度
    CGFloat imageWidth_huodong = self.huodongbutton.imageView.bounds.size.width;
    // 设置 titleLabel 的内边距
    self.huodongbutton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth_huodong, 0, imageWidth_huodong);
    // 设置 imageView 的内边距
    self.huodongbutton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth_huodong, 0, -labelWidth_huodong);
    [self.disMiassBtn setImage:[UIImage imageNamed:HDBundleImage(@"video/btn_x")] forState:0];
    self.imageView.image = [UIImage imageNamed:HDBundleImage(@"video/img_head")];
    self.erroImageView.image = [UIImage imageNamed:HDBundleImage(@"video/img_choujiang_weizhongjiang")];
    

//    self.succerView.hidden = NO;
//    self.maintitle.text = @"恭喜您";
//    self.titlelabel.text = [NSString stringWithFormat:@"获得”%@“一辆",@"汽车模型"];
//    [self.image1 setImage:[UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];

    
   
}

-(void)setModel:(HDzhiboModel *)model {
    _model = model;
    
    [UKNetworkHelper GET:[NSString stringWithFormat:@"/activities/%@",self.model.prizeActivity] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            self.dicData = response[@"data"];
            self.namelabel.text = response[@"data"][@"name"];
        }
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (IBAction)dismmBtn:(id)sender {
    
//    if (self.errorView.hidden == NO) {
//        self.errorView.hidden = YES;
//    }else {
        [self removeFromSuperview];
//    }
   
}

- (IBAction)didBtn:(UIButton *)sender {
    
    if (self.isNetwork == YES) {
        return;
    }
    if ([self.model.useForm isEqualToString:@"1"]) {
        if (self.selectIndex >=2 ) {
            return [SVProgressHUD showErrorWithStatus:@"抽奖机会已用完等待下一次抽奖"];
        }
    }else {
        if (self.selectIndex >=2) {
            return [SVProgressHUD showErrorWithStatus:@"抽奖机会已用完等待下一次抽奖"];
        }
    }
    
    self.isNetwork = YES;
    [SVProgressHUD show];
    @WeakObj(self);
    [UKNetworkHelper POST:[NSString stringWithFormat:@"/live/videos/%@/prize",self.model.uuid] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        selfWeak.isNetwork = NO;
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            NSLog(@"%@",response[@"data"]);
            
            selfWeak.prizeUuid = response[@"data"][@"uuid"];
            if (selfWeak.prizeUuid.length > 0) {
                if (!selfWeak.successView.superview) {
                    [selfWeak addSubview:selfWeak.successView];
                }
                
                selfWeak.successView.lotteryInfo = response[@"data"][@"title"];
                selfWeak.successView.lotteryImageUrlStr = response[@"data"][@"photoUrl"];

            }else {
                selfWeak.maintitle.text = @"很遗憾";
                selfWeak.errorView.hidden = NO;
            }
            selfWeak.selectIndex = self.selectIndex + 1;
            !selfWeak.Handler ?: selfWeak.Handler();
        }
        [SVProgressHUD dismiss];
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        selfWeak.isNetwork = NO;
        selfWeak.selectIndex = selfWeak.selectIndex + 1;
        !selfWeak.Handler ?: selfWeak.Handler();
        [SVProgressHUD showErrorWithStatus:@"抽奖机会已用完等待下一次抽奖"];
        NSLog(@"%@",error[@"message"]);
    }];
}




- (IBAction)didBUtton:(id)sender {
    HDactivityRulesView *activityRulesView = [[HDactivityRulesView alloc]initWithFrame:CGRectZero];
    activityRulesView.dic = self.dicData;
    [self addSubview:activityRulesView];
    [activityRulesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(285);
        make.height.mas_equalTo(425);
    }];
    
}

#pragma mark - HDLotterySuccessViewDelegate
/**
 点击提交
 */
- (void)hd_LotterySuccessViewDidClicksubmit:(NSString *)name phone:(NSString *)phone address:(NSString *)address {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"name"] = name;
    dic[@"tel"] = phone;
    dic[@"address"] = address;
    
    [SVProgressHUD show];
    [UKNetworkHelper PUT:[NSString stringWithFormat:@"/live/videos/%@/prize/%@",self.model.uuid,self.prizeUuid] parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self removeFromSuperview];
        }
        [SVProgressHUD dismiss];
        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error[@"message"]];
    }];
}

/**
 点击关闭
 */
- (void)hd_LotterySuccessViewDidClickclose {
    self.successView = nil;
}

@end
