
//  HDshangchuanViewController.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/13.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDshangchuanViewController.h"
#import "Macro.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import "HDHuatiModel.h"
#import <PLShortVideoKit/PLShortVideoKit.h>

#import "UKNetworkHelper.h"
#import "UKRequestURLPath.h"
#import "LHDAFNetworking.h"
#import "HDUkeInfoCenter.h"

#import "HDTakeVideoTableViewCell.h"
#import "HDTakeVideoModel.h"

#import "HDServicesManager.h"
#import "HDPOIModel.h"
#import "HDPlatesModel.h"
#import "HDPOISelectedViewController.h"

#import "HDCustomMyPickerViewController.h"
#import "HDHuatiViewController.h"

@interface HDshangchuanViewController ()<UITextViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,PLShortVideoUploaderDelegate,UITextFieldDelegate,TZImagePickerControllerDelegate>
///tableHeadeView
@property (nonatomic, strong) UIView *tableHeadeView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *fenmianImage;
@property (nonatomic, strong) UILabel *placeHolder;


@property (nonatomic, strong) CLLocationManager *locaationManager;

///主要tableview
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSArray *selectedhuatiIdArr;
@property (nonatomic, strong) NSMutableArray<HDHuatiModel*> *huatidataArr;
@property (nonatomic, strong) NSMutableArray<HDTakeVideoModel*> *videodatasArr;

@property (nonatomic, strong) UIButton *fengmainButton;

@property (nonatomic, strong) NSString *imagekey;
@property (nonatomic, strong) NSString *imagetoken;
@property (nonatomic, strong) NSString *videokey;
@property (nonatomic, strong) NSString *videotoken;

@property (nonatomic, strong) PLSUploaderConfiguration *configuration;
@property (nonatomic, strong) PLShortVideoUploader *shortVideoUploader;

@property (nonatomic, strong) UIView *topVIew;

//七牛云上传成功返回
@property (nonatomic, strong) NSString *videouuid;
@property (nonatomic, strong) NSString *imageuuid;


@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) NSString *coverImagePath;


@property (nonatomic, assign) BOOL selecfabu;


/** 是否已经获取过地理位置 */
@property(nonatomic,assign) BOOL isGetLocation;
/** poi数组*/
@property(nonatomic,strong) NSArray *poisArray;


/** 板块数组*/
@property(nonatomic,strong) NSArray<HDPlatesModel *> *platesArray;

/** 圈子数组*/
@property(nonatomic,strong) NSArray *circlesArray;


/** 当前选中的cell*/
@property(nonatomic,strong) NSIndexPath *currentIndexPath;

/** 车型 */
@property(nonatomic,copy) NSString *carModel;
/** 车系 */
@property(nonatomic,copy) NSString *carKind;
/** 位置信息*/
@property(nonatomic,copy) NSString *locationStr;
@end

@implementation HDshangchuanViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;

}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]init];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.estimatedRowHeight = 56;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
     ///注册cell
        [_mainTableView registerClass:[HDTakeVideoTableViewCell class] forCellReuseIdentifier:@"HDTakeVideoCell"];
    }
    
    return _mainTableView;
}

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

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.textColor = UkeColorHex(0x333333);
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.backgroundColor = RGBA(225, 228, 233, 1);
        _textView.delegate = self;

    }
    return _textView;
}

- (NSMutableArray<HDTakeVideoModel *> *)videodatasArr {
    if (!_videodatasArr) {
        _videodatasArr = [NSMutableArray array];
    }
    return _videodatasArr;
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self netWork];
    [self huatiRequest];


}
- (void)initSubViews {
    ///拍视频界面list
    //话题选项
    HDTakeVideoModel *huatiModel = [[HDTakeVideoModel alloc]init];
    huatiModel.imageName = @"paishe/icon_bicolor_huati";
    huatiModel.title = @"选择话题";
    [self.videodatasArr addObject:huatiModel];
    
    //选择板块
    HDTakeVideoModel *bankuaiModel = [[HDTakeVideoModel alloc]init];
    bankuaiModel.imageName = @"paishe/icon_bicolor_quanzi";
    bankuaiModel.title = @"选择板块";
    [self.videodatasArr addObject:bankuaiModel];
    
    //选择车型
    HDTakeVideoModel *chexingModel = [[HDTakeVideoModel alloc]init];
    chexingModel.imageName = @"paishe/icon_bicolor_chexing";
    chexingModel.title = @"选择车型";
    [self.videodatasArr addObject:chexingModel];
    
    //选择位置
    HDTakeVideoModel *locationModel = [[HDTakeVideoModel alloc]init];
    locationModel.imageName = @"paishe/icon_bicolor_location";
    locationModel.title = @"选择位置";
    [self.videodatasArr addObject:locationModel];
    
    
    
    
    UIColor *pageColor = RGBA(225, 228, 233, 1);
    
    self.view.backgroundColor = pageColor;
    self.topVIew = [[UIView alloc]init];
    self.topVIew.backgroundColor = pageColor;
    [self.view addSubview:self.topVIew];
    [self.topVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(GS_NavHeight);
    }];

    UIButton *leftButton = [[UIButton alloc]init];
    [leftButton setImage:[UIImage imageNamed:HDBundleImage(@"navgation/btn_back1")] forState:0];
    [leftButton addTarget:self action:@selector(ledtButtonDId) forControlEvents:UIControlEventTouchUpInside];
    [self.topVIew addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topVIew).offset(20);
        make.bottom.mas_equalTo(self.topVIew).offset(-10);
    }];
    
    UILabel *titLabel = [[UILabel alloc]init];
    titLabel.text = @"拍视频";
    titLabel.textColor = [UIColor blackColor];
    titLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.topVIew addSubview:titLabel];
    [titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topVIew);
        make.centerY.mas_equalTo(leftButton.mas_centerY);
  
    }];
    
    
    
    UIButton *baocunBUtton = [[UIButton alloc]init];
    [baocunBUtton setTitleColor:RGBA(0, 61, 227, 1) forState:UIControlStateNormal];
    [baocunBUtton setTitle:@"保存至相册" forState:UIControlStateNormal];
    baocunBUtton.titleLabel.font = [UIFont systemFontOfSize:16];
    [baocunBUtton setBackgroundColor:[UIColor whiteColor]];
    [baocunBUtton addTarget:self action:@selector(baocunbutton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:baocunBUtton];
    [baocunBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(81);
    }];
    
    UIButton *fabubutton = [[UIButton alloc]init];
    [fabubutton setTitle:@"发布" forState:0];
    fabubutton.titleLabel.font = [UIFont systemFontOfSize:16];
    [fabubutton setTitleColor:[UIColor whiteColor] forState:0];
    [fabubutton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    fabubutton.backgroundColor = RGBA(55, 113, 255, 1);
            fabubutton.layer.cornerRadius = 24;
            fabubutton.layer.masksToBounds = YES;
    [fabubutton addTarget:self action:@selector(fabubutton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fabubutton];
    [fabubutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(baocunBUtton.mas_top);
        make.height.mas_equalTo(46);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
    }];
    
    ///tableHeaderView
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topVIew.mas_bottom);
        make.bottom.equalTo(fabubutton.mas_top);
    }];
    
    self.tableHeadeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 424)];
    self.tableHeadeView.backgroundColor = [UIColor clearColor];
    self.mainTableView.tableHeaderView = self.tableHeadeView;
    [self.tableHeadeView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableHeadeView).offset(16);
        make.top.mas_equalTo(self.tableHeadeView.mas_top).offset(16);
        make.right.mas_equalTo(self.tableHeadeView.mas_right).offset(-16);
        make.height.mas_equalTo(134);
    }];
    
    [self.tableHeadeView addSubview:self.placeHolder];
    [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textView);
        make.top.equalTo(self.textView.mas_top).offset(8);
    }];
    
    self.huatidataArr = [NSMutableArray array];
    
    self.fenmianImage = [[UIImageView alloc]init];
    self.fenmianImage.userInteractionEnabled = YES;
    self.fenmianImage.contentMode = UIViewContentModeScaleAspectFill;
    self.fenmianImage.layer.cornerRadius = 5;
    self.fenmianImage.layer.masksToBounds = YES;
    self.fenmianImage.backgroundColor = pageColor;
    [self.tableHeadeView addSubview:self.fenmianImage];
    [self.fenmianImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(20);
        make.left.mas_equalTo(self.tableHeadeView).offset(16);
        make.width.mas_equalTo(169);
        make.height.mas_equalTo(225);
    }];
    
    
    self.fengmainButton = [[UIButton alloc]init];
    self.fengmainButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.fengmainButton setTitle:@"设置封面" forState:0];
    [self.fengmainButton setBackgroundColor:RGBA(57, 60, 67, 0.56)];
    [self.fengmainButton addTarget:self action:@selector(fengmainButtondid) forControlEvents:UIControlEventTouchUpInside];
    [self.fengmainButton setTitleColor:[UIColor whiteColor] forState:0];
    self.fengmainButton.layer.cornerRadius = 12;
    self.fengmainButton.layer.masksToBounds = YES;
    [self.fenmianImage addSubview:self.fengmainButton];
    [self.fengmainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.fenmianImage).offset(-24);
        make.centerX.equalTo(self.fenmianImage.mas_centerX);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(24);
    }];

    
    
    
    UIView *xianview= [[UIView alloc]init];
    xianview.backgroundColor = RGBA(57, 60, 67, 0.08);
    xianview.layer.cornerRadius = 0.5;
    xianview.layer.masksToBounds = YES;
    [self.tableHeadeView addSubview:xianview];
    [xianview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableHeadeView.mas_left).offset(16);
        make.right.equalTo(self.tableHeadeView.mas_right).offset(-16);
        make.top.mas_equalTo(self.fenmianImage.mas_bottom).offset(16);
        make.height.mas_equalTo(1);
    }];
    
    
    self.coverImage = [self getVideoPreViewImage:self.url];
    self.fenmianImage.image = self.coverImage;
    [self setcoverImagePath];

}
-(void)ledtButtonDId {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {

}

-(void)textFieldDidEndEditing:(UITextField *)textField {

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

-(void)netWork {
 
    
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_fabushipin parameters:@{@"fileExt":@"mp4"} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            NSDictionary *dic = response[@"data"];
            self.videokey = dic[@"key"];
            self.videotoken = dic[@"token"];
        }
    } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
        
    }];
    
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_fabushipin parameters:@{@"fileExt":@"jpg"} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
         NSNumber *code = response[@"code"];
         if ([[code stringValue] isEqualToString:@"0"]) {
             NSDictionary *dic = response[@"data"];
             self.imagekey = dic[@"key"];
             self.imagetoken = dic[@"token"];

         }
     } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
         
     }];
    [SVProgressHUD dismiss];
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

-(void)setcoverImagePath {
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
   NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    self.coverImagePath = [self SaveImageToLocal:self.coverImage Keys:timeSp];
}


-(void)fengmainButtondid {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


-(void)baocunbutton:(UIButton*)button {
    [SVProgressHUD showSuccessWithStatus:@"视频已保存到相册"];
    UISaveVideoAtPathToSavedPhotosAlbum(self.url.path, nil, nil, nil);
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    UIImage *image = photos[0];
    
    self.coverImage = [self downSamplingImgUrl:image toPointSize:CGSizeMake(120, 160) scale:[UIScreen mainScreen].scale];

    self.fenmianImage.image = self.coverImage;
    [self setcoverImagePath];
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
#pragma mark - customfunc
///车型选择视图
- (void)showCartypeSeletedView {
    NSArray *provinceArray = @[];
    NSArray *usedArray = @[];
    if ([HDUkeInfoCenter sharedCenter].configurationModel.carSource == 1) {
        provinceArray = @[@"天V",@"JH6",@"安捷",@"虎V",@"虎VH",@"龙V",@"悍V",@"龙VH",@"J6F",@"金陆",@"麟V",@"JK6"];
        usedArray = @[@"牵引",@"载货",@"自卸",@"专用"];
    }else {
        provinceArray = @[@"J7",@"J6P",@"J6M",@"J6L"];
        usedArray = @[@"牵引",@"载货",@"自卸",@"专用"];
    }
    
    HDCustomMyPickerViewController *vc = [[HDCustomMyPickerViewController alloc]initWithTitle:@"意向车型" leftDataArray:provinceArray rightData:usedArray componenttitle:@"车系" dataArraytitle:@"车型"];
    [self.navigationController presentViewController:vc animated:NO completion:nil];
    
    @WeakObj(self);
    vc.getPickerValue = ^(NSString * _Nonnull compoentString, NSString * _Nonnull titileString) {
        HDTakeVideoModel *locationModel = selfWeak.videodatasArr[selfWeak.currentIndexPath.row];
        locationModel.subtitle = [NSString stringWithFormat:@"%@ %@",compoentString,titileString];
        selfWeak.carModel = compoentString;
        selfWeak.carKind = titileString;
        //刷新cell
        [selfWeak.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:selfWeak.currentIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
}

///板块视图
- (void)showPlatesView {
    [SVProgressHUD show];
    @WeakObj(self);
    [HDServicesManager getPlatesDatablock:^(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString) {
        [SVProgressHUD dismiss];
        selfWeak.platesArray = [HDPlatesModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        NSMutableArray *platespiker = [NSMutableArray array];
        if (selfWeak.platesArray.count > 0) {
            for (HDPlatesModel *platemodel  in selfWeak.platesArray) {
                [platespiker addObject:platemodel.name];
            }
        }
        HDCustomMyPickerViewController *vc = [[HDCustomMyPickerViewController alloc]initWithTitle:@"选择板块" leftDataArray:platespiker rightData:@[] componenttitle:@"" dataArraytitle:@""];
        [self.navigationController presentViewController:vc animated:NO completion:nil];
        
        
        vc.getPickerValue = ^(NSString * _Nonnull compoentString, NSString * _Nonnull titileString) {
            HDTakeVideoModel *locationModel = selfWeak.videodatasArr[selfWeak.currentIndexPath.row];
            locationModel.subtitle = compoentString;
            //刷新cell
            [selfWeak.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:selfWeak.currentIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
            ///更新选中信息
            for (HDPlatesModel *platemodel in selfWeak.platesArray) {
                if ([platemodel.name isEqualToString:compoentString]) {
                    platemodel.isSelected = YES;
                }
            }
        };
    }];
}


///圈子视图
- (void)showCirclesView {
    [SVProgressHUD show];
    @WeakObj(self);
    [HDServicesManager getCirclesDatablock:^(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString) {
        [SVProgressHUD dismiss];
        selfWeak.circlesArray = dic[@"data"];
        NSMutableArray *circlespiker = [NSMutableArray array];
        if (selfWeak.circlesArray.count > 0) {
            for (NSDictionary *circleDic  in selfWeak.circlesArray) {
                [circlespiker addObject:circleDic[@"name"]];
            }
        }
        HDCustomMyPickerViewController *vc = [[HDCustomMyPickerViewController alloc]initWithTitle:@"选择圈子" leftDataArray:circlespiker rightData:@[] componenttitle:@"" dataArraytitle:@""];
        [self.navigationController presentViewController:vc animated:NO completion:nil];
        
        
        vc.getPickerValue = ^(NSString * _Nonnull compoentString, NSString * _Nonnull titileString) {
            HDTakeVideoModel *locationModel = selfWeak.videodatasArr[selfWeak.currentIndexPath.row];
            locationModel.subtitle = compoentString;
            //刷新cell
            [selfWeak.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:selfWeak.currentIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
    }];
}

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
        selfWeak.selectedhuatiIdArr = selectedHuatiIdsArray;
        //刷新话题cell
        HDTakeVideoModel *locationModel = selfWeak.videodatasArr[selfWeak.currentIndexPath.row];
        locationModel.subtitle = huatiStr;
        //刷新cell
        [selfWeak.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:selfWeak.currentIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
}
#pragma mark 发布
-(void)fabubutton:(UIButton*)button {
    if (self.selecfabu == YES) {
        return;
    }
    
    self.selecfabu = YES;
    if (self.textView.text.length <= 0) {
        self.selecfabu = NO;
        return [SVProgressHUD showErrorWithStatus:@"请填写标题"];
    }
    
    if ([self.carModel isEqual:@""] || self.carModel == nil) {
        self.selecfabu = NO;
        return [SVProgressHUD showErrorWithStatus:@"请填车系和车型信息"];
    }
    
    
    
    ///提示操作
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"您创建的公开作品，将被解放行进一步审核，一旦审核通过，将正式发布于公开频道" preferredStyle:UIAlertControllerStyleAlert];
    //确定按钮的风格是默认的
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");

        self.configuration = [[PLSUploaderConfiguration alloc] initWithToken:self.videotoken videoKey:self.videokey https:NO recorder:nil];
        self.shortVideoUploader = [[PLShortVideoUploader alloc] initWithConfiguration:self.configuration];
        self.shortVideoUploader.delegate = self;
        [self.shortVideoUploader uploadVideoFile:[self.url path]];
        

        PLSUploaderConfiguration *confi = [[PLSUploaderConfiguration alloc] initWithToken:self.imagetoken videoKey:self.imagekey https:NO recorder:nil];
        PLShortVideoUploader *videup = [[PLShortVideoUploader alloc] initWithConfiguration:confi];
        videup.delegate = self;
        [videup uploadVideoFile:self.coverImagePath];
    }];

    [alter addAction:sure];
    [self presentViewController:alter animated:YES completion:nil];

    

    
}

- (void)shortVideoUploader:(PLShortVideoUploader * _Nonnull)uploader uploadKey:(NSString * _Nullable)uploadKey uploadPercent:(float)uploadPercent {
    [SVProgressHUD showProgress:uploadPercent status:@"上传中"];
}


- (void)shortVideoUploader:(PLShortVideoUploader * _Nonnull)uploader completeInfo:(PLSUploaderResponseInfo * _Nonnull)info uploadKey:(NSString * _Nonnull)uploadKey resp:(NSDictionary * _Nullable)resp {
    NSLog(@"resp: %@",resp);
    NSLog(@"info: %@",info);
    NSLog(@"uploadKey: %@",uploadKey);
    
    if ([uploadKey isEqualToString:self.videokey]) {
         NSNumber *code = resp[@"code"];
           
           if ([code intValue] == 0) {
               self.videouuid = resp[@"data"][@"uuid"];
           }
        
    }else if ([uploadKey isEqualToString:self.imagekey]) {
        NSNumber *code = resp[@"code"];
        
        if ([code intValue] == 0) {
            self.imageuuid = resp[@"data"][@"uuid"];
        }
    }

    if (self.videouuid.length > 1 && self.imageuuid.length > 1) {
        [self updafuwuqiVideo];
    }
}



-(void)updafuwuqiVideo {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if ([self.locationStr isEqualToString:@"不显示位置"]) {
        dic[@"address"] = @"";
    }else {
        dic[@"address"] = self.locationStr;
    }
    
    dic[@"videoUuid"] = self.videouuid;
    dic[@"coverUuid"] = self.imageuuid;
    
    dic[@"title"] = self.textView.text;
    

    if (self.selectedhuatiIdArr.count > 0) {
        dic[@"tags"] =  self.selectedhuatiIdArr;
    }
    
    
    dic[@"carModel"] = self.carModel;
    dic[@"carKind"] = self.carKind;
    
    
    for (HDPlatesModel *plateModel in self.platesArray) {
        if (plateModel.isSelected) {
            dic[@"plateId"] = plateModel.platesid;
        }
    }
    
    
    @WeakObj(self);
    
    LHDAFHTTPSessionManager *session = [LHDAFHTTPSessionManager manager];
       session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", nil];
       //post 发送json格式数据的时候加上这两句。
       session.requestSerializer = [AFJSONRequestSerializer serializer];
       session.responseSerializer = [AFJSONResponseSerializer serializer];
       session.requestSerializer.timeoutInterval = 15;
       NSString * requestUrl  = [NSString stringWithFormat:@"%@%@",[HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL,UKURL_GET_APP_UPDATE_changjianshi];
   
    [[session POST:requestUrl parameters:dic headers:@{@"Authorization":[HDUkeInfoCenter sharedCenter].userModel.token} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSNumber *code = responseObject[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            self.selecfabu = NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您创建的公开作品，将被解放行进一步审核，一旦审核通过，将正式发布于公开频道" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [selfWeak.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
        }
        NSLog(@"responseObject:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         self.selecfabu = NO;
        NSNumber *state = [HDUkeInfoCenter sharedCenter].userModel.state;
        
        if ([state intValue] == 10) {
            [SVProgressHUD showErrorWithStatus:@"由于您多次违规操作，已被禁用该功能"];
        }else {
            [SVProgressHUD showErrorWithStatus:@"发布失败"];
        }
        
         NSLog(@"error:%@",error);
    }]resume];

    
}

//本地是否有图片
- (BOOL)LocalHaveImage:(NSString*)key {

    //读取本地图片非resource
    NSString *picPath=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),key];
    NSLog(@"查询是否存在 %@",picPath);
    UIImage *img=[[UIImage alloc]initWithContentsOfFile:picPath];

    return img?YES:NO;
}

//将图片保存到本地
- (NSString *)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key {
    //首先,需要获取沙盒路径
    NSString *picPath=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),key];
    NSLog(@"将图片保存到本地  %@",picPath);
    BOOL isHaveImage = [self LocalHaveImage:key];
    if (isHaveImage) {
        NSLog(@"本地已经保存该图片、无需再次存储...");
        return picPath;
    }
    NSData *imgData = UIImageJPEGRepresentation(image,0.5);

    [imgData writeToFile:picPath atomically:YES];
    return picPath;
}
 

//从本地获取图片
-(UIImage*)GetImageFromLocal:(NSString*)key {
     //读取本地图片非resource
     NSString *picPath=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),key];
     NSLog(@"获取图片   %@",picPath);
     UIImage *img=[[UIImage alloc]initWithContentsOfFile:picPath];
     return img;
}

//将图片从本地删除
- (void)RemoveImageToLocalKeys:(NSString*)key {
    NSString *picPath=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),key];
    NSLog(@"将图片从本地删除  %@",picPath);
    [[NSFileManager defaultManager] removeItemAtPath:picPath error:nil];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        return self.videodatasArr.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        return 56;
    }
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        HDTakeVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDTakeVideoCell" forIndexPath:indexPath ];
        cell.model = self.videodatasArr[indexPath.row];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        self.currentIndexPath = indexPath;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //二级页面待完善
        if (indexPath.row == 0) {//话题选择
            [self showHuatiView];
        }else if (indexPath.row == 1) {//板块选择
            [self showPlatesView];
        }else if (indexPath.row == 2) {//车车型选择
            [self showCartypeSeletedView];
        }else if (indexPath.row == 3) {//位置选择
            self.isGetLocation = NO;
            // 1.检查定位服务是否开启
            if ([self checkLocationServiceIsEnabled]) {
                // 2.创建定位管理器：
                [self createCLManager];
            }
        }
        
        
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
    
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    textView.textColor = RGBA(57, 60, 67, 1);
    textView.font = [UIFont systemFontOfSize:14];
    
    if ([text isEqualToString:@""] && range.length > 0) {
        // 删除字符肯定是安全的
        return YES;
    }
    
    if (textView.text.length - range.length + text.length > 30) {
//        [SVProgressHUD showErrorWithStatus:@""]
        return NO;
    }
    return YES;
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
    if (!self.isGetLocation) {
        [SVProgressHUD show];
        @WeakObj(self);
        [HDServicesManager getLocationPOIWithlat:coor2D.latitude lon:coor2D.longitude successHandler:^(NSDictionary * _Nullable dic) {
            NSString *poiKeyword = dic[@"poi"];
            NSString *city = dic[@"city"][@"value"];
            [HDServicesManager getLocationPOIWithCity:city poiKeyword:poiKeyword successHandler:^(NSDictionary * _Nullable dic) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    selfWeak.poisArray = [HDPOIModel mj_objectArrayWithKeyValuesArray:dic[@"pois"]];
                    HDPOISelectedViewController *poiVc = [[HDPOISelectedViewController alloc]init];
                    [selfWeak.navigationController pushViewController:poiVc animated:YES];
                    poiVc.poisArray = selfWeak.poisArray;
                    
                    poiVc.locationBlock = ^(HDPOIModel * _Nonnull model) {
                        NSLog(@"选中POI位置信息为:%@",model.name);
                        selfWeak.locationStr = model.name;
                        HDTakeVideoModel *locationModel = selfWeak.videodatasArr[selfWeak.currentIndexPath.row];
                        locationModel.subtitle = model.name;
                        //刷新cell
                        [selfWeak.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:selfWeak.currentIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    };
                });
            } failedHandler:^(NSString * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }];
        } failedHandler:^(NSString * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            
        }];
        self.isGetLocation = YES;
    }
    /**
     

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
            self.dinweiLable.text = [NSString stringWithFormat:@"%@%@%@",placeMark.locality,placeMark.subLocality,placeMark.name];
        }
    }];

     */
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

- (BOOL)checkLocationServiceIsEnabled{
    // 该方法是类方法，和我们创建的管理器没有关系
    if ([CLLocationManager locationServicesEnabled]) {
        return YES;
    }
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"系统定位尚未打开，请到【设定-隐私】中手动打开" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * tipsAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:tipsAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    return NO;
}

- (UIImage*)getVideoPreViewImage:(NSURL *)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}
@end


