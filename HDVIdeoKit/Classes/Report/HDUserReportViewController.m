//
//  HDUserReportViewController.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/11.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDUserReportViewController.h"
#import "HDReportModel.h"
#import "Macro.h"
#import "HDServicesManager.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#import "UKNetworkHelper.h"
#import "UKRequestURLPath.h"
#import "LHDAFNetworking.h"
#import "HDUkeInfoCenter.h"
#import "HDBaseNavView.h"
#import "HDUserReportView.h"

@interface HDUserReportViewController ()
<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PLShortVideoUploaderDelegate,HDUserReportViewDelegate>
/////导航
@property (nonatomic,strong)HDBaseNavView *navView;
////举报主视图
@property (nonatomic,strong)HDUserReportView *reportView;

/** 举报类型*/
@property (nonatomic,strong)NSArray *dataArry;
/** 举报内容 */
@property(nonatomic,copy) NSString *reportStr;


@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *imageviews;


@property (nonatomic, strong) PLSUploaderConfiguration *configuration;
@property (nonatomic, strong) PLShortVideoUploader *shortVideoUploader;
@property (nonatomic, strong) NSString *imagekey;
@property (nonatomic, strong) NSString *imagetoken;
@property (nonatomic, strong) NSString *coverImagePath;
@property (nonatomic, strong) NSMutableArray *uuids;

@end

@implementation HDUserReportViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.images = [NSMutableArray array];
    self.imageviews = [NSMutableArray array];
    self.uuids = [NSMutableArray array];
//
//    //添加通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardMiss:) name:UIKeyboardWillHideNotification object:nil];
//
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initSubViews {
    UIColor *pageColor = RGBA(225, 228, 233, 1);
    self.view.backgroundColor = pageColor;
    self.navView = [[HDBaseNavView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, GS_NavHeight) title:@"举报"];
    [self.view addSubview:self.navView];
    
    self.reportView = [[HDUserReportView alloc]init];
    self.reportView.delegate = self;
    [self.view addSubview:self.reportView];
    [self.reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
    
    }];
    
    @WeakObj(self);
    self.navView.backBlock = ^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
}

#pragma mark - 监听
//回收键盘改变控制器view
-(void)keyboardMiss:(NSNotification *)noti{
    


}
// 弹出键盘改变控制器view
-(void)keyboardShow:(NSNotification *)noti{
//    CGRect keyboardRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

#pragma mark - customFunc
- (NSString *)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key num:(int)num{
    //首先,需要获取沙盒路径
    NSString *picPath=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),key];
    BOOL isHaveImage = [self LocalHaveImage:key];
    if (isHaveImage) {
//        NSLog(@"本地已经保存该图片、无需再次存储...");
        return picPath;
    }
    NSData *imgData = UIImageJPEGRepresentation(image,0.5);

    [imgData writeToFile:picPath atomically:YES];
    return picPath;
}

- (BOOL)LocalHaveImage:(NSString*)key {

    //读取本地图片非resource
    NSString *picPath=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),key];
//    NSLog(@"查询是否存在 %@",picPath);
    UIImage *img=[[UIImage alloc]initWithContentsOfFile:picPath];

    return img?YES:NO;
}


- (void)tijiao{
    
    [SVProgressHUD show];
    if (self.reportView.photosArray.count > 0) {
        for (int i=0; i<self.reportView.photosArray.count; i++) {
            [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_fabushipin parameters:@{@"fileExt":@"png"} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
                   NSNumber *code = response[@"code"];
                   if ([[code stringValue] isEqualToString:@"0"]) {
                       NSDictionary *dic = response[@"data"];
                       
                       UIImage *image = self.images[i];
                       NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
                       NSString *timeSp = [NSString stringWithFormat:@"%ld%d", (long)[datenow timeIntervalSince1970],i];
                       NSString *path = [self SaveImageToLocal:image Keys:timeSp num:i];
               
                       PLSUploaderConfiguration *confi = [[PLSUploaderConfiguration alloc] initWithToken:dic[@"token"] videoKey:dic[@"key"] https:NO recorder:nil];
                       PLShortVideoUploader *videup = [[PLShortVideoUploader alloc] initWithConfiguration:confi];
                       videup.delegate = self;
                       [videup uploadVideoFile:path];
                   }
               } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
                   
               }];
        }
    }else {
        [self jubaonetwork];
    }
    

}

- (void)shortVideoUploader:(PLShortVideoUploader * _Nonnull)uploader uploadKey:(NSString * _Nullable)uploadKey uploadPercent:(float)uploadPercent {
}

- (void)shortVideoUploader:(PLShortVideoUploader * _Nonnull)uploader completeInfo:(PLSUploaderResponseInfo * _Nonnull)info uploadKey:(NSString * _Nonnull)uploadKey resp:(NSDictionary * _Nullable)resp {
    NSLog(@"resp: %@",resp);
//    NSLog(@"info: %@",info);
//    NSLog(@"uploadKey: %@",uploadKey);
    
    NSNumber *code = resp[@"code"];

   if ([code intValue] == 0) {
       [self.uuids addObject:resp[@"data"][@"uuid"]];

       if (self.images.count == self.uuids.count) {
           
           [self jubaonetwork];
       }
   }
}

-(void)jubaonetwork {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"targetUuid"] = self.UUID;
    dic[@"reason"] = [self.dataArry mj_JSONString];
    dic[@"content"] = self.reportStr;
    dic[@"photos"] = self.uuids;
    [HDServicesManager getjubaoCouponDataWithResultage:self.juboanetwo dic:dic block:^(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString) {
        if (isSuccess == YES) {
            [SVProgressHUD showSuccessWithStatus:@"您的举报信息已提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:alertString];
        }
    }];

}

- (void)tupiandid {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
       UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
       UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//           NSString *mediaType = AVMediaTypeVideo;
//           AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
//           if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
//               //            mAlertView(@"", @"请在'设置'中打开相机权限")
//               return;
//           }
           
           if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
               //            mAlertView(@"", @"照相机不可用")
               return;
           }
           UIImagePickerController *vc = [[UIImagePickerController alloc] init];
           vc.delegate = self;
           vc.allowsEditing = YES;
           vc.sourceType = UIImagePickerControllerSourceTypeCamera;
           vc.modalPresentationStyle = UIModalPresentationFullScreen;
           [self presentViewController:vc animated:YES completion:nil];
       }];
       UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           UIImagePickerController *vc = [[UIImagePickerController alloc] init];
           vc.delegate = self;
           vc.allowsEditing = YES;
           vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
           vc.modalPresentationStyle = UIModalPresentationFullScreen;
           [self presentViewController:vc animated:YES completion:nil];
       }];
       [alert addAction:action1];
       [alert addAction:action2];
       [alert addAction:action3];
       [self presentViewController:alert animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //图片在这里压缩一下
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.1f);
    
    if (self.images.count >=4 ) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [self.images insertObject:image atIndex:0];
//    [self addviewimageView:[UIImage imageWithData:imageData]];
//    [self downSamplingImgUrl:ima toPointSize:CGSizeMake(111, 111) scale:[UIScreen mainScreen].scale];
    self.reportView.photosArray = self.images;
    [picker dismissViewControllerAnimated:YES completion:nil];

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
    NSData *imageData = UIImageJPEGRepresentation(ima, 0.1f);
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFTypeRef)(imageData), imageSourceOption);
    
    CFMutableDictionaryRef mutOption = CFDictionaryCreateMutable(NULL,
                                                                 4,
                                                                 &kCFTypeDictionaryKeyCallBacks,
                                                                 &kCFTypeDictionaryValueCallBacks);


    CGFloat maxDimension = MAX(pointSize.width, pointSize.height) * scale;
    NSNumber *maxDimensionNum = [NSNumber numberWithFloat:maxDimension];

    // · kCGImageSourceCreateThumbnailFromImageAlways
    //这个选项控制是否生成缩略图（没有设为true的话 kCGImageSourceThumbnailMaxPixelSize 以及 CGImageSourceCreateThumbnailAtIndex不会起作用）默认为false，所以需要设置为true
    CFDictionaryAddValue(mutOption, kCGImageSourceCreateThumbnailFromImageAlways, kCFBooleanTrue);//

    // · kCGImageSourceShouldCacheImmediately
    // 是否在创建图片时就进行解码（当然要这么做，避免在渲染时解码占用cpu）并缓存，
    /* Specifies whether image decoding and caching should happen at image creation time.
    * The value of this key must be a CFBooleanRef. The default value is kCFBooleanFalse (image decoding will
    * happen at rendering time). //默认为不缓存，在图片渲染时进行图片解码
    */
    CFDictionaryAddValue(mutOption, kCGImageSourceShouldCacheImmediately, kCFBooleanTrue);

    // · kCGImageSourceCreateThumbnailWithTransform
    //指定是否应根据完整图像的方向和像素纵横比旋转和缩放缩略图
    /* Specifies whether the thumbnail should be rotated and scaled according
     * to the orientation and pixel aspect ratio of the full image.（默认为false
     */
    //要设为true，因为我们要缩小他！
    CFDictionaryAddValue(mutOption, kCGImageSourceCreateThumbnailWithTransform, kCFBooleanTrue);


    // · kCGImageSourceThumbnailMaxPixelSize
    /* Specifies the maximum width and height in pixels of a thumbnail.  If
     * this this key is not specified, the width and height of a thumbnail is
     * not limited and thumbnails may be as big as the image itself.  If
     * present, this value of this key must be a CFNumberRef. */
    //指定缩略图的宽（如果缩略图的高大于宽，那就是高，那个更大填哪个）

    //这里我猜测生成的是一个矩形（划重点，我猜的，我猜的，我猜的，请自行论证）
    //画丑了，总之下面是两个正方形！
    /*           高更大            宽更大
                ________          _______
               |  \\\\  |   or   |       |
               |  \\\\  |        |\\\\\\\|
               |  \\\\  |        |       |
                --------          -------
     */

    CFDictionaryAddValue(mutOption, kCGImageSourceThumbnailMaxPixelSize, (__bridge CFNumberRef)maxDimensionNum);

    CFDictionaryRef dowsamplingOption = CFDictionaryCreateCopy(NULL, mutOption);


    //生成缩略图
    CGImageRef rf = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, dowsamplingOption);
    //用UIImage把他装起来，返回
    UIImage *img = [UIImage imageWithCGImage:rf];
    return img;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isEqual:self]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }
}

#pragma mark - HDUserReportViewDelegate
- (void)hd_UserReportViewDidClickAddImage {
    [self tupiandid];
}
///提交
- (void)hd_UserReportViewDidClickSubmitWithReason:(NSArray *)reason text:(NSString *)text {
    self.dataArry = reason;
    self.reportStr = text;
    [self tijiao];
}

@end
