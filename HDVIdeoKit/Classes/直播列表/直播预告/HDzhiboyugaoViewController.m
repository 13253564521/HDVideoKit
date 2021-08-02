//
//  HDzhiboyugaoViewController.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/10/28.
//

#import "HDzhiboyugaoViewController.h"
#import "YYWebImage.h"
#import "Macro.h"
#import "UKNetworkHelper.h"
#import "HDUkeInfoCenter.h"
#import "HDtuiliuVideoViewController.h"
#import "HDUkeInfoCenter.h"
#import "HDuserVideolaliuController.h"
#import "HDServicesManager.h"
#import <SDWebImage.h>
#import "HDBaseNavView.h"
#import "HDzhiboModel.h"

@interface HDzhiboyugaoViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *liveTypeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *timeIconImageView;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *contenlabel;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (nonatomic, strong) NSTimer *progressTimer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) UIButton *deleteButton;

@property(nonatomic , strong) HDBaseNavView *navView;
@end

@implementation HDzhiboyugaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingConfig];

}


- (void)settingConfig {
    self.topConstraint.constant = GS_NavHeight + 12;
    UIColor *pageColor = RGBA(225, 228, 233, 1);
    
    self.view.backgroundColor = pageColor;
    self.scrollview.backgroundColor = pageColor;
    self.navView = [[HDBaseNavView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, GS_NavHeight) title:@"直播预告"];
    [self.view addSubview:self.navView];
    
    @WeakObj(self);
    self.navView.backBlock = ^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
    
    self.liveTypeImageView.image = [UIImage imageNamed:HDBundleImage(@"paishe/icon_zhibo_yugao")];
    self.timeIconImageView.image = [UIImage imageNamed:HDBundleImage(@"paishe/icon_bicolor_shijian")];
    self.icon.layer.cornerRadius = 15;
    self.icon.layer.masksToBounds = YES;
    [self.icon yy_setImageWithURL:[NSURL URLWithString:self.model.coverUrl] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];
    self.contenlabel.text = self.model.title;
    
    [self.image1 sd_setImageWithURL:[NSURL URLWithString:self.model.photoUrl] placeholderImage:nil options:SDWebImageProgressiveLoad progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image != nil) {
            
            [selfWeak.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(selfWeak.contenlabel.mas_bottom).offset(30);
                make.width.mas_equalTo(kScreenWidth - 40);
                make.height.mas_equalTo([selfWeak imgContentHeight:image]);
                make.centerX.mas_equalTo(0);
            }];
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                selfWeak.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.image1.frame) + 20);
            });
        }
    }];
    
    
    self.time.text = [NSString stringWithFormat:@"开始时间: %@",[self time_timestampToString:self.model.beginTime]];
    
    
    if ([self.model.userUuid isEqualToString:[HDUkeInfoCenter sharedCenter].userModel.uuid]) { //自己
       // 添加删除按钮
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.navView addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.navView.mas_right).offset(-16);
            make.top.equalTo(self.navView.mas_top).offset(GS_StatusBarHeight + 10);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(24);
        }];
    }

    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}
-(CGFloat)imgContentHeight:(UIImage *)image{
    //获取图片高度
    CGFloat imgHeight = image.size.height;
    CGFloat imgWidth = image.size.width;
    CGFloat imgH = imgHeight * ((kScreenWidth - 40) / imgWidth);
    return imgH;
}

-(void)updateProgressInfo {
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:self.model.beginTime];
    int datea = [self compareOneDay:timeDate withAnotherDay:[self getCurrentTime]];
    
    
    if (datea == 1) {

    }else {
        [self removeProgressTimer];
        
        [HDServicesManager getdeosdddafDataWithResul:self.model.uuid block:^(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString) {
            if ([[HDUkeInfoCenter sharedCenter].userModel.uuid isEqualToString:self.model.userUuid]) {
                dic.state = @"14";
                [self setModelpuvc:dic];
                
            }else {
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    dic.state = @"14";
                    [self setModelpuvc:dic];
                });
                
            }
       
        }];
        
       
    }

}

-(void)setModelpuvc:(HDzhiboModel *)model {
    if ([model.state intValue] == 14) {
        
        if ([model.liveType isEqualToString:@"2"])//手机直播
        {
            [self push1:model isyingjianzhibo:NO];
        }else//硬件直播
        {
            [self push1:model isyingjianzhibo:YES];
        }
        
    }else if ([model.state intValue] == 15) {
        HDuserVideolaliuController *vc = [[HDuserVideolaliuController alloc]init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)push1:(HDzhiboModel *)model isyingjianzhibo:(BOOL)isyingjianzhibo{
    
    if ([[HDUkeInfoCenter sharedCenter].userModel.uuid isEqualToString:model.userUuid]) {
        HDtuiliuVideoViewController *vide = [[HDtuiliuVideoViewController alloc]init];
        vide.uuid = model.uuid;
        vide.isliveVideoparticulars = YES;
        vide.isyingjianzhibo = isyingjianzhibo;
        [self.navigationController pushViewController:vide animated:YES];
    }else {
        HDuserVideolaliuController *vc = [[HDuserVideolaliuController alloc]init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

-(void)removeProgressTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    return date;
}

//返回1 - 过期, 0 - 相等, -1 - 没过期
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //刚好时间一样.
    //NSLog(@"Both dates are the same");
    return 0;
    
}

-(void)cancelButtonClick {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"是否确认删除" preferredStyle:UIAlertControllerStyleAlert];

       UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
           
           [UKNetworkHelper DELETE:[NSString stringWithFormat:@"/user-center/live/videos/%@",self.model.uuid] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
                   
               } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
                   
               }];
           
           if ([self.delegate respondsToSelector:@selector(currentModelremove:)]) {
               [self.delegate currentModelremove:self.model];
           }
           
           [self.navigationController popViewControllerAnimated:YES];
       }];
    
        UIAlertAction *sureBtn1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull   action) {
        }];

       [alertVc addAction:sureBtn];
        [alertVc addAction:sureBtn1];
       //展示
       [self presentViewController:alertVc animated:YES completion:nil];
    
  
}

- (NSString *)time_timestampToString:(NSInteger)timestamp{

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];

    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];

     [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSString* string=[dateFormat stringFromDate:confromTimesp];

    return string;

}
@end
