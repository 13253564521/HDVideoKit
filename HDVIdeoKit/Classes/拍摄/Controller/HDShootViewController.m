//
//  HDShootViewController.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/11.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDShootViewController.h"
#import "Macro.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#import "QNRecordingProgress.h"
#import "UIView+QNAnimation.h"
#import "HDEditorViewController.h"
#import "QNFilterPickerView.h"
#import "QNFilterGroup.h"
#import "HDFaceUnityView.h"
#import "QNTextPageControl.h"
#import "HDUkeInfoCenter.h"
#import "HDVideoButton.h"
#import "HDLiveReleaseController.h"


#import "QNTranscodeViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
@interface HDShootViewController ()<PLShortVideoRecorderDelegate,QNFilterPickerViewDelegate,UIGestureRecognizerDelegate,HDFaceUnityViewDelegate,QNTextPageControlDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UIImpactFeedbackGenerator *clickFeedback;
@property (nonatomic, strong) PLShortVideoRecorder *recorder;
@property (nonatomic, strong) UIButton *closeButton;//关闭
@property (nonatomic, strong) UIButton *buguangButton;//闪光灯
@property (nonatomic, strong) UIButton *fanzhuanButton;//后置摄像头
@property (nonatomic, strong) UIButton *texiaoButton;//特效
@property (nonatomic, strong) UIButton *meiyanButton;//美颜
@property (nonatomic, strong) HDVideoButton *recordingButton;//录制视频按钮
@property (nonatomic, strong) UILabel *durationLabel;//录制时间显示
@property (nonatomic, strong) UIButton *nextButton;//下一步

@property (nonatomic, strong) UILabel *filterNameLabel;//滤镜label
@property (nonatomic, strong) UILabel *filterDetailLabel;//滤镜label
@property (nonatomic, strong) UIButton *bendishangchuan;//本地上传按钮

// 辅助隐藏音乐选取和滤镜选取 view 的 buttom
@property (nonatomic, strong) UIButton *dismissButton;

@property (nonatomic, strong) QNRecordingProgress *recordingProgress;//拍摄进度条
@property (nonatomic, strong) QNFilterPickerView *filterPickerView;
@property (nonatomic, weak)   QNFilterGroup *filterGroup;


@property (nonatomic, strong) HDFaceUnityView *faceUnityView;//美颜View


// 切换滤镜的时候，为了更好的用户体验，添加以下属性来做切换动画
@property (nonatomic, assign) BOOL isPanning;
@property (nonatomic, assign) BOOL isLeftToRight;
@property (nonatomic, assign) BOOL isNeedChangeFilter;
@property (nonatomic, weak) PLSFilter *leftFilter;
@property (nonatomic, weak) PLSFilter *rightFilter;
@property (nonatomic, assign) float leftPercent;


@property (nonatomic, assign) BOOL isshowface;

@property (nonatomic, strong) QNTextPageControl *captureModeControl;

@property (nonatomic, strong) AVCaptureDevice *device;

//@property (nonatomic, assign) int length;
@property (nonatomic,strong) NSArray *lengthArr;
@property (nonatomic,strong) NSMutableArray *titleArrs;
@end

@implementation HDShootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *videoLength = [HDUkeInfoCenter sharedCenter].userModel.videoLength;
    NSArray *array = [videoLength componentsSeparatedByString:@","];
//    self.lengthArr = @[@(10),@(0)];//array;   //测试
//    [HDUkeInfoCenter sharedCenter].userModel.liveVideo = 1; //测试
    self.titleArrs = [NSMutableArray array];
    
    [self.titleArrs addObject:@"拍照"];
    //测试
//    [self.titleArrs addObject:@"拍10秒"];
    for (NSString *st in array) {
        [self.titleArrs addObject:[NSString stringWithFormat:@"拍%@秒",st]];
    }
    
    if ([HDUkeInfoCenter sharedCenter].userModel.liveVideo == 1) {
        [self.titleArrs addObject:@"直播"];
    }
   
    [self setupUI];
    
    [HDUkeInfoCenter sharedCenter].userModel.xiangceindex = [HDUkeInfoCenter sharedCenter].userModel.xiangceindex + 1;
    
    
    if ([HDUkeInfoCenter sharedCenter].userModel.xiangceindex > 1) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (status != AVAuthorizationStatusAuthorized) {
           UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"当前没有开通相机权限，请到设置界面开通" preferredStyle:UIAlertControllerStyleAlert];

           UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
               [self.navigationController popViewControllerAnimated:YES];
           }];
           [alertVc addAction:sureBtn];
           [self presentViewController:alertVc animated:YES completion:nil];
        }
    }
    
  
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.filterPickerView.frame.origin.y < self.view.bounds.size.height) {
        [self.filterPickerView autoLayoutBottomHide:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    [self.recorder startCaptureSession];
    [self showFilterNameLabel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.recorder stopRecording];
    [self.recorder stopCaptureSession];
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;


}

- (void)setupRecorder {
    // 视频参数设置
    PLSVideoConfiguration *videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
//    videoConfiguration.videoSize = videoSize;//编码时的视频分辨率，默认 (480, 854)
    videoConfiguration.sessionPreset = AVCaptureSessionPresetiFrame960x540; //采集的视频的 sessionPreset，默认为 AVCaptureSessionPreset1280x720
    videoConfiguration.videoOrientation = AVCaptureVideoOrientationPortrait;// 竖屏采集
    videoConfiguration.position = AVCaptureDevicePositionFront;// 摄像头选取
    videoConfiguration.videoFrameRate = 30.0;// 帧率，如果相机支持，最大支持 60 帧
//    videoConfiguration.averageVideoBitRate = ;//平均视频编码码率。默认为 1024*1000
    videoConfiguration.videoMaxKeyframeInterval = 3 * videoConfiguration.videoFrameRate;// 关键帧间隔
    videoConfiguration.previewMirrorFrontFacing = YES;// 前置摄像头预览的时候，做镜像处理
    videoConfiguration.streamMirrorFrontFacing = YES;// 前置摄像头采集的数据生成文件的时候，不做镜像处理
    videoConfiguration.previewMirrorRearFacing = NO;// 后置摄像头预览的时候，不做镜像处理
    videoConfiguration.streamMirrorRearFacing = NO;// 后置摄像头采集的数据生成文件的时候，不做镜像处理
    
    
    // 音频参数设置
    PLSAudioConfiguration *audioConfiguration = [PLSAudioConfiguration defaultConfiguration];
//    audioConfiguration.numberOfChannels = [self getAudioChannels];采集音频数据的声道数，默认为 1
    audioConfiguration.bitRate = PLSAudioBitRate_64Kbps;//音频编码码率 bitRate 默认为 PLSAudioBitRate_128Kbps
    audioConfiguration.sampleRate = PLSAudioSampleRate_44100Hz;//音频采样率 sampleRate 默认为 PLSAudioSampleRate_44100Hz
    
    self.recorder = [[PLShortVideoRecorder alloc] initWithVideoConfiguration:videoConfiguration audioConfiguration:audioConfiguration];
    self.recorder.delegate = self;
    
    NSString *str = self.lengthArr.firstObject;
    self.recorder.maxDuration = [str intValue]; // 设置最大录制时长为 15s
    self.recorder.minDuration = 3; // 设置最小录制时长为 3s
    
    // 如果设置为 YES，在录制的状态下进入后台，回到前台的时候，自动开始录制
    self.recorder.backgroundMonitorEnable = NO;
    
    // 如果设置为 YES，会根据手机方向，自动确定录制的视频是横屏还是竖屏，类似系统自带相机
    self.recorder.adaptationRecording = NO;
    
    // SDK 自带美颜设置
    [self.recorder setBeautifyModeOn:YES];
    [self.recorder setBeautify:0.3];
    
    [self.view insertSubview:self.recorder.previewView atIndex:0];
    [self.recorder.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


-(void)setupUI {
    
    UIView *backView = [[UIView alloc]init];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.recordingProgress = [[QNRecordingProgress alloc] initWithFrame:CGRectMake(16, GS_StatusBarHeight + 24, self.view.bounds.size.width - 16 * 32, 4)];
    self.recordingProgress.layer.cornerRadius = 3;
    self.recordingProgress.clipsToBounds = YES;
    [backView addSubview:self.recordingProgress];

    
    self.closeButton = [[UIButton alloc]init];
    [self.closeButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_back_paishe")] forState:0];
    [self.closeButton  addTarget:self action:@selector(closeButtonDidEvent) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.closeButton];
    
    self.buguangButton = [[UIButton alloc]init];
    [self.buguangButton setTitle:@"闪光灯" forState:UIControlStateNormal];
    [self.buguangButton setTitle:@"闪光灯" forState:UIControlStateSelected];
    self.buguangButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.buguangButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buguangButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.buguangButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_deng_0")] forState:0];
    [self.buguangButton setImage:[UIImage imageNamed:HDBundleImage(@"mine/icon_deng_1")] forState:UIControlStateSelected];
    [self.buguangButton  addTarget:self action:@selector(buguangButtonDidEvent:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.buguangButton];
    
    
    self.fanzhuanButton = [[UIButton alloc]init];
    [self.fanzhuanButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_camero")] forState:0];
    [self.fanzhuanButton setTitle:@"翻转" forState:UIControlStateNormal];
    self.fanzhuanButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.fanzhuanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.fanzhuanButton  addTarget:self action:@selector(fanzhuanButtonDidEvent:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.fanzhuanButton];
    
    
    self.texiaoButton = [[UIButton alloc]init];
    [self.texiaoButton setTitle:@"特效" forState:UIControlStateNormal];
    self.texiaoButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.texiaoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.texiaoButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_texiao")] forState:0];
    [self.texiaoButton  addTarget:self action:@selector(texiaoButtonDidEvent) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.texiaoButton];
    
    self.meiyanButton = [[UIButton alloc]init];
    [self.meiyanButton setTitle:@"美颜" forState:UIControlStateNormal];
    self.meiyanButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.meiyanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.meiyanButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_beauty")] forState:UIControlStateNormal];
    [self.meiyanButton  addTarget:self action:@selector(meiyanButtonDidEvent:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.meiyanButton];
    
    self.bendishangchuan = [[UIButton alloc]init];
    [self.bendishangchuan setTitle:@"本地上传" forState:UIControlStateNormal];
    self.bendishangchuan.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.bendishangchuan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bendishangchuan setImage:[UIImage imageNamed:HDBundleImage(@"video/icon_upload")] forState:0];
    [self.bendishangchuan addTarget:self action:@selector(bendichanghcun:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.bendishangchuan];
    
    // 录制模式
    self.captureModeControl = [[QNTextPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 62, CGRectGetWidth(self.view.frame), 54)];

    self.captureModeControl.titles = self.titleArrs;
    self.captureModeControl.delegate = self;
    self.captureModeControl.selectedIndex = 1;
    [self.view addSubview:_captureModeControl];
    
    CGFloat recordingButtonWH = 84;
    self.recordingButton = [[HDVideoButton alloc]initWithFrame:CGRectMake(self.view.center.x - recordingButtonWH * 0.5, self.captureModeControl.frame.origin.y - 5 - recordingButtonWH, recordingButtonWH, recordingButtonWH)];
    [self.recordingButton  addTarget:self action:@selector(clickRecordingButton:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.recordingButton];

    


    
    self.durationLabel = [[UILabel alloc] init];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    self.durationLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
    self.durationLabel.textColor = [UIColor whiteColor];
    [backView addSubview:self.durationLabel];
    

    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:0];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_common_normal_bg")] forState:UIControlStateNormal];
    self.nextButton.hidden = YES;
    [self.nextButton setTitle:@"下一步" forState:(UIControlStateNormal)];
    [self.nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [backView addSubview:self.nextButton];

    [self.recordingProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(backView).offset(-10);
        make.centerX.equalTo(backView);
        make.top.equalTo(self.mas_topLayoutGuide).offset(5);
        make.height.mas_equalTo(5);
    }];
    

    [self.captureModeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-24);
        make.height.mas_equalTo(54);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView).offset(16);
        make.top.mas_equalTo(backView).offset(34 + GS_StatusBarHeight);
    }];
    
    [self.fanzhuanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeButton.mas_bottom).offset(30);
        make.right.equalTo(backView.mas_right).offset(-20);
        make.height.mas_equalTo(47);
    }];
    
    [self.buguangButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fanzhuanButton.mas_bottom).offset(24);
        make.centerX.mas_equalTo(self.fanzhuanButton.mas_centerX);
        make.height.mas_equalTo(47);
    }];
    [self.texiaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buguangButton.mas_bottom).offset(24);
        make.right.equalTo(backView.mas_right).offset(-20);
        make.height.mas_equalTo(47);
    }];
    
    [self.meiyanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.texiaoButton.mas_bottom).offset(24);
        make.right.equalTo(backView.mas_right).offset(-20);
        make.height.mas_equalTo(47);
    }];
    

    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recordingButton.mas_centerX);
        make.bottom.equalTo(self.recordingButton.mas_top).offset(-5);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordingButton.mas_top).offset(9);
        make.left.equalTo(self.recordingButton.mas_right).offset(25);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(66);
    }];
    
    [self.bendishangchuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordingButton.mas_top).offset(18);
        make.right.equalTo(self.recordingButton.mas_left).offset(-48);
        make.height.mas_equalTo(50);

    }];
    

    //设置按钮 上下 布局
    [self changeButtonType:self.fanzhuanButton];
    [self changeButtonType:self.buguangButton];
    [self changeButtonType:self.texiaoButton];
    [self changeButtonType:self.meiyanButton];
    [self changeButtonType:self.bendishangchuan];
    
    [self setupRecorder];
    //添加滤镜View
    [self setupFilter];
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}


- (void)setupFilter {
    if (!self.filterPickerView) {
        self.filterPickerView = [[QNFilterPickerView alloc] initWithFrame:CGRectZero hasTitle:NO];
        self.filterPickerView.delegate = self;
        self.filterPickerView.hidden = YES;
        [self.view addSubview:self.filterPickerView];
        
        [self.filterPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.top.equalTo(self.mas_bottomLayoutGuide).offset(-self.filterPickerView.minViewHeight);
        }];
        self.filterGroup = self.filterPickerView.filterGroup;
    }

//    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleFilterPan:)];
//    panGesture.delegate = self;
//    [self.view addGestureRecognizer:panGesture];
    
    self.filterNameLabel = [[UILabel alloc] init];
    self.filterNameLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
    self.filterNameLabel.font = [UIFont systemFontOfSize:30];
    self.filterNameLabel.text = [self.filterGroup.filtersInfo[0] objectForKey:@"name"];
    
    self.filterDetailLabel = [[UILabel alloc] init];
    self.filterDetailLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    self.filterDetailLabel.font = [UIFont systemFontOfSize:12];
//    self.filterDetailLabel.text = @"<<左右滑动切换滤镜>>";
    
    [self.view addSubview:self.filterNameLabel];
    [self.view addSubview:self.filterDetailLabel];
    [self.filterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.centerY.equalTo(self.view).offset(-50);
    }];
    [self.filterDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.filterNameLabel);
        make.top.equalTo(self.filterNameLabel.mas_bottom).offset(2);
    }];
}

- (void)hideRecordingControl {
    [self.recordingButton alphaHideAnimation];
    [self.durationLabel alphaHideAnimation];
    [self.captureModeControl alphaHideAnimation];
    [self.bendishangchuan alphaHideAnimation];

}

- (void)showRecordingControl {
    [self.recordingButton alphaShowAnimation];
    [self.durationLabel alphaShowAnimation];
    [self.captureModeControl alphaShowAnimation];
    [self.bendishangchuan alphaShowAnimation];

}

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_dismissButton addTarget:self action:@selector(clickDismissPickerViewButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _dismissButton;
}

#pragma mark - 更新 UI

- (void)updateUIToRecording {
    [self.recordingProgress setLastProgressToStyle:(QNProgressStyleNormal)];
    [self.recordingProgress addProgressView];
    [self.recordingProgress startShining];
    

    [self.buguangButton alphaHideAnimation];
    [self.fanzhuanButton alphaHideAnimation];
    [self.texiaoButton alphaHideAnimation];
    [self.meiyanButton alphaHideAnimation];
    [self.bendishangchuan alphaHideAnimation];
}

- (void)updateUIToNormal {
    [self.recordingProgress stopShining];
    
    [self.recordingButton startRecording:NO];
    [self.buguangButton alphaShowAnimation];
    [self.fanzhuanButton alphaShowAnimation];
    [self.texiaoButton alphaShowAnimation];
    [self.meiyanButton alphaShowAnimation];
    [self.bendishangchuan alphaShowAnimation];
    
}

#pragma mark -关闭事件
- (void)closeButtonDidEvent {
    if (self.recorder.isRecording) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"拍摄正在继续，确定退出吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.recorder stopRecording];
            [self.navigationController popViewControllerAnimated:YES];
        }];

        [alert addAction:cancleAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -闪光灯事件
- (void)buguangButtonDidEvent:(UIButton *)button {

      AVCaptureDevice *device = self.device;
      
//    if (self.device.position == AVCaptureDevicePositionFront) {
//        [self.view makeToast:@"补光灯开启失败" duration:2 position:CSToastPositionCenter];
//        button.selected = NO;
//        return;
//    }
      //修改前必须先锁定
      [self.device lockForConfiguration:nil];
      //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
      if ([self.device hasFlash]) {
          
          if (self.device.flashMode == AVCaptureFlashModeOff) {
              button.selected = YES;
              self.device.flashMode = AVCaptureFlashModeOn;
              self.device.torchMode = AVCaptureTorchModeOn;
          } else if (self.device.flashMode == AVCaptureFlashModeOn) {
              button.selected = NO;
              self.device.flashMode = AVCaptureFlashModeOff;
              self.device.torchMode = AVCaptureTorchModeOff;
          }
          
      }else{
          [self.view makeToast:@"补光灯开启失败" duration:2 position:CSToastPositionCenter];
          button.selected = NO;
      }
      [device unlockForConfiguration];
}

#pragma mark -后置摄像头事件
- (void)fanzhuanButtonDidEvent:(UIButton *)button {
    if (self.recorder.isRecording) return;
    
    button.enabled = NO;
    @WeakObj(self);
    [self.recorder toggleCamera:^(BOOL isFinish) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isFinish) {
                [selfWeak.view makeToast:@"镜头翻转失败" duration:2 position:CSToastPositionCenter];
            }
            button.enabled = YES;
        });
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.faceUnityView.frame.origin.y < self.view.frame.size.height) {
        if (self.recorder.isRecording) {
            return;
        }
        if (self.isshowface == NO) {
            self.isshowface = YES;
            [UIView animateWithDuration:0.25 animations:^{
                       self.faceUnityView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                       self.isshowface = NO;
                        [self showRecordingControl];
            }];
        }
        
       
    }
}

#pragma mark -特效事件
- (void)texiaoButtonDidEvent {
    self.filterPickerView.hidden = NO;

    if (self.filterPickerView.frame.origin.y >= self.view.bounds.size.height) {
        [self.view addSubview:self.dismissButton];
        [self.dismissButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.bottom.equalTo(self.filterPickerView.mas_top);
        }];
        [self.view bringSubviewToFront:self.filterPickerView];
        [self.filterPickerView autoLayoutBottomShow:YES];
        [self hideRecordingControl];
    }
}

- (void)clickDismissPickerViewButton:(UIButton *)button {
    [button removeFromSuperview];
    if (self.filterPickerView.frame.origin.y < self.view.bounds.size.height) {
        [self.filterPickerView autoLayoutBottomHide:YES];
    }

    [self showRecordingControl];
//    [self.recordingButton alphaShowAnimation];
//    [self.durationLabel alphaShowAnimation];
    

}

#pragma mark -美颜事件
- (void)meiyanButtonDidEvent:(UIButton *)button {

//    button.enabled = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//           button.enabled = YES;
//    });
    
    if (!self.faceUnityView.superview) {
        self.faceUnityView = [[HDFaceUnityView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.bounds.size.width, 243 - GS_TabbarSafeBottomMargin)];
        [self.view addSubview:self.faceUnityView];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self hideRecordingControl];
        self.faceUnityView.transform = CGAffineTransformMakeTranslation(0, -(243 - GS_TabbarSafeBottomMargin));
    } completion:^(BOOL finished) {
        self.faceUnityView.delegate = self;
    }];
}

#pragma mark -本地上传
-(void)bendichanghcun:(UIButton *)button {

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    
    QNTranscodeViewController *transcodeController = [[QNTranscodeViewController alloc] init];
    transcodeController.phAsset = asset;
//    transcodeController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:transcodeController animated:YES];
//    [self presentViewController:transcodeController animated:YES completion:nil];
//    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
//    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];

//    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetLowQuality success:^(NSString *outputPath) {
//        // NSData *data = [NSData dataWithContentsOfFile:outputPath];
//        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
//        // Export completed, send video here, send by outputPath or NSData
//        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
//    } failure:^(NSString *errorMessage, NSError *error) {
//        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
//    }];

}


#pragma mark -编辑事件
- (void)clickNextButton:(UIButton *)button {
    if ([self.recorder getTotalDuration] < self.recorder.minDuration) {
        NSString *str = [NSString stringWithFormat:@"请至少拍摄 %d 秒的视频", (int)self.recorder.minDuration];
        [SVProgressHUD showErrorWithStatus:str];

        return;
    }
    
    AVAsset *asset = self.recorder.assetRepresentingAllFiles;
    [self playEvent:asset];
}

#pragma mark - 手势的响应事件
- (void)handleFilterPan:(UIPanGestureRecognizer *)gestureRecognizer {

    CGPoint transPoint = [gestureRecognizer translationInView:gestureRecognizer.view];
    CGPoint speed = [gestureRecognizer velocityInView:gestureRecognizer.view];

    switch (gestureRecognizer.state) {
            
        /*!
         手势开始的时候，根据手势的滑动方向，确定切换到下一个滤镜的索引值
             */
        case UIGestureRecognizerStateBegan: {
            NSInteger index = 0;
            if (speed.x > 0) {
                self.isLeftToRight = YES;
                index = self.filterGroup.filterIndex - 1;
            } else {
                index = self.filterGroup.filterIndex + 1;
                self.isLeftToRight = NO;
            }
            
            if (index < 0) {
                index = self.filterGroup.filtersInfo.count - 1;
            } else if (index >= self.filterGroup.filtersInfo.count) {
                index = index - self.filterGroup.filtersInfo.count;
            }
            self.filterGroup.nextFilterIndex = index;
            
            if (self.isLeftToRight) {
                self.leftFilter = self.filterGroup.nextFilter;
                self.rightFilter = self.filterGroup.currentFilter;
                self.leftPercent = 0.0;
            } else {
                self.leftFilter = self.filterGroup.currentFilter;
                self.rightFilter = self.filterGroup.nextFilter;
                self.leftPercent = 1.0;
            }
            self.isPanning = YES;
            
            break;
        }
            
        /*!
         手势变化的过程中，根据滑动的距离来确定两个滤镜所占的百分比
             */
        case UIGestureRecognizerStateChanged: {
            if (self.isLeftToRight) {
                if (transPoint.x <= 0) {
                    transPoint.x = 0;
                }
                self.leftPercent = transPoint.x / gestureRecognizer.view.bounds.size.width;
                self.isNeedChangeFilter = (self.leftPercent >= 0.5) || (speed.x > 500 );
            } else {
                if (transPoint.x >= 0) {
                    transPoint.x = 0;
                }
                self.leftPercent = 1 - fabs(transPoint.x) / gestureRecognizer.view.bounds.size.width;
                self.isNeedChangeFilter = (self.leftPercent <= 0.5) || (speed.x < -500);
            }
            break;
        }
            
        /*!
         手势结束的时候，根据滑动距离，判断是否切换到下一个滤镜，并且做一下切换的动画
             */
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            gestureRecognizer.enabled = NO;
            
            // 做一个滤镜过渡动画，优化用户体验
            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC, 0.005 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(timer, ^{
                if (!self.isPanning) return;
                
                float delta = 0.03;
                if (self.isNeedChangeFilter) {
                    // apply filter change
                    if (self.isLeftToRight) {
                        self.leftPercent = MIN(1, self.leftPercent + delta);
                    } else {
                        self.leftPercent = MAX(0, self.leftPercent - delta);
                    }
                } else {
                    // cancel filter change
                    if (self.isLeftToRight) {
                        self.leftPercent = MAX(0, self.leftPercent - delta);
                    } else {
                        self.leftPercent = MIN(1, self.leftPercent + delta);
                    }
                }
                
                if (self.leftPercent < FLT_EPSILON || fabs(1.0 - self.leftPercent) < FLT_EPSILON) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dispatch_source_cancel(timer);
                        if (self.isNeedChangeFilter) {
                            self.filterGroup.filterIndex = self.filterGroup.nextFilterIndex;
                            self.filterNameLabel.text = [self.filterGroup.filtersInfo[self.filterGroup.filterIndex] objectForKey:@"name"];
                            [self showFilterNameLabel];
                            [self.filterPickerView updateSelectFilterIndex];
                        }
                        self.isPanning = NO;
                        self.isNeedChangeFilter = NO;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            gestureRecognizer.enabled = YES;
                        });
                    });
                }
            });
            dispatch_resume(timer);
            break;
        }
            
        case UIGestureRecognizerStatePossible: {
            NSLog(@"UIGestureRecognizerStatePossible");
        } break;
        
        default:
            break;
    }
}

#pragma mark - 显示/隐藏 滤镜名称

- (void)showFilterNameLabel {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFilterNameLabel) object:nil];
    [self.filterNameLabel alphaShowAnimation];
    [self.filterDetailLabel alphaShowAnimation];
    [self performSelector:@selector(hideFilterNameLabel) withObject:nil afterDelay:2];
}

- (void)hideFilterNameLabel {
    [self.filterDetailLabel alphaHideAnimation];
    [self.filterNameLabel alphaHideAnimation];
}

- (void)playEvent:(AVAsset *)asset {
    __block AVAsset *movieAsset = asset;
    __block NSArray *urls = [self.recorder getAllFilesURL];
    
    // =========================== goto editer controller ==========================
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    plsMovieSettings[PLSAssetKey] = movieAsset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self.recorder getTotalDuration]];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    HDEditorViewController *editorViewController = [[HDEditorViewController alloc] init];
    editorViewController.settings = outputSettings;
    editorViewController.fileURLArray = urls;
    editorViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:editorViewController animated:YES];
}

#pragma mark -录制视频事件
- (void)clickRecordingButton:(UIButton *)button {
    
    NSString *str = self.titleArrs[self.captureModeControl.selectedIndex];
    
    
    if ([str isEqualToString:@"拍照"]) {
        self.recordingButton.enabled = NO;
        [self.recorder getScreenShotWithCompletionHandler:^(UIImage * _Nullable image) {
            button.enabled = YES;
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [SVProgressHUD showSuccessWithStatus:@"照片已保存到相册"];

        }];
    }else if ([str isEqualToString:@"直播"]) {
        HDLiveReleaseController *vc =[[HDLiveReleaseController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        if (self.recorder.isRecording) {
            [self.recordingButton startRecording:NO];
            [self.recorder stopRecording];
        } else {
            [self.recordingButton startRecording:YES];
            [self.recorder startRecording];
            self.captureModeControl.hidden = YES;
        }
    }

}
#pragma mark - PLShortVideoRecorderDelegate
// 为了优化体验，建议开发者在使用七牛短视频 SDK 之前，都先将相机、麦克风和相册访问权限申请好
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didGetCameraAuthorizationStatus:(PLSAuthorizationStatus)status {
    if (PLSAuthorizationStatusAuthorized == status) {
        [self.recorder startCaptureSession];
    }
}

- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didGetMicrophoneAuthorizationStatus:(PLSAuthorizationStatus)status {
    if (PLSAuthorizationStatusAuthorized == status) {
        [self.recorder startCaptureSession];
    }
}

//摄像头对焦位置的回调
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didFocusAtPoint:(CGPoint)point {
    [self showFilterNameLabel];
}

//获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
- (CVPixelBufferRef __nonnull)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder cameraSourceDidGetPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer timingInfo:(CMSampleTimingInfo)timingInfo {
    // 进行滤镜处理
     if (self.isPanning) {
         // 正在滤镜切换过程中，使用 processPixelBuffer:leftPercent:leftFilter:rightFilter 做滤镜切换动画
         pixelBuffer = [self.filterGroup processPixelBuffer:pixelBuffer leftPercent:self.leftPercent leftFilter:self.leftFilter rightFilter:self.rightFilter];
         NSLog(@"1111%@",pixelBuffer);
     } else {
         // 正常滤镜处理
         pixelBuffer = [self.filterGroup.currentFilter process:pixelBuffer];
         NSLog(@"22222%@",pixelBuffer);
     }
    
    return pixelBuffer;
}

// 开始录制一段视频时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didStartRecordingToOutputFileAtURL:(NSURL *)fileURL {
    NSLog(@"start recording fileURL: %@", fileURL);
    [self updateUIToRecording];
}

// 正在录制的过程中
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    [self.recordingProgress setLastProgressToWidth:fileDuration / self.recorder.maxDuration * self.recordingProgress.frame.size.width];
    self.durationLabel.text = [NSString stringWithFormat:@"%0.1f s", MAX(0, totalDuration)];

}

// 删除了某一段视频
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didDeleteFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    
    self.nextButton.hidden = NO;
    self.durationLabel.text = [NSString stringWithFormat:@"%0.1f s", MAX(0, totalDuration)];

    if (totalDuration == 0 || [self.recorder getFilesCount] == 0) {
        self.captureModeControl.hidden = NO;
        self.durationLabel.hidden = YES;
    } else{
        self.captureModeControl.hidden = YES;
        self.durationLabel.hidden = NO;
    }
    
    if (totalDuration > self.recorder.minDuration) {
        self.nextButton.hidden = NO;
    } else{
        self.nextButton.hidden = YES;
    }
 
}


// 完成一段视频的录制时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    
    if (totalDuration > self.recorder.minDuration) {
        self.nextButton.hidden = NO;
    } else{
        self.nextButton.hidden = YES;
    }
    
    [self updateUIToNormal];
    
    self.durationLabel.text = [NSString stringWithFormat:@"%0.1f s", MAX(0, totalDuration)];
}

// 在达到指定的视频录制时间 maxDuration 后，如果再调用 [PLShortVideoRecorder startRecording]，直接执行该回调
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingMaxDuration:(CGFloat)maxDuration {
    
    AVAsset *asset = self.recorder.assetRepresentingAllFiles;
    [self playEvent:asset];
    self.recordingButton.selected = NO;
}

// QNFilterPickerViewDelegate 通过 collectionView 选择滤镜回调
- (void)filterView:(QNFilterPickerView *)filterView didSelectedFilter:(NSString *)colorImagePath {
    self.filterNameLabel.text = [self.filterGroup.filtersInfo[self.filterGroup.filterIndex] objectForKey:@"name"];
    [self showFilterNameLabel];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSMutableArray *classArray = [[NSMutableArray alloc] init];
    UIView *view = touch.view;
    while (view) {
        [classArray addObject:NSStringFromClass(view.class)];
        view = view.superview;
    }
//    if ([classArray containsObject:NSStringFromClass(QNFaceUnityView.class)]) return NO;
    if ([classArray containsObject:NSStringFromClass(QNFilterPickerView.class)]) return NO;
//    if ([classArray containsObject:NSStringFromClass(QNMusicPickerView.class)]) return NO;
    
    return YES;
}

#pragma mark - QNTextPageControlDelegate

- (void)textPageControl:(QNTextPageControl *)textPageControl didSelectedWithIndex:(NSInteger)selectedIndex {
//    if (selectedIndex == 0) {
//        [self.recordingButton setImage:[UIImage imageNamed:@"qn_video"] forState:UIControlStateNormal];
//        [self.recordingButton setImage:[UIImage imageNamed:@"qn_video_selected"] forState:UIControlStateSelected];
//    } else{
//        [self.recordingButton setImage:[UIImage imageNamed:@"qn_photo"] forState:UIControlStateNormal];
//        [self.recordingButton setImage:[UIImage imageNamed:@"qn_photo"] forState:UIControlStateSelected];
//    }
    
    BOOL needHidden = selectedIndex == 0 ? YES : NO;
    self.recordingProgress.hidden = needHidden;
    self.nextButton.hidden = YES;
    
    NSString *str = self.titleArrs[selectedIndex];
    NSLog(@"%@",str);

    if ([str isEqualToString:@"直播"] || [str isEqualToString:@"拍照"]) {
        
    }else {
//        if (selectedIndex != 0) {
           NSString *st = self.lengthArr[selectedIndex - 1];
            self.recorder.maxDuration = [st intValue];
        NSLog(@"maxDuration:=%f",self.recorder.maxDuration);
//        }
    }

    
}

-(void)faceSetVaule:(float)value type:(HDFaceUnityType)type {
    NSLog(@"type %lu",(unsigned long)type);
    if (type == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定恢复所有美颜效果？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.faceUnityView showNmalSeting];
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.recorder setBeautify:0];
            [self.recorder setWhiten:0];
            [self.recorder setRedden:0];
            [self.faceUnityView resetSeting];
        }];

        [alert addAction:cancleAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];

    }else if (type == 1) {
        [self.recorder setBeautify:value];
    }else if (type == 2) {
         [self.recorder setRedden:value];
    }else if (type == 3) {
        [self.recorder setWhiten:value];
    }
}

#pragma mark - customfunc
//图片在上，文字在下
- (void)changeButtonType:(UIButton *)button {
    CGFloat interval = 2.0;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    CGSize imageSize = button.imageView.bounds.size;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width), 0, 0)];
    CGSize titleSize = button.titleLabel.bounds.size;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + interval, -(titleSize.width))];
}

@end
