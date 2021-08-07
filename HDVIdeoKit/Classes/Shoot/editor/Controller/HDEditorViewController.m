//
//  HDEditorViewController.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/12.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDEditorViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <PLShortVideoKit/PLShortVideoKit.h>
#import "UIView+QNAnimation.h"
#import "QNGradientView.h"
#import "Macro.h"
#import "HDshangchuanViewController.h"
#import "QNEditorDrawStickerView.h"
#import "QNDrawView.h"
#import "QNTextInputView.h"
#import "QNStickerOverlayView.h"
#import "QNGIFStickerView.h"
#import "QNEditorTextStickerView.h"

@interface HDEditorViewController ()<PLShortVideoEditorDelegate,QNEditorDrawStickerViewDelegate,QNEditorTextStickerViewDelegate,PLSAVAssetExportSessionDelegate,QNTextInputViewDelegate,QNGIFStickerViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) AVAsset *originAsset;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UILabel *playingTimeLabel;
@property (nonatomic, strong) UIProgressView *playingProgressView;
@property (nonatomic, strong) UIView *bottomBarView;


// 最终导出视频的宽高
@property (nonatomic, assign) CGSize outputSize;

// 编辑好之后，导出所用
@property (nonatomic, strong) NSMutableDictionary *outputSettings;
@property (nonatomic, strong) NSMutableDictionary *movieSettings;
@property (nonatomic, strong) NSMutableArray *audioSettingsArray;
@property (nonatomic, strong) NSMutableArray *watermarkSettingsArray;
@property (nonatomic, strong) NSMutableArray *stickerSettingsArray;

// 原视频编辑信息
@property (nonatomic, strong) NSMutableDictionary *originMovieSettings;

// 编辑预览
@property (nonatomic, strong) PLShortVideoEditor *shortVideoEditor;

@property (nonatomic, assign) BOOL isNeedResumeEditing;
// 正在 seeking 的时候，不允许启动播放
@property (nonatomic, assign) BOOL isSeeking;
// 获取时间进度缩略图，多个编辑 view 公用，减小内存使用
@property (nonatomic, strong) NSMutableArray *thumbImageArray;

@property (nonatomic, strong) QNGradientView *topBarView;

// 涂鸦处理
@property (nonatomic, strong) QNEditorDrawStickerView *editorDrawStickerView;
@property (nonatomic, strong) QNDrawView *currnetDrawView;

//GIF 动图处理
@property (nonatomic, strong) QNStickerOverlayView *stickerOverlayView;
@property (nonatomic, strong) QNGIFStickerView *currentStickerView;


// 文字处理
@property (nonatomic, strong) QNEditorTextStickerView *editorTextStickerView;
@property (nonatomic, strong) QNTextInputView *textInputView;

@property (nonatomic, assign) CGPoint loc_in;
@property (nonatomic, nonatomic) CGPoint ori_center;
@property (nonatomic, nonatomic) CGFloat curScale;

@end

@implementation HDEditorViewController

- (void)dealloc {
    self.shortVideoEditor.delegate = nil;
    self.shortVideoEditor = nil;
    NSLog(@"dealloc: %@", [[self class] description]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [self observerUIApplicationStatusForShortVideoEditor];
    
    if (self.isNeedResumeEditing) {
         [self startEditing];
     }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;

    [self removeObserverUIApplicationStatusForShortVideoEditor];
    
    self.isNeedResumeEditing = self.shortVideoEditor.isEditing;
    [self stopEditing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.isNeedResumeEditing = YES;
    
    // 用来演示如何获取视频的分辨率 videoSize
    NSDictionary *movieSettings = self.settings[PLSMovieSettingsKey];
    AVAsset *movieAsset = movieSettings[PLSAssetKey];
    if (!movieAsset) {
        NSURL *movieURL = movieSettings[PLSURLKey];
        movieAsset = [AVAsset assetWithURL:movieURL];
    }
        
    self.outputSize = movieAsset.pls_videoSize;
    self.originAsset = movieAsset;
    
    [self getThumbImage];
    [self setupTopBar];
    [self setupShortVideoEditor];
    [self setupGesture];
}

- (void)setupTopBar {
    self.topBarView = [[QNGradientView alloc] init];
    self.topBarView.gradienLayer.colors = @[(__bridge id)[[UIColor colorWithWhite:0 alpha:.8] CGColor], (__bridge id)[[UIColor clearColor] CGColor]];
    [self.view addSubview:self.topBarView];
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(100);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [backButton setTintColor:UIColor.whiteColor];
    [backButton setImage:[UIImage imageNamed:HDBundleImage(@"navgation/btn_back")] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topBarView addSubview:backButton];
   

    
    self.playingTimeLabel = [[UILabel alloc] init];
    self.playingTimeLabel.textAlignment = NSTextAlignmentRight;
    self.playingTimeLabel.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightRegular)];
    self.playingTimeLabel.textColor = [UIColor lightTextColor];
    [self.topBarView addSubview:self.playingTimeLabel];
    
    self.playingProgressView = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    [self.playingProgressView setTrackTintColor:UIColor.clearColor];
    [self.playingProgressView setProgressTintColor:[UIColor whiteColor]];
    [self.topBarView addSubview:self.playingProgressView];
    
    [self.playingProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBarView.mas_left).offset(16);
        make.right.equalTo(self.topBarView.mas_right).offset(-16);
        make.height.mas_equalTo(4);
        make.top.mas_equalTo(self.topBarView).offset(GS_StatusBarHeight);
    }];
    [self.playingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topBarView.mas_right).offset(-16);
        make.centerY.equalTo(backButton);
    }];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(44);
        make.left.equalTo(self.topBarView).offset(16);
        make.top.mas_equalTo(self.playingProgressView.mas_bottom).offset(6);
    }];
    

//    [UIImage imageNamed:HDBundleImage(@"paishe/icon_deng_0")]
    
    self.bottomBarView = [[UIView alloc]init];
    [self.view addSubview:self.bottomBarView];
    [self.bottomBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(66 + GS_TabbarSafeBottomMargin);
        make.left.right.mas_equalTo(self.view);
    }];
    
    
    UIButton *wenziButton = [[UIButton alloc]init];
    [wenziButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_t")] forState:0];
    [wenziButton addTarget:self action:@selector(wenzididButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBarView addSubview:wenziButton];
    [wenziButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomBarView).offset(13);
        make.left.equalTo(self.bottomBarView.mas_left).offset(18);
    }];
    
    UIButton *tuyaButton = [[UIButton alloc]init];
       [tuyaButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_b")] forState:0];
       [tuyaButton addTarget:self action:@selector(tuyadidButton:) forControlEvents:UIControlEventTouchUpInside];
       [self.bottomBarView addSubview:tuyaButton];
       [tuyaButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(wenziButton.mas_right).offset(29);
           make.bottom.equalTo(wenziButton.mas_bottom);
       }];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 32)];;
    [nextButton setBackgroundImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_common_normal_bg")] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitle:@"完 成" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomBarView addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(66);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.bottomBarView.mas_top);
    }];
    
   
}

#pragma mark - 涂鸦
- (void)tuyadidButton:(UIButton *)button {
   if (!self.editorDrawStickerView) {
        
        self.editorDrawStickerView = [[QNEditorDrawStickerView alloc] initWithVideoDuration:self.originAsset.duration];
        self.editorDrawStickerView.delegate = self;
        self.editorDrawStickerView.hidden = YES;
        [self.view addSubview:self.editorDrawStickerView];
        
        [self.editorDrawStickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.top.equalTo(self.mas_bottomLayoutGuide).offset(-self.editorDrawStickerView.minViewHeight);
        }];

       if (!self.stickerOverlayView) {
           [self setupStickerOverlay];
       }

        // 1. 创建涂鸦
        if (!_currnetDrawView) {
            QNStickerModel *stickerModel = [[QNStickerModel alloc] init];
            stickerModel.startPositionTime = kCMTimeZero;
            stickerModel.endPositiontime = self.originAsset.duration;
            stickerModel.lineWidth = 5.0;
            stickerModel.lineColor = [UIColor whiteColor];
            
            QNDrawView *drawView = [[QNDrawView alloc] initWithFrame:[UIScreen mainScreen].bounds duration:self.originAsset.duration];
            drawView.lineWidth = stickerModel.lineWidth;
            drawView.lineColor = stickerModel.lineColor;
            _currnetDrawView = drawView;
            _currnetDrawView.stickerModel = stickerModel;
            // 2. 添加至stickerOverlayView上
            [self.stickerOverlayView addSubview:_currnetDrawView];
        }
        
        [self.view layoutIfNeeded];
        [self.editorDrawStickerView autoLayoutBottomHide:NO];
        [self.view layoutIfNeeded];
        self.editorDrawStickerView.hidden = NO;
    }
    
    if (!_currnetDrawView.userInteractionEnabled) {
           _currnetDrawView.userInteractionEnabled = YES;
    }
    
    [self entryEditingMode];
    [self stopEditing];
    [self showView:self.editorDrawStickerView update:YES];

    for (UIView *stickerView in self.stickerOverlayView.subviews) {
           if (![stickerView isMemberOfClass:QNTextStickerView.class]) continue;
           for (UIGestureRecognizer *gesture in stickerView.gestureRecognizers) {
               gesture.enabled = YES;
           }
    }
}

- (void)showView:(UIView *)view update:(BOOL)update {
    if (view.frame.origin.y >= self.view.bounds.size.height) {
        [view autoLayoutBottomShow:update];
    }
}


- (void)entryEditingMode {
    [self.topBarView alphaHideAnimation];
    [self.bottomBarView alphaHideAnimation];
}

- (void)exitEditingMode {
    [self.topBarView alphaShowAnimation];
    [self.bottomBarView alphaShowAnimation];
}

- (void)stopEditing {
    if (self.shortVideoEditor.isEditing) {
        [self.shortVideoEditor stopEditing];
    }
    [self.playImageView scaleShowAnimation];
}

- (void)startEditing {
    if (!self.shortVideoEditor.isEditing) {
        [self.shortVideoEditor startEditing];
    }
    [self.playImageView scaleHideAnimation];
}

- (void)setupStickerOverlay {
    if (self.stickerOverlayView) return;
    
    self.stickerOverlayView = [[QNStickerOverlayView alloc] init];
    self.stickerOverlayView.clipsToBounds = YES;
    [self.shortVideoEditor.previewView insertSubview:self.stickerOverlayView atIndex:0];
    
    CGFloat ratioWidth = self.outputSize.width / self.shortVideoEditor.previewView.bounds.size.width;
    CGFloat ratioHeight = self.outputSize.height / self.shortVideoEditor.previewView.bounds.size.height;
    
    
    BOOL isWidthEqualView = NO;
    if (PLSVideoFillModePreserveAspectRatio == self.shortVideoEditor.fillMode) {
        if (ratioWidth > ratioHeight) {
            isWidthEqualView = YES;
        } else {
            isWidthEqualView = NO;
        }
    } else {
        if (ratioWidth > ratioHeight) {
            isWidthEqualView = NO;
        } else {
            isWidthEqualView = YES;
        }
    }
    
#warning 让 stickerOverlayView 的 frame 等于视频画面显示的那一部分，最终生成视频中 GIF 动图的位置才会精确
    if (isWidthEqualView) {
        [self.stickerOverlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.equalTo(self.stickerOverlayView.mas_width).multipliedBy(self.outputSize.height / self.outputSize.width);
        }];
    } else {
        [self.stickerOverlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.view);
//            make.center.equalTo(self.view);
//            make.height.equalTo(self.view);
//            make.width.equalTo(self.stickerOverlayView.mas_height).multipliedBy(self.outputSize.width / self.outputSize.height);
        }];
    }
    
//    [self.editorGIFStickerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(self.view);
//        make.top.equalTo(self.mas_bottomLayoutGuide).offset(-self.editorGIFStickerView.minViewHeight);
//    }];
}



#pragma mark - GIF
- (void)gifdidButton:(UIButton *)button {
    
}

#pragma mark - 文字
- (void)wenzididButton:(UIButton *)button {
    if (!self.editorTextStickerView) {
         
         self.editorTextStickerView = [[QNEditorTextStickerView alloc] initWithThumbImage:self.thumbImageArray videoDuration:self.originAsset.duration];
         self.editorTextStickerView.delegate = self;
         self.editorTextStickerView.hidden = YES;
         [self.view addSubview:self.editorTextStickerView];
         
         [self.editorTextStickerView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.bottom.left.right.equalTo(self.view);
             make.top.equalTo(self.mas_bottomLayoutGuide).offset(-self.editorTextStickerView.minViewHeight);
         }];
         
         if (!self.stickerOverlayView) {
             [self setupStickerOverlay];
         }
         
         self.textInputView = [[QNTextInputView alloc] init];
         self.textInputView.delegate = self;
         [self.view addSubview:self.textInputView];
         
         [self.textInputView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.width.height.equalTo(self.view);
             make.left.equalTo(self.view);
             make.top.equalTo(self.view.mas_bottom);
         }];
         
         [self.view layoutIfNeeded];
         [self.editorTextStickerView autoLayoutBottomHide:NO];
         [self.view layoutIfNeeded];
         self.editorTextStickerView.hidden = NO;
     }
     
     [self entryEditingMode];
     [self stopEditing];
     [self.shortVideoEditor seekToTime:kCMTimeZero completionHandler:nil];
     [self.editorTextStickerView setPlayingTime:kCMTimeZero];
     [self showView:self.editorTextStickerView update:YES];
     
     for (UIView *stickerView in self.stickerOverlayView.subviews) {
         if (![stickerView isMemberOfClass:QNTextStickerView.class]) continue;
         for (UIGestureRecognizer *gesture in stickerView.gestureRecognizers) {
             gesture.enabled = YES;
         }
     }
}

#pragma mark - 完成
- (void)clickNextButton:(UIButton *)button {
    
    [self stopEditing];
    
    // 贴纸信息
      [self.stickerSettingsArray removeAllObjects];
      for (int i = 0; i < self.stickerOverlayView.subviews.count; i++) {
          QNGIFStickerView *stickerView = self.stickerOverlayView.subviews[i];
          QNStickerModel *stickerModel = stickerView.stickerModel;
          
          NSMutableDictionary *stickerSettings = [[NSMutableDictionary alloc] init];
          
          CGAffineTransform transform = stickerView.transform;
          CGFloat widthScale = sqrt(transform.a * transform.a + transform.c * transform.c);
          CGFloat heightScale = sqrt(transform.b * transform.b + transform.d * transform.d);
          CGSize viewSize = CGSizeMake(stickerView.bounds.size.width * widthScale, stickerView.bounds.size.height * heightScale);
          CGPoint viewCenter =  CGPointMake(stickerView.frame.origin.x + stickerView.frame.size.width / 2, stickerView.frame.origin.y + stickerView.frame.size.height / 2);
          CGPoint viewPoint = CGPointMake(viewCenter.x - viewSize.width / 2, viewCenter.y - viewSize.height / 2);
          
          stickerSettings[PLSSizeKey] = [NSValue valueWithCGSize:viewSize];
          stickerSettings[PLSPointKey] = [NSValue valueWithCGPoint:viewPoint];
          
          CGFloat rotation = atan2f(transform.b, transform.a);
          rotation = rotation * (180 / M_PI);
          stickerSettings[PLSRotationKey] = [NSNumber numberWithFloat:rotation];
          
          stickerSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(stickerModel.startPositionTime)];
          stickerSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(CMTimeSubtract(stickerModel.endPositiontime, stickerModel.startPositionTime))];
          /*!
           注意：编辑预览的时候，让 stickerOverlayView 的 frame 等于 视频预览中有视频的那一部分，最终生成的视频中 GIF 动图的位置才会精确,下面举例说明:
           
           前提：
           stickerOverlayView 的 superView = shortVideoEditor.preview
           或者
           stickerOverlayView 的 superView.frame = shortVideoEditor.preview.frame;
           
           比如:
           shortVideoEditor.preview.frame = self.view.bounds = {0, 0, 90, 160};
           在
           shortVideoEditor.fillMode = PLSVideoFillModePreserveAspectRatio;
           的情况下，一个 3:4 的视频在 preview 中有视频画面的部分应该是 {0, 20, 90, 120};
           
           这个时候，将 stickerOverlayView 的 frame 设置为：
           stickerOverlayView.frame = {0, 20, 90, 120};
           
           这样设置，是为了在预览的时候，添加的贴纸的位置和最终生成视频的位置是严格一致的。
           
           上面只是列举了 PLSVideoFillModePreserveAspectRatio 的情形， PLSVideoFillModePreserveAspectRatioAndFill 的情况可以根据上面的方式模仿出来，
           在 @selector(clickGIFButton:) 方法中初始化 stickerOverlayView 的时候，也分别做了 Ratio 和 RatioAndFill 的区别对待，可以参考
           */
          stickerSettings[PLSVideoPreviewSizeKey] = [NSValue valueWithCGSize:self.stickerOverlayView.frame.size];
          
          stickerSettings[PLSVideoOutputSizeKey] = [NSValue valueWithCGSize:self.outputSize];
//
          if ([stickerView isMemberOfClass:QNTextStickerView.class] || [stickerView isMemberOfClass:QNDrawView.class]) {
              stickerView.hidden = NO;
              stickerSettings[PLSStickerKey] = [self convertViewToImage:stickerView];
          } else {
              stickerSettings[PLSStickerKey] = stickerModel.path;
              stickerView.hidden = YES;
          }
          
          [self.stickerSettingsArray addObject:stickerSettings];
      }
    
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    PLSAVAssetExportSession *exportSession = [[PLSAVAssetExportSession alloc] initWithAsset:asset];
    exportSession.outputFileType = PLSFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputSettings = self.outputSettings;
    exportSession.delegate = self;
    exportSession.isExportMovieToPhotosAlbum = NO;
    exportSession.audioChannel = asset.pls_channel;
    
    // 如果音频的码率设置和采样率，声道严重不匹配，会导致导出文件失败，合理的码率设置和声道、采样率的关系见：QNBaseViewController suitableAudioBitrateWithSampleRate:channel
    if (asset.pls_sampleRate > 0) {
        exportSession.audioBitrate = [self suitableAudioBitrateWithSampleRate:asset.pls_sampleRate channel:exportSession.audioChannel];
    } else {
        exportSession.audioBitrate= PLSAudioBitRate_128Kbps;
    }
    
    // 如果视频的帧率超过 60 帧，导出来的视频在 iPhone 设置上播放，会存在问题，建议将帧率限制在 60 帧
    exportSession.outputVideoFrameRate = MIN(60, asset.pls_normalFrameRate);
    
    // 设置视频的码率
    exportSession.bitrate = [self suitableVideoBitrateWithSize:self.outputSize];
    
    // 设置视频的导出分辨率，会将原视频缩放
    exportSession.outputVideoSize = self.outputSize;
    
    // 旋转视频
      //    exportSession.videoLayerOrientation = self.videoLayerOrientation;

    __weak typeof(self) weakSelf = self;
    [exportSession setCompletionBlock:^(NSURL *url) {
        NSLog(@"Asset Export Completed");
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideWating];
            [weakSelf gotoNextController:url];
            button.enabled = YES;
        });
    }];
    
    [exportSession setFailureBlock:^(NSError *error) {
        NSLog(@"Asset Export Failed: %@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideWating];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"导出失败%@",error.description]];
            button.enabled = YES;
        });
    }];
    
    [exportSession setProcessingBlock:^(float progress) {
        // 更新进度 UI
        NSLog(@"Asset Export Progress: %f", progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:progress status:@"完成"];
//            button.enabled = YES;
        });
    }];
    
    [exportSession exportAsynchronously];
    button.enabled = NO;
 
}

- (void)hideWating {

}

- (void)gotoNextController:(NSURL *)url {

     HDshangchuanViewController *vc = [[HDshangchuanViewController alloc]init];
     vc.url = url;
    [self.navigationController pushViewController:vc animated:YES];
}

- (PLSAudioBitRate)suitableAudioBitrateWithSampleRate:(PLSAudioSampleRate)sampleRate channel:(NSInteger)channel {
    
    if (PLSAudioSampleRate_48000Hz == sampleRate ||
        PLSAudioSampleRate_44100Hz == sampleRate) {
        if (1 == channel) {
            return PLSAudioBitRate_64Kbps;
        } else {
            return PLSAudioBitRate_128Kbps;
        }
    } else if (PLSAudioSampleRate_22050Hz == sampleRate) {
        if (1 == channel) {
            return PLSAudioBitRate_32Kbps;
        } else {
            return PLSAudioBitRate_64Kbps;
        }
    } else {
        return PLSAudioBitRate_32Kbps;
    }
    
    return PLSAudioBitRate_64Kbps;
}

- (NSInteger)suitableVideoBitrateWithSize:(CGSize)videoSize {
    
    // 下面的码率设置均偏大，为了拍摄出来的视频更清晰，选择了偏大的码率，不过均比系统相机拍摄出来的视频码率小很多
    if (videoSize.width + videoSize.height > 720 + 1280) {
        return 8 * 1000 * 1000;
    } else if (videoSize.width + videoSize.height > 540 + 960) {
        return 4 * 1000 * 1000;
    } else if (videoSize.width + videoSize.height > 360 + 640) {
        return 2 * 1000 * 1000;
    } else {
        return 1 * 1000 * 1000;
    }
}

#pragma mark - 编辑类

- (void)setupShortVideoEditor {
    // 编辑
    /* outputSettings 中的字典元素为 movieSettings, audioSettings, watermarkSettings, stickerSettingsArray*/
    self.outputSettings = [[NSMutableDictionary alloc] init];
    self.movieSettings = [[NSMutableDictionary alloc] init];
    self.watermarkSettingsArray = [[NSMutableArray alloc] init];
    self.stickerSettingsArray = [[NSMutableArray alloc] init];
    self.audioSettingsArray = [[NSMutableArray alloc] init];
    
    // 视频基本信息 dic，必须有
    self.outputSettings[PLSMovieSettingsKey] = self.movieSettings;
    
    // 水印信息，如果不需要水印，可以不设置
    self.outputSettings[PLSWatermarkSettingsKey] = self.watermarkSettingsArray;
    
    // 静态贴纸、GIF 动态贴纸，文字等设置，如果不需要，可以不设置
    self.outputSettings[PLSStickerSettingsKey] = self.stickerSettingsArray;
    
    // 混音设置，如果不需要混音处理，可以不设置
    self.outputSettings[PLSAudioSettingsKey] = self.audioSettingsArray;
    
    // 原始视频
    [self.movieSettings addEntriesFromDictionary:self.settings[PLSMovieSettingsKey]];
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0];
    
    // 备份原始视频的信息
    self.originMovieSettings = [[NSMutableDictionary alloc] init];
    [self.originMovieSettings addEntriesFromDictionary:self.movieSettings];
    
    
    // 视频编辑类
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    self.shortVideoEditor = [[PLShortVideoEditor alloc] initWithAsset:asset videoSize:CGSizeZero];
    self.shortVideoEditor.delegate = self;
    self.shortVideoEditor.loopEnabled = YES;
    
    if (!CGSizeEqualToSize(CGSizeZero, self.originAsset.pls_videoSize)) {
        CGFloat viewRatio = self.view.bounds.size.width / self.view.bounds.size.height;
        CGFloat videoRatio = self.originAsset.pls_videoSize.width / self.originAsset.pls_videoSize.height;
        if (fabs(viewRatio - videoRatio) < 0.15) {
            // 在视频的宽高比例和 view 的宽高比例很接近的时候，使用 Fill 模式，UI 上看起来漂亮些，类似抖音
            self.shortVideoEditor.fillMode = PLSVideoFillModePreserveAspectRatioAndFill;
        } else {
            self.shortVideoEditor.fillMode = PLSVideoFillModePreserveAspectRatio;
        }
    }
    
    // 要处理的视频的时间区域
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1000, 1000);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1000, 1000);
    self.shortVideoEditor.timeRange = CMTimeRangeMake(start, duration);
    
    // 如果不设置 videoSize，默认按照视频的显示宽高来处理(视频的显示宽高是视频的原始宽高加上旋转角度之后的宽高)
    self.shortVideoEditor.videoSize = self.outputSize;
    
    [self.view insertSubview:self.shortVideoEditor.previewView atIndex:0];
    [self.shortVideoEditor.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImage *playImg = [UIImage imageNamed:HDBundleImage(@"mine/qn_play")];
    self.playImageView = [[UIImageView alloc] initWithImage:playImg];
    [self.shortVideoEditor.previewView addSubview:self.playImageView];
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.shortVideoEditor.previewView);
    }];
}

#pragma mark - UIGestureRecognizerDelegate 手势代理

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSMutableArray *classArray = [[NSMutableArray alloc] init];
    UIView *view = touch.view;
    while (view) {
        [classArray addObject:NSStringFromClass(view.class)];
        view = view.superview;
    }
//    if ([classArray containsObject:NSStringFromClass(QNFilterPickerView.class)]) return NO;
    if ([classArray containsObject:NSStringFromClass(QNGradientView.class)]) return NO;
//    if ([classArray containsObject:NSStringFromClass(QNEditorMusicView.class)]) return NO;
//    if ([classArray containsObject:NSStringFromClass(QNEditorGIFStickerView.class)]) return NO;
//    if ([classArray containsObject:NSStringFromClass(EffectsView.class)])return NO;
//    if ([classArray containsObject:NSStringFromClass(FilterPanelView.class)]) return NO;
//    if ([classArray containsObject:NSStringFromClass(QNAudioVolumeView.class)]) return NO;
//    if ([classArray containsObject:NSStringFromClass(QNMVPickerView.class)]) return NO;
    if ([classArray containsObject:NSStringFromClass(QNEditorTextStickerView.class)]) return NO;
    if ([classArray containsObject:NSStringFromClass(QNTextInputView.class)]) return NO;
    if ([classArray containsObject:NSStringFromClass(QNEditorDrawStickerView.class)]) return NO;
    
    return YES;
}

- (void)setupGesture {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}

- (void)singleTapHandle:(UIGestureRecognizer *)gesture {
    
    if (self.isSeeking) return;

    
    if ([self.shortVideoEditor isEditing]) {
        [self stopEditing];
    } else {
        [self startEditing];
        
        if (_currentStickerView) {
            self.currentStickerView.select = NO;
            if ([self.currentStickerView isMemberOfClass:QNTextStickerView.class]) {
                [self.editorTextStickerView endStickerEditing:self.currentStickerView.stickerModel];
            }
            self.currentStickerView = nil;
        }
    }
}


// 距离
- (CGFloat)getDistance:(CGPoint)pointA withPointB:(CGPoint)pointB {
    CGFloat x = pointA.x - pointB.x;
    CGFloat y = pointA.y - pointB.y;
    
    return sqrt(x*x + y*y);
}

// 角度
- (CGFloat)getRadius:(CGPoint)pointA withPointB:(CGPoint)pointB {
    CGFloat x = pointA.x - pointB.x;
    CGFloat y = pointA.y - pointB.y;
    return atan2(x, y);
}

- (void)hideView:(UIView *)view update:(BOOL)update {
    if (view.frame.origin.y < self.view.bounds.size.height) {
        [view autoLayoutBottomHide:update];
    }
}

- (BOOL)viewIsShow:(UIView *)view {
    return view.frame.origin.y < self.view.bounds.size.height;
}

#pragma mark - 返回

- (void)clickBackButton {
    [SVProgressHUD dismiss];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

// 将 UIView 转换为 图片
- (UIImage *)convertViewToImage:(UIView *)view {
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)getThumbImage {
    self.thumbImageArray = [[NSMutableArray alloc] init];
    
    CGFloat duration = CMTimeGetSeconds(self.originAsset.duration);
    NSUInteger count = duration;
    count = MIN(30, MAX(15, count));
    
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    CGFloat delta = duration / count;
    for (int i = 0; i < count; i ++) {
        CMTime time = CMTimeMake(i * delta * 1000, 1000);
        NSValue *value = [NSValue valueWithCMTime:time];
        [timeArray addObject:value];
    }
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.originAsset];
    generator.requestedTimeToleranceAfter = CMTimeMake(200, 1000);
    generator.requestedTimeToleranceBefore = CMTimeMake(200, 1000);
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(100, 100);
    
    [generator generateCGImagesAsynchronouslyForTimes:timeArray completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (image) {
            [self.thumbImageArray addObject:[UIImage imageWithCGImage:image]];
        }
    }];
}

#pragma mark - PLShortVideoEditorDelegate

// 编辑时处理视频数据，并将加了滤镜效果的视频数据返回
- (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer timestamp:(CMTime)timestamp {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.playingTimeLabel.text = [self formatTimeString:CMTimeGetSeconds(timestamp)];
        self.playingProgressView.progress = CMTimeGetSeconds(timestamp) / CMTimeGetSeconds(self.originAsset.duration);
        
        if ([self viewIsShow:self.editorTextStickerView]) {
            [self.editorTextStickerView setPlayingTime:timestamp];
        }
        
        // 更新文字
        for (int i = 0; i < self.editorTextStickerView.addedStickerModelArray.count; i ++) {
            QNStickerModel *stickerModel = [self.editorTextStickerView.addedStickerModelArray objectAtIndex:i];
            if (CMTimeCompare(stickerModel.startPositionTime, timestamp) <= 0 &&
                CMTimeCompare(stickerModel.endPositiontime, timestamp) >= 0) {
                if (stickerModel.stickerView.isHidden) {
                    stickerModel.stickerView.hidden = NO;
                }
            } else {
                if (!stickerModel.stickerView.isHidden) {
                    stickerModel.stickerView.hidden = YES;
                }
            }
        }
        
    });
    
    return pixelBuffer;

}

- (void)shortVideoEditor:(PLShortVideoEditor *)editor didReadyToPlayForAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange {
    NSLog(@"%s, line:%d", __FUNCTION__, __LINE__);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playImageView scaleHideAnimation];
    });
}

- (void)shortVideoEditor:(PLShortVideoEditor *)editor didReachEndForAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange {
    NSLog(@"%s, line:%d", __FUNCTION__, __LINE__);

}

#pragma mark - QNEditorDrawStickerViewDelegate

- (void)editorDrawStickerViewClear:(QNEditorDrawStickerView *)editorDrawStickerView {
    if ([_currnetDrawView canUndo]) {
        [_currnetDrawView clear];
    }
}

- (void)editorDrawStickerViewCancel:(QNEditorDrawStickerView *)editorDrawStickerView {
    if ([_currnetDrawView canUndo]) {
        [_currnetDrawView undo];
    }
}
- (void)editorDrawStickerViewDone:(QNEditorDrawStickerView *)editorDrawStickerView {
    [self exitEditingMode];
    [self hideView:editorDrawStickerView update:YES];
    if (!self.isSeeking) {
        [self startEditing];
    }
    
    _currnetDrawView.userInteractionEnabled = NO;
    self.currentStickerView.select = NO;
    self.currentStickerView = nil;
    
    for (UIView *stickerView in self.stickerOverlayView.subviews) {
        if (![stickerView isMemberOfClass:QNTextStickerView.class]) continue;
        for (UIGestureRecognizer *gesture in stickerView.gestureRecognizers) {
            gesture.enabled = NO;
        }
    }
}

- (void)editorDrawStickerView:(QNEditorDrawStickerView *)editorDrawStickerView addDrawSticker:(QNStickerModel *)model {
    [self stopEditing];
    // 1. 创建涂鸦
    if (!_currnetDrawView) {
        QNDrawView *drawView = [[QNDrawView alloc] initWithFrame:self.view.frame duration:self.originAsset.duration];
        drawView.lineWidth = model.lineWidth;
        drawView.lineColor = model.lineColor;
        _currnetDrawView = drawView;
        // 2. 添加至stickerOverlayView上
        [self.stickerOverlayView addSubview:_currnetDrawView];
    } else{
        _currnetDrawView.lineWidth = model.lineWidth;
        _currnetDrawView.lineColor = model.lineColor;
    }
    _currnetDrawView.stickerModel = model;
}

#pragma mark - QNTextInputViewDelegate

- (void)textInputCancelEditing:(QNTextInputView *)textInputView {
    [self hideView:self.textInputView update:YES];
}

- (void)textInputView:(QNTextInputView *)textInputView finishEditingWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font {
    [self hideView:self.textInputView update:YES];
    if ([self.currentStickerView isKindOfClass:QNTextStickerView.class]) {
        
        QNTextStickerView *textStickerView = (QNTextStickerView *)self.currentStickerView;
        textStickerView.stickerModel.textColor = textColor;
        textStickerView.stickerModel.font = font;
        
        textStickerView.color = textColor;
        textStickerView.text = text;
        textStickerView.font = font;
    }
}


#pragma mark - QNEditorTextStickerViewDelegate

- (void)editorTextStickerViewWillBeginDragging:(QNEditorTextStickerView *)editorTextStickerView {
    self.isSeeking = YES;
    [self stopEditing];
}

- (void)editorTextStickerViewWillEndDragging:(QNEditorTextStickerView *)editorTextStickerView {
    self.isSeeking = NO;
    if (![self viewIsShow:self.editorTextStickerView]) {
        [self startEditing];
    }
}

- (void)editorTextStickerView:(QNEditorTextStickerView *)editorTextStickerView wantSeekPlayerTo:(CMTime)time {
    [self.shortVideoEditor seekToTime:time completionHandler:^(BOOL finished) {}];
}

- (void)editorTextStickerView:(QNEditorTextStickerView *)editorTextStickerView wantEntryEditing:(QNStickerModel *)model {
    if (model.stickerView != _currentStickerView) {
        [self stopEditing];
        
        [self.editorTextStickerView endStickerEditing:_currentStickerView.stickerModel];
        
        _currentStickerView.select = NO;
        model.stickerView.select = YES;
        _currentStickerView = model.stickerView;
        if (_currentStickerView.hidden) {
            [self.shortVideoEditor seekToTime:model.startPositionTime completionHandler:^(BOOL finished) {
            }];
        }
        
        [self.editorTextStickerView startStickerEditing:_currentStickerView.stickerModel];
    }
}

- (void)editorTextStickerViewDoneButtonClick:(QNEditorTextStickerView *)editorTextStickerView {
    [self exitEditingMode];
    [self hideView:editorTextStickerView update:YES];
    if (!self.isSeeking) {
        [self startEditing];
    }
    
    [self.editorTextStickerView endStickerEditing:self.currentStickerView.stickerModel];
    self.currentStickerView.select = NO;
    self.currentStickerView = nil;
    
    for (UIView *stickerView in self.stickerOverlayView.subviews) {
        if (![stickerView isMemberOfClass:QNTextStickerView.class]) continue;
        for (UIGestureRecognizer *gesture in stickerView.gestureRecognizers) {
            gesture.enabled = NO;
        }
    }
}

- (void)editorTextStickerView:(QNEditorTextStickerView *)editorTextStickerView addTextSticker:(QNStickerModel *)model {
    [self stopEditing];
    
    // 1. 创建贴纸
    QNTextStickerView *stickerView = [[QNTextStickerView alloc] initWithStickerModel:model];
    stickerView.delegate = self;
    
    _currentStickerView.select = NO;
    stickerView.select = YES;
    _currentStickerView = stickerView;
    model.stickerView = stickerView;
    // 2. 添加至stickerOverlayView上
    [self.stickerOverlayView addSubview:stickerView];
    
    CGRect rc = self.stickerOverlayView.bounds;
    stickerView.frame = CGRectMake(50, (rc.size.height - 60) / 2, rc.size.width - 50 * 2, 60);
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGestureRecognizerEvent:)];
    [stickerView addGestureRecognizer:panGes];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerEvent:)];
    [stickerView addGestureRecognizer:tapGes];
    UIPinchGestureRecognizer *pinGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizerEvent:)];
    [stickerView addGestureRecognizer:pinGes];
    [stickerView.dragBtn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scaleAndRotateGestureRecognizerEvent:)]];
    
    [self.editorTextStickerView startStickerEditing:_currentStickerView.stickerModel];
}

// 贴纸的移动处理
- (void)moveGestureRecognizerEvent:(UIPanGestureRecognizer *)panGes {
    
    if ([[panGes view] isKindOfClass:[QNGIFStickerView class]]){
        CGPoint loc = [panGes locationInView:self.view];
        QNGIFStickerView *view = (QNGIFStickerView *)[panGes view];
        if (_currentStickerView.select) {
            if ([_currentStickerView pointInside:[_currentStickerView convertPoint:loc fromView:self.view] withEvent:nil]){
                view = _currentStickerView;
            }
        }
        if (!view.select) return;
        
        if (panGes.state == UIGestureRecognizerStateBegan) {
            _loc_in = [panGes locationInView:self.view];
            _ori_center = view.center;
        }
        
        CGFloat x;
        CGFloat y;
        x = _ori_center.x + (loc.x - _loc_in.x);
        y = _ori_center.y + (loc.y - _loc_in.y);
        
        view.center = CGPointMake(x, y);
        
    }
}

// 点击贴纸事件处理
- (void)tapGestureRecognizerEvent:(UITapGestureRecognizer *)tapGes {
    
    if ([[tapGes view] isMemberOfClass:[QNGIFStickerView class]]){
        
        QNGIFStickerView *view = (QNGIFStickerView *)[tapGes view];
        
        if (view != _currentStickerView) {
//            [self.editorGIFStickerView endStickerEditing:_currentStickerView.stickerModel];
            
            _currentStickerView.select = NO;
            view.select = YES;
            _currentStickerView = view;
            
//            [self.editorGIFStickerView startStickerEditing:_currentStickerView.stickerModel];
        } else {
            view.select = !view.select;
            if (view.select) {
                _currentStickerView = view;
//                [self.editorGIFStickerView startStickerEditing:_currentStickerView.stickerModel];
            }else {
//                [self.editorGIFStickerView endStickerEditing:_currentStickerView.stickerModel];
                _currentStickerView = nil;
            }
        }
    } else if ([[tapGes view] isMemberOfClass:[QNTextStickerView class]]) {
        
        QNTextStickerView *view = (QNTextStickerView *)[tapGes view];
        
        if (view != _currentStickerView) {
            [self.editorTextStickerView endStickerEditing:_currentStickerView.stickerModel];
            
            _currentStickerView.select = NO;
            view.select = YES;
            _currentStickerView = view;
            
            [self.editorTextStickerView startStickerEditing:_currentStickerView.stickerModel];
            
        } else {
            
            if (!view.select) {
                
                view.select = YES;
                _currentStickerView = view;
//                [self.editorGIFStickerView startStickerEditing:_currentStickerView.stickerModel];
                
            } else if (view.select) {
                
                [self stopEditing];
                [self.view bringSubviewToFront:self.textInputView];
                [self.textInputView setFont:_currentStickerView.stickerModel.font textColor:_currentStickerView.stickerModel.textColor];
                [self.textInputView startEditingWithText:view.text];
                [self showView:self.textInputView update:YES];
            }
        }
    }
}

// 缩放贴纸处理
- (void)pinchGestureRecognizerEvent:(UIPinchGestureRecognizer *)pinGes {
    
    if ([[pinGes view] isKindOfClass:[QNGIFStickerView class]]){
        QNGIFStickerView *view = (QNGIFStickerView *)[pinGes view];
        
        if (!view.select) return;
        
        if (pinGes.state ==UIGestureRecognizerStateBegan) {
            view.oriTransform = view.transform;
        }
        
        if (pinGes.state ==UIGestureRecognizerStateChanged) {
            _curScale = pinGes.scale;
            CGAffineTransform tr = CGAffineTransformScale(view.oriTransform, pinGes.scale, pinGes.scale);
            
            view.transform = tr;
        }
        
        // 当手指离开屏幕时,将lastscale设置为1.0
        if ((pinGes.state == UIGestureRecognizerStateEnded) || (pinGes.state == UIGestureRecognizerStateCancelled)) {
            view.oriScale = view.oriScale * _curScale;
            pinGes.scale = 1;
        }
    }
}

// 缩放和旋转贴纸处理
- (void)scaleAndRotateGestureRecognizerEvent:(UIPanGestureRecognizer *)gesture {
    if (_currentStickerView.isSelected) {
        CGPoint curPoint = [gesture locationInView:self.view];
        if (gesture.state == UIGestureRecognizerStateBegan) {
            _loc_in = [gesture locationInView:self.view];
        }
        
        if (gesture.state == UIGestureRecognizerStateBegan) {
            _currentStickerView.oriTransform = _currentStickerView.transform;
        }
        
        // 计算缩放
        CGFloat preDistance = [self getDistance:_loc_in withPointB:_currentStickerView.center];
        CGFloat curDistance = [self getDistance:curPoint withPointB:_currentStickerView.center];
        CGFloat scale = curDistance / preDistance;

        CGFloat currentScale = scale * _currentStickerView.oriScale;
        if (currentScale < 0.2) {
            scale = 0.2 / currentScale;
            curDistance = scale * preDistance;
        }
        
        // 计算弧度
        CGFloat preRadius = [self getRadius:_currentStickerView.center withPointB:_loc_in];
        CGFloat curRadius = [self getRadius:_currentStickerView.center withPointB:curPoint];
        CGFloat radius = curRadius - preRadius;
        radius = - radius;
        CGAffineTransform transform = CGAffineTransformScale(_currentStickerView.oriTransform, scale, scale);
        _currentStickerView.transform = CGAffineTransformRotate(transform, radius);
        
        if (gesture.state == UIGestureRecognizerStateEnded ||
            gesture.state == UIGestureRecognizerStateCancelled) {
            _currentStickerView.oriScale = scale * _currentStickerView.oriScale;
        }
    }
}

#pragma mark - StickerViewDelegate

- (void)stickerViewClose:(QNGIFStickerView *)stickerView {
    [stickerView removeFromSuperview];
    if ([stickerView isMemberOfClass:QNTextStickerView.class]) {
        [self.editorTextStickerView endStickerEditing:stickerView.stickerModel];
        [self.editorTextStickerView  deleteSticker:stickerView.stickerModel];
    } else if ([stickerView isMemberOfClass:QNDrawView.class]) {
        [self.editorTextStickerView endStickerEditing:stickerView.stickerModel];
        [self.editorTextStickerView  deleteSticker:stickerView.stickerModel];
    } else {
//        [self.editorGIFStickerView endStickerEditing:stickerView.stickerModel];
//        [self.editorGIFStickerView  deleteSticker:stickerView.stickerModel];
    }
}

#pragma mark -  PLSAVAssetExportSessionDelegate 合成视频文件给视频数据加滤镜效果的回调
- (CVPixelBufferRef)assetExportSession:(PLSAVAssetExportSession *)assetExportSession didOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer timestamp:(CMTime)timestamp {
    
    CVPixelBufferRef tempPixelBuffer = pixelBuffer;

    return tempPixelBuffer;
}

#pragma mark - 程序的状态监听

- (void)observerUIApplicationStatusForShortVideoEditor {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shortVideoEditorWillResignActiveEvent:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shortVideoEditorDidBecomeActiveEvent:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeObserverUIApplicationStatusForShortVideoEditor {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)shortVideoEditorWillResignActiveEvent:(id)sender {
    NSLog(@"[self.shortVideoEditor UIApplicationWillResignActiveNotification]");
    [self stopEditing];
}

- (void)shortVideoEditorDidBecomeActiveEvent:(id)sender {
    NSLog(@"[self.shortVideoEditor UIApplicationDidBecomeActiveNotification]");
//    [self.shortVideoEditor startEditing];
//    [self.playImageView scaleHideAnimation];
}

- (NSString *)formatTimeString:(NSTimeInterval)time {
    NSInteger intValue = round(time);
    int min = intValue / 60;
    int second = intValue % 60;
    return [NSString stringWithFormat:@"%02d:%02d", min, second];
}
@end
