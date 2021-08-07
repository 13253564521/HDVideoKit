//
//  HDLiveReleaseController.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/14.
//  Copyright © 2021 刘高升. All rights reserved.
// 直播发布

#import "HDLiveReleaseController.h"
#import "HDLiveReleaseView.h"
#import "HDBaseNavView.h"
#import "Macro.h"
#import "UKNetworkHelper.h"
#import "UKRequestURLPath.h"
#import "HDHuatiModel.h"
#import "HDCustomMyPickerViewController.h"
#import "HDServicesManager.h"
#import "HDtuiliuVideoViewController.h"
#import "HDUkeInfoCenter.h"
#import "HDActivityIDModel.h"
#import "HDHuatiViewController.h"

#import <PLShortVideoKit/PLShortVideoKit.h>
#import <PGDatePicker/PGDatePickManager.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>



#define SYSTEM_VERSION_GREATER_THAN(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
@interface HDLiveReleaseController ()<HDLiveReleaseViewDelegate,PGDatePickerDelegate,CLLocationManagerDelegate,TZImagePickerControllerDelegate,PLShortVideoUploaderDelegate>
/** 直播设置时间timestring */
@property(nonatomic,copy) NSString *timestring;

@property(nonatomic , strong) HDBaseNavView *navView;
@property(nonatomic , strong) HDLiveReleaseView *liveView;

///获取用户位置信息
@property (nonatomic, strong) CLLocationManager *locaationManager;

///图片路径
@property (nonatomic, strong) NSString *coverImagePath;

///选中图片
@property (nonatomic, strong) UIImage *selectImage;

@property (nonatomic, strong) NSArray *selectedhuatiIdArr;
@property (nonatomic, strong) NSMutableArray<HDHuatiModel*> *huatidataArr;
@property (nonatomic, strong) NSArray *huodongArr;
@property (nonatomic, strong) NSMutableArray *huodongidsArr;

@property (nonatomic, copy) NSString *imagekey;
@property (nonatomic, copy) NSString *imagetoken;
@property (nonatomic, copy) NSString *imageuuid;

/** 标题 */
@property(nonatomic,copy) NSString *textViewText;
/** 直播时间活动时间 */
@property(nonatomic,copy) NSString *liveTimeText;
/** 抽奖id*/
@property(nonatomic,copy) NSString *lotorryId;

@property (nonatomic, strong)NSNumber *liveType;
@property (nonatomic, strong)NSNumber *formType;
@end

@implementation HDLiveReleaseController
#pragma mark - 懒加载
- (NSMutableArray *)huodongidsArr {
    if (!_huodongidsArr) {
        _huodongidsArr = [NSMutableArray array];
    }
    return _huodongidsArr;
}



#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getNetWorkSetting];
    [self initSubViews];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initSubViews {
    UIColor *pageColor = RGBA(225, 228, 233, 1);
    self.view.backgroundColor = pageColor;
    self.navView = [[HDBaseNavView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, GS_NavHeight) title:@"直播设置"];
    [self.view addSubview:self.navView];
    
    self.liveView = [[HDLiveReleaseView alloc]init];
    self.liveView.delegate = self;
    [self.view addSubview:self.liveView];
    [self.liveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
    
    }];
    
    @WeakObj(self);
    self.navView.backBlock = ^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
    
    
    NSString *liveVideoDevice = [HDUkeInfoCenter sharedCenter].userModel.liveVideoDevice;
    if ([liveVideoDevice isEqualToString:@"2"]) {
        self.liveView.hardwareliveButton.hidden = YES;
 
    }
}
- (void)getNetWorkSetting {
    @WeakObj(self);
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_fabushipin parameters:@{@"fileExt":@"jpg"} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
         NSNumber *code = response[@"code"];
         if ([[code stringValue] isEqualToString:@"0"]) {
             NSDictionary *dic = response[@"data"];
             selfWeak.imagekey = dic[@"key"];
             selfWeak.imagetoken = dic[@"token"];

         }
     } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
         
     }];
    
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_LiveActiviId parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            selfWeak.huodongArr = [HDActivityIDModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            
            for (HDActivityIDModel *activityModel in self.huodongArr) {
                [selfWeak.huodongidsArr addObject:activityModel.activityId];
            }
        }else{
            [selfWeak.view makeToast:@"获取活动ID失败"];
        }
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        [selfWeak.view makeToast:@"获取活动ID失败"];
    }];
    
    [self huatiRequest];
}
///话题请求
- (void)huatiRequest {
    [SVProgressHUD show];
    @WeakObj(self);
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_huati parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            selfWeak.huatidataArr = [HDHuatiModel mj_objectArrayWithKeyValuesArray:response[@"data"]];

        }else{
            [selfWeak.view makeToast:@"获取话题失败，请稍后重试!"];
        }
        [SVProgressHUD dismiss];
    } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
        [selfWeak.view makeToast:@"获取话题失败，请稍后重试!"];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - HDLiveReleaseViewDelegate
/**
 点击下一步
 */
- (void)liveReleaseViewDidClickNextButtonTitle:(NSString *)title livePrewTimeString:(NSString *)livePrewTimeString liveType:(NSNumber *)liveType useForm:(NSNumber *)useForm activityId:(NSString *)activityId {
    if (activityId && ![activityId isEqualToString:@""]) {
        if (![self.huodongidsArr containsObject:activityId]) {
            return [SVProgressHUD showErrorWithStatus:@"活动ID不匹配，请重新输入"];
        }
        self.lotorryId = activityId;
    }

    self.textViewText = title;
    self.liveTimeText = livePrewTimeString;
    self.liveType = liveType;
    self.formType = useForm;
    
    PLSUploaderConfiguration *confi = [[PLSUploaderConfiguration alloc] initWithToken:self.imagetoken videoKey:self.imagekey https:NO recorder:nil];
    PLShortVideoUploader *videup = [[PLShortVideoUploader alloc] initWithConfiguration:confi];
    videup.delegate = self;
    [videup uploadVideoFile:self.coverImagePath];
}

/**
 点击复制链接
 */
- (void)liveReleaseViewDidClickCopyUrl:(NSString *)url {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = url;
    if (pab == nil) {
        [self.view makeToast:@"复制失败"];
    } else {
        [self.view makeToast:@"复制成功"];
    }
}
/**
点击添加封面视图操作
 */
- (void)liveReleaseViewDidClickAddcoverImage {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.allowCrop = NO;
   
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
直播预告设置时间
 */
- (void)liveReleaseViewDidClicklivepreViewGes {

    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.minuteInterval = 15;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
    [self presentViewController:datePickManager animated:false completion:nil];
}

/**
是否使用位置信息
 */
- (void)liveReleaseViewDidClickisUselocation:(UIButton *)sender {
    if (sender.isSelected) {
        // 1.检查定位服务是否开启
        if ([self checkLocationServiceIsEnabled]) {
            // 2.创建定位管理器：
            [self createCLManager];
        }else {
            sender.selected = NO;
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"系统定位尚未打开，请到【设定-隐私】中手动打开" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * tipsAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
                }
            }];
            [alertVC addAction:tipsAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }else {
        [self.locaationManager stopUpdatingLocation];
    }
}


- (void)liveReleaseViewDidClickhuatiViewGes {
    [self showHuatiView];
}
#pragma mark - location
- (BOOL)checkLocationServiceIsEnabled{
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    }else {
        return YES;
    }
}

- (void)createCLManager{
    if (!self.locaationManager) {
        // 创建CoreLocation管理对象
        self.locaationManager = [[CLLocationManager alloc]init];
        // 设定定位精准度
        [self.locaationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        // 设定DistanceFilter可以在用户移动指定距离之后触发更新事件（100米更新一次）
        [self.locaationManager setDistanceFilter:100.f];
        // 设置代理
        self.locaationManager.delegate = self;
    }

    // 开始更新定位
    [self.locaationManager startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate

// 代理方法，更新位置
-  (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    // locations是一个数组提供了一连串的用户定位，所以在这里我们只取最后一个（当前最后的定位）
    CLLocation * newLocation = [locations lastObject];
    // 判空处理
    if (newLocation.horizontalAccuracy < 0) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位错误，请检查手机网络以及定位" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * tipsAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:tipsAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    // 获取定位经纬度
    CLLocationCoordinate2D coor2D = newLocation.coordinate;
    NSLog(@"纬度为:%f, 经度为:%f", coor2D.latitude, coor2D.longitude);


    
    @WeakObj(self);
    // 反地理编码(根据当前的经纬度获取具体的位置信息)
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placeMark in placemarks) {
            NSLog(@"位置:%@", placeMark.name);
            NSLog(@"街道:%@", placeMark.thoroughfare);
            NSLog(@"子街道:%@", placeMark.subThoroughfare);
            NSLog(@"市:%@", placeMark.locality);
            NSLog(@"区\\县:%@", placeMark.subLocality);
            NSLog(@"行政区:%@", placeMark.administrativeArea);
            NSLog(@"国家:%@", placeMark.country);
//            self.weizhiLabel.text = [NSString stringWithFormat:@"%@%@%@",placeMark.locality,placeMark.subLocality,placeMark.name];
//            self.selectcity = placeMark.locality;
            ///更新位置信息
            selfWeak.liveView.locationStr = [NSString stringWithFormat:@"%@%@%@",placeMark.locality,placeMark.subLocality,placeMark.name];
        }
    }];

    
    // 停止更新位置
    [self.locaationManager stopUpdatingLocation];
}

// 代理方法，定位权限检查
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"用户还未决定授权");
            // 主动获得授权
            [self.locaationManager requestWhenInUseAuthorization];
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            // 主动获得授权
            [self.locaationManager requestWhenInUseAuthorization];
            break;
        }
        case kCLAuthorizationStatusDenied:{
            // 此时使用主动获取方法也不能申请定位权限
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位服务开启，被拒绝");
            } else {
                NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:{
            NSLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
}



#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    NSString *thisYearString=[dateformatter stringFromDate:senddate];

    if (dateComponents.year < [thisYearString intValue]) {
        return [SVProgressHUD showErrorWithStatus:@"请选择大于当前年份日期"];
    }
    NSString *time =[NSString stringWithFormat:@"%ld-%ld-%ld %ld:%0.2ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day,(long)dateComponents.hour,(long)dateComponents.minute];

    NSDate *date = [self getTimeStrWithString:time];
    NSInteger dateTime = [self getDateTimeTOMilliSeconds:date];
    if ([self compareTwoTime:dateTime time2:[self getDateTimeTOMilliSeconds:[NSDate date]]] == YES) {
        ///设置时间
        self.timestring = [NSString stringWithFormat:@"%ld",(long)dateTime];
        ////
        self.liveView.livePrewTimeString = time;
    }else {
        [SVProgressHUD showErrorWithStatus:@"请选择大于当前的时间"];
    }
    
//    NSLog(@"22===%@",[self time_timestampToString:dateTime]);
}
#pragma mark - time 处理
//date转化时间戳
-(NSInteger)getDateTimeTOMilliSeconds:(NSDate *)datetime {

    NSTimeInterval interval = [datetime timeIntervalSince1970];
    return interval;
}


///时间戳转化为字符转0000-00-00 00:00
- (NSString *)time_timestampToString:(NSInteger)timestamp{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
     [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    return string;
}

- (NSDate *)getTimeStrWithString:(NSString *)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *birthdayDate = [dateFormatter dateFromString:str];
    return birthdayDate;
}

- (BOOL)compareTwoTime:(NSInteger )time1 time2:(NSInteger )time2 {

        
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time1];
    NSString *dateString1 = [formatter stringFromDate:date];
        
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:time2];
    NSString *dateString2 = [formatter stringFromDate:date2];
        
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit =NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmps = [calendar components:unit fromDate:date2 toDate:date options:0];

    NSLog(@"dateString1=%@",dateString1);
    NSLog(@"dateString2=%@",dateString2);
    NSString *str = [NSString stringWithFormat:@"差值%ld天,%ld小时%ld分%ld秒",(long)cmps.day ,(long)cmps.hour, (long)cmps.minute,(long)cmps.second];
    NSLog(@"1111=%@",str);
    if (cmps.day < 0 || cmps.hour < 0 || cmps.minute < 0) {
        return NO;
    }else {
        return YES;
    }

//    NSLog(@"%@",);

//    // 获得某个时间的年月日时分秒
//    NSLog(@"差值%ld天,%ld小时%ld分%ld秒",cmps.day ,cmps.hour, cmps.minute,cmps.second);
//    输出结果：
//    2017-06-30 10:39:32
//    2017-07-15 23:59:00
//    差值15天,13小时19分28秒
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    UIImage *image = photos.firstObject;
    
    self.selectImage = image;
    self.liveView.selectImage =  [self downSamplingImgUrl:image toPointSize:CGSizeMake(120, 160) scale:[UIScreen mainScreen].scale];
    [self setcoverImagePath];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)setcoverImagePath {
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
   NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    self.coverImagePath = [self SaveImageToLocal:self.selectImage Keys:timeSp];
}

- (NSString *)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key {
    //首先,需要获取沙盒路径
    NSString *picPath=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),key];
    NSLog(@"将图片保存到本地  %@",picPath);
    BOOL isHaveImage = [self LocalHaveImage:key];
    if (isHaveImage) {
        NSLog(@"本地已经保存该图片、无需再次存储...");
        return picPath;
    }
    NSData *imgData = UIImageJPEGRepresentation(image,1);

    [imgData writeToFile:picPath atomically:YES];
    return picPath;
}

//本地是否有图片
- (BOOL)LocalHaveImage:(NSString*)key {

    //读取本地图片非resource
    NSString *picPath=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),key];
    NSLog(@"查询是否存在 %@",picPath);
    UIImage *img=[[UIImage alloc]initWithContentsOfFile:picPath];

    return img?YES:NO;
}

- (UIImage *)downSamplingImgUrl:(UIImage *)ima
                    toPointSize:(CGSize)pointSize
                          scale:(CGFloat)scale {

    //避免下次产生缩略图时大小不同，但被缓存了，取出来是缓存图片
    //所以要把kCGImageSourceShouldCache设为false
    CFStringRef key[1];
    key[0] = kCGImageSourceShouldCache;
    CFTypeRef value[1];
    value[0] = (CFTypeRef)kCFBooleanFalse;

    CFDictionaryRef imageSourceOption = CFDictionaryCreate(NULL,
                                                           (const void **) key,
                                                           (const void **) value,
                                                           1,
                                                           &kCFTypeDictionaryKeyCallBacks,
                                                           &kCFTypeDictionaryValueCallBacks);
    NSData *imageData = UIImageJPEGRepresentation(ima, 1.0f);
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFTypeRef)(imageData), imageSourceOption);
    
    CFMutableDictionaryRef mutOption = CFDictionaryCreateMutable(NULL,
                                                                 4,
                                                                 &kCFTypeDictionaryKeyCallBacks,
                                                                 &kCFTypeDictionaryValueCallBacks);


    CGFloat maxDimension = MAX(pointSize.width, pointSize.height) * scale;
    NSNumber *maxDimensionNum = [NSNumber numberWithFloat:maxDimension];

    CFDictionaryAddValue(mutOption, kCGImageSourceCreateThumbnailFromImageAlways, kCFBooleanTrue);//
    CFDictionaryAddValue(mutOption, kCGImageSourceShouldCacheImmediately, kCFBooleanTrue);
    CFDictionaryAddValue(mutOption, kCGImageSourceCreateThumbnailWithTransform, kCFBooleanTrue);
    CFDictionaryAddValue(mutOption, kCGImageSourceThumbnailMaxPixelSize, (__bridge CFNumberRef)maxDimensionNum);
    CFDictionaryRef dowsamplingOption = CFDictionaryCreateCopy(NULL, mutOption);
    //生成缩略图
    CGImageRef rf = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, dowsamplingOption);
    //用UIImage把他装起来，返回
    UIImage *img = [UIImage imageWithCGImage:rf];
    return img;
}
#pragma mark - PLShortVideoUploaderDelegate
- (void)shortVideoUploader:(PLShortVideoUploader * _Nonnull)uploader uploadKey:(NSString * _Nullable)uploadKey uploadPercent:(float)uploadPercent {
    [SVProgressHUD showProgress:uploadPercent status:@"上传中"];
}

- (void)shortVideoUploader:(PLShortVideoUploader * _Nonnull)uploader completeInfo:(PLSUploaderResponseInfo * _Nonnull)info uploadKey:(NSString * _Nonnull)uploadKey resp:(NSDictionary * _Nullable)resp {
    
    NSLog(@"resp: %@",resp);
    NSLog(@"info: %@",info);
    NSLog(@"uploadKey: %@",uploadKey);
    
    NSNumber *code = resp[@"code"];
    
    if ([code intValue] == 0) {
        self.imageuuid = resp[@"data"][@"uuid"];
        
        if (self.imageuuid.length > 1) {

            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (self.selectedhuatiIdArr.count > 0) {
                dic[@"tags"] = self.selectedhuatiIdArr;
            }
            dic[@"title"] = self.textViewText;
            if (![self.liveView.locationStr isEqualToString:@"选择当前位置"]) {
                dic[@"address"] = self.liveView.locationStr;
            }
            
            if (self.liveTimeText.length > 0) {
                dic[@"beginTime"] = @([self.timestring intValue]);
            }
            dic[@"liveType"] = self.liveType;
            dic[@"useForm"] = self.formType;
    
            if (self.lotorryId.length > 0) {
                dic[@"usePrizeDraw"] = @(1);
                dic[@"prizeActivity"] = self.lotorryId;
            }else{
                dic[@"usePrizeDraw"] = @(0);
            }


            dic[@"description"] = @"";
            dic[@"coverUuid"] = self.imageuuid;
            NSLog(@"%@",dic);
            [HDServicesManager getchuangjianvideosDataWithResul:dic block:^(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString) {
                
                [SVProgressHUD dismiss];
                
                if (isSuccess == YES) {
                    if (self.liveView.livepreviewButton.selected == YES) {
                        
                        if (self.liveView.hardwareliveButton.selected == YES) {
                            [self vcto:dic[@"uuid"] isshow:NO];
                        }else {
                            [self showyuvi];
                        }
          
                    }else if (self.liveView.hardwareliveButton.selected == YES && self.liveView.liveStartButton.selected == YES){
                        [self vcto:dic[@"uuid"] isshow:YES];
                    }else {
                        HDtuiliuVideoViewController *vide = [[HDtuiliuVideoViewController alloc]init];
                        NSString *uuid = dic[@"uuid"];
                        vide.uuid = uuid;
                        [self.navigationController pushViewController:vide animated:YES];
                    }
                }else {
                    [SVProgressHUD showErrorWithStatus:alertString];
                }
                
            }];
        }
    }else {
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    }
}


#pragma mark - customFunc

- (void)showHuatiView {

    if (self.huatidataArr.count == 0) {
        [self huatiRequest];
        return;
    }
    HDHuatiViewController *huatiVc = [[HDHuatiViewController alloc]init];
    [self.navigationController pushViewController:huatiVc animated:YES];
    huatiVc.huatisArray = self.huatidataArr;
    
    @WeakObj(self);
    huatiVc.huatiSelectedblock = ^(NSArray<HDHuatiModel *> * _Nonnull array) {
        //显示选中话题
        NSString *huatiStr = @"";
        NSMutableArray *selectedHuatiIdsArray = [NSMutableArray array];
        for (HDHuatiModel *model in array) {
            huatiStr = [NSString stringWithFormat:@"%@#%@",huatiStr,model.name];
            [selectedHuatiIdsArray addObject:model.uuid];
        }
        selfWeak.liveView.selectedHuatiText = huatiStr;
        selfWeak.selectedhuatiIdArr = selectedHuatiIdsArray;


    };
    
}

-(void)vcto:(NSString *)uuid isshow:(BOOL)show{
    [HDServicesManager getdeosdddafDataWithResul:uuid block:^(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString) {
        if (isSuccess == YES) {
           NSString *ta = [NSString stringWithFormat:@"%@",dic.publishUrl];
            NSLog(@"===%@",dic.publishUrl);
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"硬件直播链接" message:ta preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *dismissBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull   action) {
            
            }];
            UIAlertAction *sureBtn1 = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull   action) {
                
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                [pab setString:dic.publishUrl];
                 if (pab == nil) {
                     [SVProgressHUD showErrorWithStatus:@"复制失败"];
                 }else
                 {
                    [SVProgressHUD showSuccessWithStatus:@"已复制"];
                 }
                
                if (show == YES) {
                    HDtuiliuVideoViewController *vc = [[HDtuiliuVideoViewController alloc]init];
                    vc.uuid = dic.uuid;
                    vc.isyingjianzhibo = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    [self showyuvi];
                }
        
            }];
           [alertVc addAction:dismissBtn];
           [alertVc addAction:sureBtn1];
           [self presentViewController:alertVc animated:YES completion:nil];
        }
    }];
}

-(void)showyuvi {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲爱的主播，您的直播预告已发布 记得按时开始直播哟" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *sureBtn1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
   [alertVc addAction:sureBtn1];
   [self presentViewController:alertVc animated:YES completion:nil];
}
@end
