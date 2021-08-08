//
//  HDtuiliuVideoViewController.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/10/27.
//

#import "HDtuiliuVideoViewController.h"
#import <PLMediaStreamingKit/PLMediaStreamingKit.h>
#import "Macro.h"
#import "HDFaceUnityView.h"
#import "QNFilterPickerView.h"
#import "QNFilterGroup.h"
#import "UIView+QNAnimation.h"
#import "HDServicesManager.h"
#import "HDzhiboModel.h"
#import "HDVideoMessageListView.h"
#import "SocketRocketUtility.h"
#import "HDUkeInfoCenter.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "HDtuichuviewdd.h"
#import "HDzhibolistViewController.h"
#import "LHDAFNetworkReachabilityManager.h"


@interface HDtuiliuVideoViewController ()<HDFaceUnityViewDelegate,PLMediaStreamingSessionDelegate,QNFilterPickerViewDelegate,UIGestureRecognizerDelegate,PLPlayerDelegate,HDtuichuviewdddelegate>
@property (nonatomic, strong) PLMediaStreamingSession *session;

@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIView *coreView;


@property (nonatomic, strong) UIButton *buguangButton;//闪光灯
@property (nonatomic, strong) UIButton *fanzhuanButton;//后置摄像头
@property (nonatomic, strong) UIButton *endButton;//结束


@property (nonatomic, strong) UIButton *dismissButton;


@property (nonatomic, strong) HDzhiboModel *model;

@property (nonatomic, strong)HDVideoMessageListView *videoMessageListView;
@property (nonatomic, strong) NSMutableArray *pinglunArray;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timerWork;

@property (nonatomic, strong) UIButton *choujiangBtn;//抽奖
@property (nonatomic, strong) NSMutableArray *pinglunArray1;

@property (nonatomic, strong) UILabel *diqulabel;//位置
@property (nonatomic, strong) UILabel *renshuCountlabel;//人数
@property (nonatomic, strong) UILabel *dianzanCountlabel;//点赞
@property (nonatomic, strong) UILabel *renshulabel;//人数名称
@property (nonatomic, strong) UILabel *dianzanlabel;//点赞名称


@property (nonatomic, strong)PLPlayer *player;
@property (nonatomic, assign) BOOL iserrordata;//


@property (nonatomic, assign) BOOL shoudonguganbi;//手动关闭

@property (nonatomic, assign) BOOL showa;//

@property (nonatomic, strong) HDtuichuviewdd *zhibochouiangView;//

@end

@implementation HDtuiliuVideoViewController

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_dismissButton addTarget:self action:@selector(clickDismissPickerViewButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _dismissButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pinglunArray = [NSMutableArray array];
    self.pinglunArray1 = [NSMutableArray array];

    self.videoView = [[UIView alloc]init];
    self.videoView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.videoView];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
    if (self.isyingjianzhibo == NO) {
        PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
        videoCaptureConfiguration.previewMirrorFrontFacing = NO;
        PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
        PLVideoStreamingConfiguration *videoStreamingConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
        PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];

        self.session = [[PLMediaStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:videoStreamingConfiguration audioStreamingConfiguration:audioStreamingConfiguration stream:nil];
        self.session.autoReconnectEnable = YES;
        self.session.captureDevicePosition = AVCaptureDevicePositionFront;
        [self.session setBeautifyModeOn:YES];
        self.session.delegate = self;
        [self.videoView addSubview:self.session.previewView];
    }else {
               
    }
  

    self.coreView = [[UIView alloc]init];
    [self.view addSubview:self.coreView];
    [self.coreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
    [self addcoreSuberView];
    
    [HDServicesManager getdeosddDataWithResul:self.uuid block:^(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString) {
        self.model = dic;
        
        
        if (isSuccess == YES) {
            if (self.isyingjianzhibo == NO) {
                [self videotuiliu];
            }else {
                // 初始化 PLPlayerOption 对象
                PLPlayerOption *option = [PLPlayerOption defaultOption];
                // 更改需要修改的 option 属性键所对应的值
                [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
                [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
                [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
                [option setOptionValue:@(YES) forKey:PLPlayerOptionKeyVideoToolbox];
                [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
                self.player = [PLPlayer playerLiveWithURL:[NSURL URLWithString:self.model.playUrl] option:option];
                self.player.delegate = self;
                self.player.playerView.frame = CGRectMake(0, 180, kScreenWidth, 250);
                [self.videoView addSubview:self.player.playerView];
                [self.player play];
            }
            
            [[SocketRocketUtility instance] SRWebSocketClose];
            
            NSString *str = [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL;
            NSString *host = @"";
            NSString *url = @"";
            if ([str hasPrefix:@"http://"]) {
                host =  [str substringFromIndex:7];
                url = [NSString stringWithFormat:@"ws://%@/ws/live/videos/%@",host,self.model.uuid];
            }else {
                host =  [str substringFromIndex:8];
                url = [NSString stringWithFormat:@"wss://%@/ws/live/videos/%@",host,self.model.uuid];
            }

            [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:url];
            if ([self.model.usePrizeDraw isEqualToString:@"1"]) {
                self.choujiangBtn.hidden = NO;
                if ([[NSUserDefaults standardUserDefaults] boolForKey:self.model.uuid] == YES) {
                    self.choujiangBtn.selected = YES;
                }
            }else {
                self.choujiangBtn.hidden = YES;
            }
            self.diqulabel.text = dic.address;
            
            self.renshuCountlabel.text = [NSString stringWithFormat:@"%@人",[self stringToInt:dic.onlineUserCount]];
            self.dianzanCountlabel.text = [NSString stringWithFormat:@"%@",[dic.likeCount stringValue]];

            self.zhibochouiangView = [[[NSBundle mainBundle]loadNibNamed:@"HDtuichuviewdd" owner:nil options:nil]lastObject];
            self.zhibochouiangView.model = dic;
            self.zhibochouiangView.hidden = YES;
            self.zhibochouiangView.delegate = self;
            [self.view addSubview:self.zhibochouiangView];
            [self.zhibochouiangView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
        }else {
            [self closeshite:alertString];
        }
        
    }];
    
    self.videoMessageListView = [[HDVideoMessageListView alloc]initWithFrame:CGRectMake(16,kScreenHeight - 250, 300, 250)];
    self.videoMessageListView.reloadType = NDReloadLiveMsgRoom_Time;
    [self.view addSubview:self.videoMessageListView];
    [self setTimerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidClose) name:kWebSocketDidCloseNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willTerminateNotification) name:UIApplicationWillTerminateNotification object:nil];

    LHDAFNetworkReachabilityManager *manager = [LHDAFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == -1 || status == 0) {
            NSLog(@"未连接网络");
            [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络状态"];
        }
    }];
}

- (void)closetuichaView {
    if (self.ispopview == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

// 实现 <PLPlayerDelegate> 来控制流状态的变更
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    NSLog(@"22222:%ld",(long)state);

    if (state == PLPlayerStatusReady) {
        
        if (self.iserrordata == NO) {
            NSLog(@"state1111:%ld",(long)state);
            [self.player playWithURL:[NSURL URLWithString:self.model.playUrl] sameSource:NO];
            [self.player play];
            self.iserrordata = YES;
            
        }
    }else if (state == PLPlayerStatusPlaying) {
        
    }
}


-(void)willTerminateNotification {
        
    if (self.shoudonguganbi == NO) {
        
        if (self.choujiangBtn.selected == YES) {
            NSLog(@"willTerminateNotification=:%@",self.model.uuid);
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.model.uuid];
        }
    }
}

-(void)chongulaliu {
//    if (self.iserrordata == YES) {
//        [self.player playWithURL:[NSURL URLWithString:self.model.playUrl] sameSource:NO];
//    }
}
- (void)SRWebSocketDidOpen {
    
    //在成功后需要做的操作。。。
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"event"] = @"join";
    dic[@"data"] = @{@"token":[HDUkeInfoCenter sharedCenter].userModel.token};
    
    NSLog(@"Socket开启成功----%@",[dic mj_JSONString]);
    [[SocketRocketUtility instance] sendData:[dic mj_JSONString]];
}

-(void)SRWebSocketDidClose {
    NSLog(@"收到socket断开通知");
    
    
    if (self.showa == NO) {
        self.showa = YES;
        
        NSString *str = [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL;
        NSString *host = @"";
        NSString *url = @"";
        if ([str hasPrefix:@"http://"]) {
            host =  [str substringFromIndex:7];
            url = [NSString stringWithFormat:@"ws://%@/ws/live/videos/%@",host,self.model.uuid];
        }else {
            host =  [str substringFromIndex:8];
            url = [NSString stringWithFormat:@"wss://%@/ws/live/videos/%@",host,self.model.uuid];
        }
        [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:url];
    }
   
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    NSString * message = note.object;
    
    NSDictionary *dic = [message mj_JSONObject];
    NSString *event = dic[@"event"];
    if ([event isEqualToString:@"like"] || [event isEqualToString:@"dislike"]) {
    NSNumber *likeCount = dic[@"data"][@"data"][@"likeCount"];
    self.dianzanlabel.text = [NSString stringWithFormat:@"点赞数量：%@",[likeCount stringValue]];

    }else if ([event isEqualToString:@"onlineUser"])//广播在线用户数
    {
        NSNumber *onlineUser = dic[@"data"][@"data"][@"onlineUser"];
        
        self.renshuCountlabel.text = [NSString stringWithFormat:@"%@人",[self stringToInt:[onlineUser stringValue]]];

    }else if ([event isEqualToString:@"resume"])//恢复
    {
   
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"直播已恢复" preferredStyle:UIAlertControllerStyleAlert];

           UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
     
           }];

           [alertVc addAction:sureBtn];
        [self presentViewController:alertVc animated:YES completion:nil];
        
        [self.session startStreamingWithFeedback:^(PLStreamStartStateFeedback feedback) {
        NSLog(@"feedback:=%lu",(unsigned long)feedback);
            if (feedback == PLStreamStartStateSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"推流成功"];
                NSLog(@"推流成功.");
            }
            else {
                NSLog(@"Oops.");
            }
        }];
        
    }else if ([event isEqualToString:@"pause"])//
    {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"您的直播暂时受限，请您等待恢复" preferredStyle:UIAlertControllerStyleAlert];

           UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
     
           }];

           [alertVc addAction:sureBtn];
        [self presentViewController:alertVc animated:YES completion:nil];
        [self.session stopStreaming];
        
    }else if ([event isEqualToString:@"join"]) {

        NSNumber *num = dic[@"data"][@"code"];

        if ([[num stringValue] isEqualToString:@"4000313"]) {
            
            [self closeshite:dic[@"data"][@"message"]];
        }
    }else if ([event isEqualToString:@"close"]) {
        NSNumber *num = dic[@"data"][@"code"];
        if ([num intValue] == 0) {
            [self.session destroy];
            [self.timer invalidate];
            self.timer = nil;

            [self.timerWork invalidate];
            self.timerWork = nil;

            [[NSNotificationCenter defaultCenter] removeObserver:self];


            [[SocketRocketUtility instance] SRWebSocketClose];
                    
            [HDServicesManager getdeosddDataWithResul:self.model.uuid block:^(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString) {
                
                if (isSuccess == YES) {
                    self.zhibochouiangView.model = dic;
                    self.zhibochouiangView.hidden = NO;
                }
            }];
           [[NSNotificationCenter defaultCenter] postNotificationName:@"liveVideoLose" object:nil];
           
        }else {
            [SVProgressHUD showErrorWithStatus:dic[@"data"][@"message"]];
            
        }
        
    }
    NSLog(@"收到服务端发送过来的消息:=%@",message);
}

-(void)setTimerView {
    
    __weak __typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer timerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            if (self.pinglunArray.count > 0) {
                HDVideoMessageListModel *mode = self.pinglunArray.firstObject;
                [weakSelf.videoMessageListView addNewMsg:mode];
                [self.pinglunArray removeObject:mode];
            }
        }];
    } else {
        // Fallback on earlier versions
    }
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    
    if (@available(iOS 10.0, *)) {
        self.timerWork = [NSTimer timerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSString *lastIndex = nil;
            if (self.pinglunArray1.count == 0) {
                lastIndex = @"0";
            }else {
                HDVideoMessageListModel *mode = self.pinglunArray1.lastObject;
                lastIndex = mode.pinglunID;
            }
            [HDServicesManager getzhibopunxunchaxuDataWithResul:weakSelf.model.uuid lastIndex:lastIndex block:^(BOOL isSuccess, NSArray * _Nullable arr, NSString * _Nullable alertString) {
                if (arr.count > 0) {
                    NSArray *modelarr = [HDVideoMessageListModel mj_objectArrayWithKeyValuesArray:arr];
                    [self.pinglunArray addObjectsFromArray:modelarr];
                    [self.pinglunArray1 addObjectsFromArray:modelarr];

                }
            }];
            
            [self chongulaliu];
        }];
    } else {
        // Fallback on earlier versions
    }
    [[NSRunLoop mainRunLoop] addTimer:self.timerWork forMode:NSRunLoopCommonModes];
}

-(void)videotuiliu {
    NSURL *pushURL = [NSURL URLWithString:self.model.publishUrl];
    NSLog(@"pushURL=%@",pushURL);
    [self.session startStreamingWithPushURL:pushURL feedback:^(PLStreamStartStateFeedback feedback) {
        NSLog(@"feedback:=%lu",(unsigned long)feedback);
            if (feedback == PLStreamStartStateSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"推流成功"];
                NSLog(@"推流成功.");
            }
            else {
                NSLog(@"Oops.");
            }
     }];
}

/*!
 @abstract   流状态变更的回调

 @discussion 当状态变为 PLStreamStateAutoReconnecting 时，SDK 会为您自动重连，如果希望停止推流，直接调用 stopStreaming 即可。
*/
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session streamStateDidChange:(PLStreamState)state {
    NSLog(@"流状态变更的回调 %@--%lu",session,(unsigned long)state);
    
    if (state == PLStreamStateError || state == PLStreamStateDisconnecting || state == PLStreamStateDisconnected) {
        if (self.shoudonguganbi == NO) {
            [SVProgressHUD showErrorWithStatus:@"当前直播已断开"];
        }
    }
}

/*!
 @abstract   因产生了某个 error 而断开时的回调

 @discussion error 错误码的含义，可查阅 PLTypeDefines.h 文件
*/
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didDisconnectWithError:(NSError *)error {
    NSLog(@"因产生了某个 error 而断开时的回调 %@--%@",session,error);
    
    if (self.shoudonguganbi == NO) {
        [SVProgressHUD showErrorWithStatus:@"当前直播已断开"];
    }
}


-(void)addcoreSuberView {
    self.endButton = [[UIButton alloc]init];
    [self.endButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_system_guanbizhibo")] forState:0];
    [self.endButton setTitle:@"结束" forState:0];
    self.endButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.endButton setTitleColor:[UIColor whiteColor] forState:0];
    [self.endButton addTarget:self action:@selector(ButtonEndDid) forControlEvents:UIControlEventTouchUpInside];
    [self.coreView addSubview:self.endButton];
    [self.endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.coreView).offset(-20);
        make.top.mas_equalTo(self.coreView).offset(GS_StatusBarHeight + 24);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(49);
    }];

    self.fanzhuanButton = [[UIButton alloc]init];
    [self.fanzhuanButton setTitle:@"翻转" forState:0];
    self.fanzhuanButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.fanzhuanButton setTitleColor:[UIColor whiteColor] forState:0];
    [self.fanzhuanButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_camero")] forState:0];
    [self.fanzhuanButton  addTarget:self action:@selector(fanzhuanButtonDidEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.coreView addSubview:self.fanzhuanButton];
    [self.fanzhuanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.endButton.mas_right);
        make.top.equalTo(self.endButton.mas_bottom).offset(48);
        make.width.height.equalTo(self.endButton);
    }];
    
    self.buguangButton = [[UIButton alloc]init];
    [self.buguangButton setTitle:@"闪光灯" forState:UIControlStateNormal];
    [self.buguangButton setTitle:@"闪光灯" forState:UIControlStateSelected];
    self.buguangButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.buguangButton setTitleColor:[UIColor whiteColor] forState:0];
    [self.buguangButton setImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_deng_0")] forState:0];
    [self.buguangButton setImage:[UIImage imageNamed:HDBundleImage(@"mine/icon_deng_1")] forState:UIControlStateSelected];
    [self.buguangButton  addTarget:self action:@selector(buguangButtonDidEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.coreView addSubview:self.buguangButton];
    [self.buguangButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.fanzhuanButton.mas_centerX);
        make.top.equalTo(self.fanzhuanButton.mas_bottom).offset(24);
        make.height.equalTo(self.endButton);
    }];
    
    self.diqulabel = [[UILabel alloc]init];
    self.diqulabel.textColor = [UIColor whiteColor];
    [self.coreView addSubview:self.diqulabel];
    [self.diqulabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.centerY.equalTo(self.endButton.mas_centerY);
    }];
    
    self.renshuCountlabel = [[UILabel alloc]init];
    self.renshuCountlabel.textColor = [UIColor whiteColor];
    self.renshuCountlabel.font = [UIFont systemFontOfSize:12];
    [self.coreView addSubview:self.renshuCountlabel];
    [self.renshuCountlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.diqulabel.mas_bottom).offset(8);
    }];
    
    self.renshulabel = [[UILabel alloc]init];
    self.renshulabel.textColor = RGBA(255, 255, 255, 0.7);
    self.renshulabel.font = [UIFont systemFontOfSize:12];
    self.renshulabel.text = @"当前在线人数";
    [self.coreView addSubview:self.renshulabel];
    [self.renshulabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.renshuCountlabel.mas_right).offset(4);
        make.centerY.equalTo(self.renshuCountlabel.mas_centerY);
    }];
    
    
    self.dianzanCountlabel = [[UILabel alloc]init];
    self.dianzanCountlabel.textColor = [UIColor whiteColor];
    self.dianzanCountlabel.font = [UIFont systemFontOfSize:12];
    [self.coreView addSubview:self.dianzanCountlabel];
    [self.dianzanCountlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.renshuCountlabel.mas_bottom).offset(4);
    }];
    
    self.dianzanlabel = [[UILabel alloc]init];
    self.dianzanlabel.textColor = RGBA(255, 255, 255, 0.7);
    self.dianzanlabel.font = [UIFont systemFontOfSize:12];
    self.dianzanlabel.text = @"点赞数量";
    [self.coreView addSubview:self.dianzanlabel];
    [self.dianzanlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dianzanCountlabel.mas_right).offset(4);
        make.centerY.equalTo(self.dianzanCountlabel.mas_centerY);
    }];
    
    
    
    self.choujiangBtn = [[UIButton alloc]init];
    [self.choujiangBtn setTitle:@"抽  奖" forState:0];
    [self.choujiangBtn setTitle:@"抽奖中" forState:UIControlStateSelected];
    self.choujiangBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.choujiangBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.choujiangBtn setTitleColor:RGBA(55, 113, 255, 1) forState:UIControlStateSelected];
    [self.choujiangBtn setImage:[UIImage imageNamed:HDBundleImage(@"currency/btn_gift_open")] forState:0];
    [self.choujiangBtn setImage:[UIImage imageNamed:HDBundleImage(@"currency/btn_gift_off")] forState:UIControlStateSelected];
    [self.choujiangBtn addTarget:self action:@selector(choujiangbtndid:) forControlEvents:UIControlEventTouchUpInside];
    [self.coreView addSubview:self.choujiangBtn];
    [self.choujiangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.buguangButton.mas_centerX);
        make.top.equalTo(self.buguangButton.mas_bottom).offset(24);
        make.height.equalTo(self.buguangButton);
    }];
    
    
    [self changeButtonType:self.endButton];
    [self changeButtonType:self.fanzhuanButton];
    [self changeButtonType:self.buguangButton];
    [self changeButtonType:self.choujiangBtn];
    
}

-(void)choujiangbtndid:(UIButton *)btn {
    
    if (btn.selected == NO) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"是否确认开始抽奖" preferredStyle:UIAlertControllerStyleAlert];
          UIAlertAction *sureBtn1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull   action) {
        }];
           UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
               btn.selected = YES;
               NSMutableDictionary *dic = [NSMutableDictionary dictionary];
               dic[@"event"] = @"authorPrize";
               dic[@"data"] = @{@"drawPrize":@(btn.selected)};
               [[SocketRocketUtility instance] sendData:[dic mj_JSONString]];
           }];

           [alertVc addAction:sureBtn];
            [alertVc addAction:sureBtn1];
           [self presentViewController:alertVc animated:YES completion:nil];
    }else {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"是否确认关闭抽奖" preferredStyle:UIAlertControllerStyleAlert];
          UIAlertAction *sureBtn1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull   action) {
        }];
           UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
               btn.selected = NO;
               NSMutableDictionary *dic = [NSMutableDictionary dictionary];
               dic[@"event"] = @"authorPrize";
               dic[@"data"] = @{@"drawPrize":@(btn.selected)};
               [[SocketRocketUtility instance] sendData:[dic mj_JSONString]];
           }];

           [alertVc addAction:sureBtn];
            [alertVc addAction:sureBtn1];
           [self presentViewController:alertVc animated:YES completion:nil];
    }
   
}


#pragma mark - 结束
-(void)ButtonEndDid{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"确定要关闭当前直播吗？" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull   action) {

    }];
    
    UIAlertAction *sureBtn1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
        [SVProgressHUD  showWithStatus:@"请稍候..."];
        [HDServicesManager getvideoloseDataWithResul:self.uuid block:^(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString) {
            [SVProgressHUD dismiss];
            if (isSuccess == YES) {
                self.shoudonguganbi = YES;
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"event"] = @"close";
                dic[@"data"] = @{};
                [[SocketRocketUtility instance] sendData:[dic mj_JSONString]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"直播关闭失败，请重试!"];
                [weakSelf ButtonEndDid];
            }
        }];
        
    }];
   [alertVc addAction:sureBtn];
   [alertVc addAction:sureBtn1];
   [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)closeshite:(NSString *)message {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureBtn1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
        self.shoudonguganbi = YES;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"event"] = @"close";
        dic[@"data"] = @{};
        [[SocketRocketUtility instance] sendData:[dic mj_JSONString]];
        
        [self.session destroy];
        [self.timer invalidate];
        self.timer = nil;

        [self.timerWork invalidate];
        self.timerWork = nil;

        [[SocketRocketUtility instance] SRWebSocketClose];
        
        
        if (self.ispopview == YES) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"liveVideoLose" object:nil];


        [HDServicesManager getvideoloseDataWithResul:self.uuid block:^(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString) {

        }];
    }];
   [alertVc addAction:sureBtn1];
   [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark -后置摄像头事件
- (void)fanzhuanButtonDidEvent:(UIButton *)button {

    [self.session toggleCamera];
}

#pragma mark -闪光灯事件
- (void)buguangButtonDidEvent:(UIButton *)button {
    self.session.torchOn = !self.session.torchOn;
    button.selected = self.session.torchOn;
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
