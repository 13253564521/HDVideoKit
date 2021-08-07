//
//  HDuserVideolaliuController.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/1.
//

#import "HDuserVideolaliuController.h"
#import "Macro.h"
#import "HDShareView.h"
#import "HDtoppingView.h"
#import <JFWechat/JFWechat.h>
#import "HDzhibochouiangView.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "HDLikeView.h"
#import "HDServicesManager.h"
#import "HDVideoMessageListView.h"
#import "HDusergouCarxiangfa.h"

#import "HDUkeInfoCenter.h"
#import "HDTopImageBottomTextButton.h"
#import "HDCommentView.h"
#import "SocketRocketUtility.h"
#import "UKNetworkHelper.h"
#import "LHDAFNetworkReachabilityManager.h"
#import "NSDate+MJ.h"
#import "HDUkeInfoCenter.h"
#import "AVPlayerView.h"
#import "HDproxy.h"
#import "HDtuichuviewdd.h"


// 每一秒发送多少条消息
#define MAXCOUNT  30

@interface HDuserVideolaliuController ()<HDShareViewDelegate,PLPlayerDelegate,HDLikeViewdelegate,HDCommentViewdelegate,AVPlayerUpdateDelegate,HDtuichuviewdddelegate>
@property (weak, nonatomic) IBOutlet UIButton *fanuiBtn;//返回
@property (weak, nonatomic) IBOutlet UIButton *btnduoBtn;//更多
@property (weak, nonatomic) IBOutlet UIImageView *heaberImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;//名字
@property (weak, nonatomic) IBOutlet UILabel *shuliangLabel;//数量
@property (weak, nonatomic) IBOutlet UIButton *btn1;//横屏
@property (weak, nonatomic) IBOutlet UIButton *btn2;//清屏
@property (weak, nonatomic) IBOutlet UIButton *btn3;//表单
@property (weak, nonatomic) IBOutlet UIButton *btn4;//分享
@property (weak, nonatomic) IBOutlet UIView *btnView5;//点赞
@property (weak, nonatomic) IBOutlet UIButton *btn6;//抽奖
@property (weak, nonatomic) IBOutlet UIView *bottomView;//底部View
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property(nonatomic , strong)HDCommentView *commentView;

/** 点赞 */
@property(nonatomic,strong) HDLikeView *likeView;
/** f分享视图  */
@property(nonatomic,strong) HDShareView *shareView;
@property (nonatomic, strong)HDtoppingView *toolView;

@property (nonatomic, strong)PLPlayer *player;

@property (nonatomic, strong)HDVideoMessageListView *videoMessageListView;

@property (nonatomic, strong) NSMutableArray *pinglunArray;
@property (nonatomic, strong) NSMutableArray *pinglunArray1;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timerWork;

@property (nonatomic, strong) UITapGestureRecognizer   *singleTapGesture;
@property (weak, nonatomic) IBOutlet UIView *waiview;
@property (nonatomic, assign) NSTimeInterval           lastTapTime;
@property (nonatomic ,strong) UIImageView              *pauseIcon;
@property (nonatomic, assign) BOOL  isCurrenPause;
@property (nonatomic, assign) BOOL  isplay;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bocorin;

@property(nonatomic,strong) HDTopImageBottomTextButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;


@property (strong, nonatomic)UISlider *slider;
@property (strong, nonatomic)UILabel *presentTime;
@property (strong, nonatomic)UILabel *totalTime;

@property (nonatomic, strong) NSTimer *progressTimer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b;

@property (nonatomic, assign) BOOL isshowzhibo;//是否显示直播


@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *timenamel;

@property (nonatomic, assign) BOOL iserrordata;//
@property (nonatomic, assign) BOOL currentclose;//当前直播已经结束

@property (nonatomic, assign) int biaodanjishi;//表单1200秒谈一次
@property (nonatomic, assign) BOOL isSubmitted;//是否提交过表单

@property (nonatomic, strong) AVPlayerView  *playerView;

@property (nonatomic, strong) HDzhibochouiangView  *videolikechoujiang;
@property (nonatomic, strong) NSMutableArray  *commentarray;
@property (nonatomic, assign) NSInteger userDrawInteger;//用户抽奖次数

@property (nonatomic, assign) CGFloat videoWidth;
@property (nonatomic, assign) CGFloat videoHeight;


@property (nonatomic, strong) HDtuichuviewdd *liveOverView;//直播结束 观众端

@end

@implementation HDuserVideolaliuController


- (HDCommentView *)commentView {
    if (!_commentView) {
        _commentView = [[HDCommentView alloc]initWithFrame:self.view.frame];
        _commentView.delegate = self;
    }
    return _commentView;
}

- (HDShareView *)shareView {
    if (!_shareView) {
        _shareView = [[HDShareView alloc]initWithFrame:self.view.bounds];
        _shareView.delegate  = self;
    }
    return _shareView;
}

- (HDtuichuviewdd *)liveOverView {
    if (!_liveOverView) {
        _liveOverView = [[[NSBundle mainBundle]loadNibNamed:@"HDtuichuviewdd" owner:nil options:nil]lastObject];
        _liveOverView.frame = self.view.bounds;
        _liveOverView.delegate = self;
    }
    return _liveOverView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (self.isCurrenPause == YES) {
        
        if ([self.model.state intValue]== 14) {
            [self.player resume];
        }else if ([self.model.state intValue]== 15 ) {
            [self.playerView play];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if (self.isCurrenPause == YES) {
        
        if ([self.model.state intValue]== 14) {
            [self.player pause];
        }else if ([self.model.state intValue]== 15 ) {
            [self.playerView pause];
        }
    }
}

-(void)addProgressTimer {
    if (self.progressTimer == nil) {
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
    }
}

-(void)removeProgressTimer {
//    progressTimer?.invalidate()
//    progressTimer = nil;
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)dealloc {
    [self.timer invalidate];
     self.timer = nil;
    
    [self.timerWork invalidate];
     self.timerWork = nil;
    
    [self.progressTimer invalidate];
     self.progressTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    self.pinglunArray1 = [NSMutableArray array];
    self.commentarray = [NSMutableArray array];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.bottomHConstraint.constant = 56 + GS_TabbarSafeBottomMargin;
    
    self.heaberImage.layer.cornerRadius = 20;
    self.heaberImage.layer.masksToBounds = YES;

    self.image1.layer.cornerRadius = 20;
    self.image1.layer.masksToBounds = YES;
    
    
    self.pinglunArray = [NSMutableArray array];
    
    [self setBtnImage];
    
    if ([self.model.state intValue]== 14) {
        [self state14];
    }else if ([self.model.state intValue]== 15 ) {
        [self state15];
    }
    
    UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recog)];
    [self.heaberImage addGestureRecognizer:recog];
    
    
    UITapGestureRecognizer *recog1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recog)];
    [self.image1 addGestureRecognizer:recog1];
    
    self.heaberImage.userInteractionEnabled = YES;
    self.image1.userInteractionEnabled = YES;
    
    LHDAFNetworkReachabilityManager *manager = [LHDAFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    __weak typeof(self) weakSelf = self;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == -1 || status == 0) {
            NSLog(@"未连接网络");
            [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络状态"];
        }
        
        if (status == 1) {
            NSLog(@"3G/4G网络");
            [weakSelf setNetworktixingwang:@"当前为非Wi-Fi环境，请注意流量消耗"];
        }
    }];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

-(void)setNetworktixingwang:(NSString *)str{
  
    if ([HDUkeInfoCenter sharedCenter].userModel.isNetWorktixing == NO) {
           [SVProgressHUD showErrorWithStatus:str];
           [HDUkeInfoCenter sharedCenter].userModel.isNetWorktixing = YES;
    }
}

-(void)recog {
    self.isCurrenPause = YES;

}

-(void)hiddnView:(BOOL )hid {
    self.heaberImage.hidden = hid;
    self.nameTitle.hidden = hid;
    self.shuliangLabel.hidden = hid;
    
    self.btnduoBtn.hidden = hid;
    self.btn2.hidden = hid;
    if ([self.model.useForm isEqualToString:@"1"] && [self.model.state intValue]== 14) {
        self.btn3.hidden = hid;
    }else {
        self.btn3.hidden = YES;
    }
    self.btn1.hidden = hid;
    self.bottomView.hidden = hid;
    self.videoMessageListView.hidden = hid;
}

//点播
-(void)state15 {
   
    if (self.model.videoUrl.length <= 0) {
        [self hiddnView:YES];
        self.btn4.hidden = YES;
        self.btn6.hidden = YES;
        self.btnView5.hidden = YES;
        UIImageView *errorImage = [[UIImageView alloc]init];
        errorImage.contentMode = UIViewContentModeScaleAspectFit;
        [errorImage yy_setImageWithURL:[NSURL URLWithString:self.model.coverUrl] placeholder:nil];
        [self.view addSubview:errorImage];
        [errorImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];

        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"直播回放正在加载中，请稍等" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertVc addAction:sureBtn];
        [self presentViewController:alertVc animated:YES completion:nil];
        return;
    }
    
    self.image1.hidden = NO;
    [self hiddnView:YES];
    self.bocorin.constant = 80;
    self.btn6.hidden = YES;
    [self.image1 yy_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];
    
    self.commentButton = [HDTopImageBottomTextButton buttonWithType:UIButtonTypeCustom];
    [self.commentButton setImage:[UIImage imageNamed:HDBundleImage(@"discover/icon_comment")] forState:UIControlStateNormal];
    [self.commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.commentButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [self.commentButton setTitle:[NSString stringWithFormat:@"%@",[self stringToInt:self.model.commentCount]] forState:UIControlStateNormal];
    [self.commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.waiview addSubview:self.commentButton];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(53);
        make.height.mas_equalTo(49);
        make.right.mas_equalTo(self.btn4);
        make.bottom.mas_equalTo(self.btn4.mas_top).offset(-15);
    }];
    

    
//    // 初始化 PLPlayerOption 对象
//    PLPlayerOption *option = [PLPlayerOption defaultOption];
//    // 更改需要修改的 option 属性键所对应的值
//    [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
//    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
//    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
//    [option setOptionValue:@(YES) forKey:PLPlayerOptionKeyVideoToolbox];
//    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    // 初始化 PLPlayer
//    self.player = [PLPlayer playerWithURL:[NSURL URLWithString:self.model.videoUrl] option:option];
//    self.player.delegate = self;
//    [self.videoView addSubview:self.player.playerView];
//    [self.player play];
    
    
    
    self.playerView = [AVPlayerView new];
    self.playerView.delegate = self;
    [self.playerView setPlayerWithUrl:self.model.videoUrl];
    [self.videoView addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.waiview addGestureRecognizer:_singleTapGesture];
    
    _pauseIcon = [[UIImageView alloc] init];
    _pauseIcon.image = [UIImage imageNamed:HDBundleImage(@"video/icon_play_pause")];
    _pauseIcon.contentMode = UIViewContentModeCenter;
    _pauseIcon.layer.zPosition = 3;
    _pauseIcon.hidden = YES;
    [self.waiview addSubview:_pauseIcon];
    [_pauseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.waiview);
        make.width.height.mas_equalTo(100);
    }];
    
  
    
    self.presentTime = [[UILabel alloc]init];
    self.presentTime.font = [UIFont systemFontOfSize:10];
    self.presentTime.textColor = [UIColor whiteColor];
    self.presentTime.text = @"00:00";
    self.presentTime.textAlignment = NSTextAlignmentCenter;
    [self.waiview addSubview:self.presentTime];
    [self.presentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(60);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-34);
        } else {
            make.bottom.mas_equalTo(0);
            // Fallback on earlier versions
        }
    }];
    
    self.totalTime = [[UILabel alloc]init];
    self.totalTime.font = [UIFont systemFontOfSize:10];
    self.totalTime.textColor = [UIColor whiteColor];
    self.totalTime.text = @"00:00";
    self.totalTime.textAlignment = NSTextAlignmentCenter;
    [self.waiview addSubview:self.totalTime];
    [self.totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(60);
        make.bottom.mas_equalTo(self.presentTime);
    }];
    
    self.slider = [[UISlider alloc]init];
    self.slider.backgroundColor = UIColor.clearColor;
    [self.slider setValue:0 animated:NO];
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = 1.0;
    [self.slider addTarget:self action:@selector(dragSliderDidStart:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.slider setMaximumTrackImage:[UIImage imageNamed:HDBundleImage(@"currency/MaximumTrackImage")] forState:0];
    [self.slider setMinimumTrackImage:[UIImage imageNamed:HDBundleImage(@"currency/MinimumTrackImage")] forState:0];
    [self.slider setThumbImage:[UIImage imageNamed:HDBundleImage(@"currency/jp_videoplayer_progress_handler_normal")] forState:0];
    [self.slider setThumbImage:[UIImage imageNamed:HDBundleImage(@"currency/jp_videoplayer_progress_handler_hightlight")] forState:UIControlStateHighlighted];

    [self.waiview addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.presentTime.mas_right);
        make.right.mas_equalTo(self.totalTime.mas_left);
        make.bottom.mas_equalTo(self.presentTime);
    }];
    
    self.contentLable.hidden = NO;
    self.contentLable.text = self.model.title;
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.slider.mas_top).offset(-15);
    }];
    
    self.namelabel.hidden = NO;
    self.namelabel.text = [NSString stringWithFormat:@"@%@",self.model.nickName];
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(100);
        make.bottom.mas_equalTo(self.contentLable.mas_top).offset(-5);
    }];
    
    NSDate *date = [[NSDate alloc]init];
    self.timenamel.hidden = NO;
    self.timenamel.text = [date timeStringWithTimeInterval:[NSString stringWithFormat:@"%ld",(long)self.model.beginTime]];
    [self.timenamel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.namelabel);
        make.left.mas_equalTo(self.namelabel.mas_right);
    }];
    
    [self addProgressTimer];
    
}


-(void)state14 {
    // 初始化 PLPlayerOption 对象
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    // 更改需要修改的 option 属性键所对应的值
    [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    [option setOptionValue:@(YES) forKey:PLPlayerOptionKeyVideoToolbox];
    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    // 初始化 PLPlayer
    self.player = [PLPlayer playerLiveWithURL:[NSURL URLWithString:self.model.playUrl] option:option];
    self.player.delegate = self;
//    if ([self.model.liveType isEqualToString:@"1"]) {
//        self.player.playerView.frame = CGRectMake(0, 180, kScreenWidth, 250);
//    }else {
//        self.player.playerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    }

//
    [self.videoView addSubview:self.player.playerView];
    [self.player play];
    
    [self setTimerView];

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
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidclose) name:kWebSocketDidCloseNote object:nil];

    if ([self.model.prizeState isEqualToString:@"1"]) {
        self.btn6.hidden = NO;
        self.isshowzhibo = YES;
    }else {
        self.btn6.hidden = YES;
        self.isshowzhibo = NO;
    }
    
    if ([self.model.useForm isEqualToString:@"1"]) {
        self.btn3.hidden = NO;
//        self.b.constant = 25;

        [UKNetworkHelper GET:[NSString stringWithFormat:@"/live/videos/%@/form/state",self.model.uuid] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
            NSNumber *code = response[@"code"];
            if ([[code stringValue] isEqualToString:@"0"]) {
                NSNumber *isSubmitted = response[@"data"][@"isSubmitted"];
                if ([isSubmitted intValue] == 0) {
                    self.isSubmitted = [isSubmitted boolValue];
                    [self btn3:self.btn3];
                }
            }
        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
                    
        }];
    }else {
        self.btn3.hidden = YES;
        self.b.constant = -35;
    }
    
//    [UKNetworkHelper POST:[NSString stringWithFormat:@"/live/videos/%@/play",self.model.uuid] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
//        NSNumber *code = response[@"code"];
//        if ([[code stringValue] isEqualToString:@"0"]) {
//
//        }
//    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
//
//    }];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragViewMoved:)];
    [self.btn6 addGestureRecognizer:panGestureRecognizer];

}


- (void)dragViewMoved:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
           NSLog(@"FlyElephant---视图拖动开始");
       } else if (recognizer.state == UIGestureRecognizerStateChanged) {
           CGPoint location = [recognizer locationInView:self.view];
           
           if (location.y < 0 || location.y > self.view.bounds.size.height) {
               return;
           }
           CGPoint translation = [recognizer translationInView:self.view];
           
           NSLog(@"当前视图在View的位置:%@----平移位置:%@",NSStringFromCGPoint(location),NSStringFromCGPoint(translation));
           recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
           [recognizer setTranslation:CGPointZero inView:self.view];
           
       } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
           NSLog(@"FlyElephant---视图拖动结束");
       }
}
    
-(void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
  
}

-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status {
    switch (status) {
        case AVPlayerItemStatusUnknown:

        case AVPlayerItemStatusReadyToPlay:
            
            [self.playerView play];
            break;
        case AVPlayerItemStatusFailed:
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            break;
        default:
            break;
    }
}

/**
 视频宽高数据回调通知

 @param player 调用该方法的 PLPlayer 对象
 @param width 视频流宽
 @param height 视频流高
 
 @since v3.3.0
 */
- (void)player:(nonnull PLPlayer *)player width:(int)width height:(int)height {
    
    CGFloat videoW = 0;
    CGFloat videoH = 0;
    
    self.videoWidth = width;
    self.videoHeight = height;
    
    CGFloat scale = self.videoWidth /self.videoHeight;
    NSLog(@"scale%f",scale);
    float d = self.view.frame.size.width / scale;
    
    if (d > self.view.frame.size.height) {
        videoW = self.view.frame.size.height * scale;
        videoH = self.view.frame.size.height;
    }else if (d < self.view.frame.size.height) {
        videoW = self.view.frame.size.width;
        videoH = d;
    }else if (d == self.view.frame.size.height) {
        videoW = self.view.frame.size.width;
        videoH = self.view.frame.size.height;
    }
    
    self.player.playerView.frame = CGRectMake(self.view.frame.size.width/2 - videoW / 2, self.view.frame.size.height/2 - videoH / 2, videoW, videoH);

}

-(void)SRWebSocketDidclose {
    NSLog(@"收到socket断开通知");
    
//    NSString *str = [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL;
//    NSString *host = @"";
//    NSString *url = @"";
//    if ([str hasPrefix:@"http://"]) {
//        host =  [str substringFromIndex:7];
//        url = [NSString stringWithFormat:@"ws://%@/ws/live/videos/%@",host,self.model.uuid];
//    }else {
//        host =  [str substringFromIndex:8];
//        url = [NSString stringWithFormat:@"wss://%@/ws/live/videos/%@",host,self.model.uuid];
//    }
//
//   [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:url];
}

- (void)SRWebSocketDidOpen {
    
    //在成功后需要做的操作。。。
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"event"] = @"join";
    dic[@"data"] = @{@"token":[HDUkeInfoCenter sharedCenter].userModel.token};
    NSLog(@"joinjoinjoinjoinjoin");
    [[SocketRocketUtility instance] sendData:[dic mj_JSONString]];
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    
    if ([self.model.state intValue]== 15) {
        return;
    }
    
    @WeakObj(self);
    //收到服务端发送过来的消息
    NSString * message = note.object;
    
    NSDictionary *dic = [message mj_JSONObject];
    
    NSString *event = dic[@"event"];
    if ([event isEqualToString:@"authorPrize"]) {
        id data = dic[@"data"][@"data"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = dic[@"data"][@"data"];
            NSNumber *selcet = data[@"drawPrize"];
            
            if ([selcet boolValue] == 1)//开启礼物
            {
                self.model.prizeState = @"1";
                self.btn6.hidden = NO;
                if (self.videolikechoujiang) {
//                    self.videolikechoujiang.selectIndex = 1;
                    self.userDrawInteger = 1;
                }
                self.isshowzhibo = YES;
            }else {
                self.model.prizeState = @"0";
                self.btn6.hidden = YES;
                self.isshowzhibo = NO;
                [self.videolikechoujiang removeFromSuperview];
            }
            NSLog(@"收到开启礼物==%d",[selcet boolValue]);
        }

    }else if ([event isEqualToString:@"close"]) {
        self.currentclose = YES;
        self.errorLabel.hidden = YES;
        [self zhiboclose];
        
        [HDServicesManager getdeosddDataWithResul:self.model.uuid block:^(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString) {
            
            if (isSuccess == YES) {
                selfWeak.liveOverView.model = dic;
            }
        }];
    }else if ([event isEqualToString:@"authorOnline"])//在线
    {
        [self.player playWithURL:[NSURL URLWithString:self.model.playUrl] sameSource:YES];
        [self.player play];
        [self zhboshow];
    }else if ([event isEqualToString:@"authorOffline"] || [event isEqualToString:@"pause"])//下线
    {
        if (![self.model.liveType isEqualToString:@"1"]) {
            if (!self.liveOverView.superview) {
                [self.player pause];
                self.waiview.backgroundColor = [UIColor grayColor];
                self.errorLabel.hidden = NO;
            }
        }
    }else if ([event isEqualToString:@"resume"])//恢复
    {
        [self.player resume];
        self.waiview.backgroundColor = [UIColor clearColor];
        self.errorLabel.hidden = YES;
        self.iserrordata = NO;
    }else if ([event isEqualToString:@"onlineUser"])
    {
        NSNumber *onlineUser = dic[@"data"][@"data"][@"onlineUser"];
        
        self.shuliangLabel.text = [NSString stringWithFormat:@"%@人观看",[self stringToInt:[onlineUser stringValue]]];
    }else if ([event isEqualToString:@"like"] || [event isEqualToString:@"dislike"])
    {
        id dica = dic[@"data"][@"data"];
        if ([dica isKindOfClass:[NSDictionary class]]) {
            
            NSNumber *likeCount = dic[@"data"][@"data"][@"likeCount"];
            self.likeView.likeCount.text = [likeCount stringValue];
        }
       
    }
    NSLog(@"收到服务端发送过来的消息===%@",message);
}

- (void)handleGesture:(UITapGestureRecognizer *)sender {
    //获取当前时间
    NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    //判断当前点击时间与上次点击时间的时间间
    if(time - _lastTapTime > 0.25f) {
        //推迟0.25秒执行单击方法
        [self performSelector:@selector(singleTapAction) withObject:nil afterDelay:0.25f];
    }else {
        //取消执行单击方法
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction) object: nil];
    }

   //更新上一次点击时间
   _lastTapTime =  time;
    
}


-(void)dragSliderDidStart:(UISlider*)sender {
    [self removeProgressTimer];
}

-(void)slider:(UISlider*)sender {
//    CGFloat totalDuration = CMTimeGetSeconds(self.player.totalDuration);
//    CMTime tom = self.player.totalDuration;
//    [self.player seekTo:CMTimeMakeWithSeconds(totalDuration * sender.value,tom.timescale)];
    AVPlayerItem *currentItem = self.playerView.player.currentItem;
    CMTime duration = currentItem.duration; //total time
    
    CGFloat totalDuration = CMTimeGetSeconds(duration);
    CMTime tom = duration;
    [self.playerView.player seekToTime:CMTimeMakeWithSeconds(totalDuration * sender.value,tom.timescale)];

    [self addProgressTimer];
}

-(void)sliderValueChange:(UISlider*)sender {
//    CGFloat totalDuration = CMTimeGetSeconds(self.player.totalDuration);
    AVPlayerItem *currentItem = self.playerView.player.currentItem;
    CMTime duration = currentItem.duration; //total time
    CGFloat totalDuration = CMTimeGetSeconds(duration);

   self.presentTime.text = [self stringWithCurrentTime:totalDuration * sender.value];
    self.totalTime.text = [self stringWithCurrentTime:totalDuration];
}

-(NSString*)stringWithCurrentTime:(NSTimeInterval )time {
   NSString *a = [NSString stringWithFormat:@"%02d",(int)time/60];
    NSString *b = [NSString stringWithFormat:@"%02d",(int)time%60];
    return [NSString stringWithFormat:@"%@:%@",a,b];
}

-(void)updateProgressInfo {
    
    AVPlayerItem *currentItem = self.playerView.player.currentItem;
    CMTime duration = currentItem.duration; //total time
    CMTime currentTime = currentItem.currentTime; //playing time
    
    
    if (CMTimeGetSeconds(currentTime) > 0) {
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        CGFloat currentTime1 = CMTimeGetSeconds(currentTime);
        [self.slider setValue:currentTime1/totalDuration animated:YES];
        
        self.presentTime.text = [self stringWithCurrentTime:currentTime1];
        self.totalTime.text = [self stringWithCurrentTime:totalDuration];
    }
    
//    if (CMTimeGetSeconds(self.player.totalDuration) > 0) {
//        CGFloat totalDuration = CMTimeGetSeconds(self.player.totalDuration);
//        CGFloat currentTime = CMTimeGetSeconds(self.player.currentTime);
//        [self.slider setValue:currentTime/totalDuration animated:YES];
//
//        self.presentTime.text = [self stringWithCurrentTime:currentTime];
//         self.totalTime.text = [self stringWithCurrentTime:totalDuration];
//    }
}

- (void)singleTapAction {
     
    if (self.isplay == NO) {
        [self.playerView pause];
        self.isplay = YES;
        self.pauseIcon.hidden = NO;
    }else {
        [self.playerView play];
        self.isplay = NO;
        self.pauseIcon.hidden = YES;
    }
}

-(void)zhboshow {
    [self hiddnView:NO];
    self.waiview.backgroundColor = [UIColor clearColor];
    self.btnView5.hidden = NO;
    self.btn4.hidden = NO;
    
    if (self.liveOverView.superview) {
        [self.liveOverView removeFromSuperview];
        self.liveOverView = nil;
    }
}

-(void)zhiboclose {
    [self hiddnView:YES];
    [self.videolikechoujiang removeFromSuperview];
    self.btn6.hidden = YES;
    self.waiview.backgroundColor = [UIColor grayColor];
    self.btnView5.hidden = YES;
    self.btn4.hidden = YES;
    
    if (!self.liveOverView.superview) {
        [self.view addSubview:self.liveOverView];
    }
    [self.liveOverView showfoucsButton:YES];
}

// 实现 <PLPlayerDelegate> 来控制流状态的变更
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    
    NSLog(@"state===:%ld",(long)state);
    if (state == PLPlayerStatusCompleted) {
        [self.player play];
    }
    
    
    if ([self.model.state intValue]== 14) {
        if (state == PLPlayerStatusPlaying) {
            
            self.iserrordata = NO;
            self.waiview.backgroundColor = [UIColor clearColor];
            self.errorLabel.hidden = YES;
        }
    }
    
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    // 当发生错误，停止播放时，会回调这个方法
    NSLog(@"stoppedWithError:%@",error);
    if (error) {
        if ([self.model.state intValue]== 14) {
            if (self.isCurrenPause == NO && self.currentclose == NO) {
                [self videoplayerError];
            }
        }
       
    }
}

- (void)player:(nonnull PLPlayer *)player codecError:(nonnull NSError *)error {
  // 当解码器发生错误时，会回调这个方法
  // 当 videotoolbox 硬解初始化或解码出错时
  // error.code 值为 PLPlayerErrorHWCodecInitFailed/PLPlayerErrorHWDecodeFailed
  // 播发器也将自动切换成软解，继续播放
    
    NSLog(@"codecError:%@",error);
    if (error) {
        if ([self.model.state intValue]== 14) {
            if (self.isCurrenPause == NO && self.currentclose == NO) {
                [self videoplayerError];
            }
            
        }
    }
}

-(void)videoplayerError {
    self.iserrordata = YES;
    self.waiview.backgroundColor = [UIColor grayColor];
    self.errorLabel.hidden = NO;
}

-(void)setBtnImage {
    self.image1.hidden = YES;
    [self.fanuiBtn setImage:[UIImage imageNamed:HDBundleImage(@"video/btn_back")] forState:0];
    [self.btnduoBtn setImage:[UIImage imageNamed:HDBundleImage(@"video/icon_more")] forState:0];
    [self.btn4 setImage:[UIImage imageNamed:HDBundleImage(@"video/icon_bicolor_article_share")] forState:0];
    [self.btn3 setImage:[UIImage imageNamed:HDBundleImage(@"video/icon_biaodan")] forState:0];
    [self.btn6 setImage:[UIImage imageNamed:HDBundleImage(@"video/icon_choujiang")] forState:0];
    [self.btn2 setImage:[UIImage imageNamed:HDBundleImage(@"video/icon_clean")] forState:0];
    [self.btn1 setImage:[UIImage imageNamed:HDBundleImage(@"video/icon_hengping")] forState:0];

    [self changeButtonType:self.btnduoBtn];
    [self changeButtonType:self.btn4];
    [self changeButtonType:self.btn3];
    [self changeButtonType:self.btn6];
    [self changeButtonType:self.btn2];
    [self changeButtonType:self.btn1];
    
    
    self.toolView = [[HDtoppingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 56 + GS_TabbarSafeBottomMargin)];
    __weak __typeof(self) weakSelf = self;
    self.toolView.sendBtnBlock = ^(NSString * _Nonnull text) {
        
        if ([[HDUkeInfoCenter sharedCenter].userModel.state intValue] == 10) {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"由于您多次违规操作，已被禁用该功能" preferredStyle:UIAlertControllerStyleAlert];

               UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
               }];

               [alertVc addAction:sureBtn];
               [weakSelf presentViewController:alertVc animated:YES completion:nil];
            return;
        }
        
        [HDServicesManager getzhibopinlunDataWithResul:weakSelf.model.uuid content:text block:^(BOOL isSuccess, NSString * _Nullable alertString) {
            if (isSuccess == YES) {
                HDVideoMessageListModel *model = [[HDVideoMessageListModel alloc]init];
                model.content = text;
                model.nickName = [HDUkeInfoCenter sharedCenter].userModel.nickName;
                [weakSelf.videoMessageListView addNewMsg:model];
                
                [weakSelf.commentarray addObject:model];
            }
        }];
        [weakSelf.toolView uke_resignFirstResponder];
    };
    [self.bottomView addSubview:self.toolView];
    
    self.likeView = [[HDLikeView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.likeView.likeDuration = 0.5;
    self.likeView.hdFillColor = RGBA(37, 96, 246, 1);
    self.likeView.delegate = self;
    
    self.likeView.likeCount.text = [self stringToInt:[self.model.likeCount stringValue]];
    if ([self.model.isLiked intValue] == 1) {
        self.likeView.likeAfter.hidden = NO;
    }else {
        self.likeView.likeAfter.hidden = YES;
    }
    [self.btnView5 addSubview:self.likeView];
    [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(53);
        make.height.mas_equalTo(49);
    }];

    //监听键盘的通知事件  已有变化就发出通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jianpantongzhi:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.videoMessageListView = [[HDVideoMessageListView alloc]initWithFrame:CGRectMake(16,kScreenHeight - 300 - 50, kScreenWidth- 100, 300)];
    self.videoMessageListView.reloadType = NDReloadLiveMsgRoom_Time;
    [self.waiview addSubview:self.videoMessageListView];
    [self.waiview bringSubviewToFront:self.bottomView];
    
    [self.heaberImage yy_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];
    self.nameTitle.text = self.model.nickName;

}


//如果有新评论数据 加载显示
-(void)timerHandle {
    if (self.pinglunArray.count > 0) {
        HDVideoMessageListModel *mode = self.pinglunArray.firstObject;
        [self.videoMessageListView addNewMsg:mode];
        [self.pinglunArray removeObject:mode];
    }
}

-(void)setTimerView {
    
//    __weak __typeof(self) weakSelf = self;
//    if (@available(iOS 10.0, *)) {
//        self.timer = [NSTimer timerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            if (self.pinglunArray.count > 0) {
//                HDVideoMessageListModel *mode = self.pinglunArray.firstObject;
//                [self.videoMessageListView addNewMsg:mode];
//                [self.pinglunArray removeObject:mode];
//            }
//
//        }];
//    }
    
    HDproxy *proxy = [[HDproxy alloc]initWithObjc:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:proxy selector:@selector(timerHandle) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

    HDproxy *proxy1 = [[HDproxy alloc]initWithObjc:self];
    self.timerWork = [NSTimer scheduledTimerWithTimeInterval:1 target:proxy1 selector:@selector(timerUpdateHandle) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timerWork forMode:NSRunLoopCommonModes];
    
//    if (@available(iOS 10.0, *)) {
//        self.timerWork = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            NSString *lastIndex = nil;
//            if (self.pinglunArray1.count == 0) {
//                lastIndex = @"0";
//            }else {
//                HDVideoMessageListModel *mode = self.pinglunArray1.lastObject;
//                lastIndex = mode.index;
//            }
//            [HDServicesManager getzhibopunxunchaxuDataWithResul:weakSelf.model.uuid lastIndex:lastIndex block:^(BOOL isSuccess, NSArray * _Nullable arr, NSString * _Nullable alertString) {
//                if (arr.count > 0) {
//                    NSArray *modelarr = [HDVideoMessageListModel mj_objectArrayWithKeyValuesArray:arr];
//
//                    for (HDVideoMessageListModel *model in modelarr) {
//
//                        BOOL isselect = NO;
//                        for (HDVideoMessageListModel *model1 in self.commentarray) {
//                            if ([model1.nickName isEqualToString:model.nickName] && [model1.content isEqualToString:model.content]) {
//                                isselect = YES;
//                            }
//                        }
//
//                        if (isselect == NO) {
//                            [self.pinglunArray addObject:model];
//                            [self.pinglunArray1 addObject:model];
//                        }
//
//                    }
//
//                }
//            }];
            
//            [self chongulaliu];
//            self.biaodanjishi = self.biaodanjishi + 1;
//            if (self.biaodanjishi >= 1200) {
//                self.biaodanjishi = 0;
//                if (self.isSubmitted == NO && [self.model.useForm isEqualToString:@"1"]) {
//                    [self btn3:self.btn3];
//                }
//            }
            
//        }];
//    }
//    [[NSRunLoop mainRunLoop] addTimer:self.timerWork forMode:NSRunLoopCommonModes];
    
    
    
   
}

//美一秒 刷新下接口请求评论数据
-(void)timerUpdateHandle {
    NSString *lastIndex = nil;
    if (self.pinglunArray1.count == 0) {
        lastIndex = @"0";
    }else {
        HDVideoMessageListModel *mode = self.pinglunArray1.lastObject;
        lastIndex = mode.pinglunID;
    }
    
    [HDServicesManager getzhibopunxunchaxuDataWithResul:self.model.uuid lastIndex:lastIndex block:^(BOOL isSuccess, NSArray * _Nullable arr, NSString * _Nullable alertString) {
        if (arr.count > 0) {
            NSArray *modelarr = [HDVideoMessageListModel mj_objectArrayWithKeyValuesArray:arr];
            
            for (HDVideoMessageListModel *model in modelarr) {
                
                BOOL isselect = NO;
                for (HDVideoMessageListModel *model1 in self.commentarray) {
                    if ([model1.nickName isEqualToString:model.nickName] && [model1.content isEqualToString:model.content]) {
                        isselect = YES;
                    }
                }
                
                if (isselect == NO) {
                    [self.pinglunArray addObject:model];
                    [self.pinglunArray1 addObject:model];
                }
               
            }
     
        }
    }];
    
    [self chongulaliu];
    self.biaodanjishi = self.biaodanjishi + 1;
    if (self.biaodanjishi >= 1200) {
        self.biaodanjishi = 0;
        if (self.isSubmitted == NO && [self.model.useForm isEqualToString:@"1"]) {
            [self btn3:self.btn3];
        }
    }
}


-(void)chongulaliu {
    if (self.iserrordata == YES) {
        [self.player playWithURL:[NSURL URLWithString:self.model.playUrl] sameSource:NO];
    }
}
-(void)jianpantongzhi:(NSNotification *)note
{
    CGFloat durtion =[note.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];

    //  取出键盘的frame
    CGRect frame=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
     [UIView animateWithDuration:durtion animations:^{
       
       if (frame.origin.y==kScreenHeight) {
           self.bottomView.transform = CGAffineTransformIdentity;
       }else {
           self.bottomView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height + GS_TabbarSafeBottomMargin);
       }
       
   }];
}

#pragma mark - 返回
- (IBAction)fanhuiBtn:(id)sender {
    
    [[SocketRocketUtility instance] SRWebSocketClose];
    [self stopController];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 更多
- (IBAction)genduobtn:(id)sender {
   
    [[SocketRocketUtility instance] SRWebSocketClose];
    [self stopController];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -横屏
- (IBAction)btn1:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    

    NSLog(@"%f---%f",self.view.frame.size.width,self.view.frame.size.height);
    if (sender.selected == YES) {
        if ([self.model.liveType isEqualToString:@"1"]) {

//                self.player.playerView.transform = CGAffineTransformMakeRotation(M_PI / 2);
            self.player.rotationMode = PLPlayerRotateRight;
            
            if (self.view.frame.size.width == 375.0 && self.view.frame.size.height == 812.0)//x
            {
                self.player.playerView.frame = CGRectMake(-(self.view.frame.size.width + 65), 0, self.view.frame.size.height + 5, self.view.frame.size.width + 5);
                
            }else if (self.view.frame.size.width == 428.0 && self.view.frame.size.height == 926.0)//12 pro max
            {
                self.player.playerView.frame = CGRectMake(-(self.view.frame.size.width + 70), 0, self.view.frame.size.height, self.view.frame.size.width);
                
            }else if (self.view.frame.size.width == 375.0 && self.view.frame.size.height == 667.0)//6
            {
                self.player.playerView.frame = CGRectMake(-(self.view.frame.size.width - 80), 0, self.view.frame.size.height+5, self.view.frame.size.width+5);
                
            }else if (self.view.frame.size.width == 414.0 && self.view.frame.size.height == 736.0)//pluse
            {
                self.player.playerView.frame = CGRectMake(-(self.view.frame.size.width - 90), 0, self.view.frame.size.height+5, self.view.frame.size.width+5);
                
            }else if (self.view.frame.size.width == 414.0 && self.view.frame.size.height == 896.0)//xs Max
            {
                self.player.playerView.frame = CGRectMake(-(self.view.frame.size.width + 70), 0, self.view.frame.size.height+5, self.view.frame.size.width+5);
                
            }else if (self.view.frame.size.width == 320.0 && self.view.frame.size.height == 568.0)//xs Max
            {
                self.player.playerView.frame = CGRectMake(-(self.view.frame.size.width - 70), 0, self.view.frame.size.height+5, self.view.frame.size.width+5);
            }
            
        }else {
            self.player.rotationMode = PLPlayerRotateRight;
        }
        
        [self hiddnView:YES];
        self.btn4.hidden = YES;
        self.btnView5.hidden = YES;
        self.btn6.hidden = YES;
    }else {
        
        [self hiddnView:NO];
        self.btn4.hidden = NO;
        self.btnView5.hidden = NO;
    
        if ([self.model.liveType isEqualToString:@"1"]) {
            
//            self.player.playerView.transform = CGAffineTransformIdentity;
            self.player.rotationMode = PLPlayerNoRotation;
            [self player:self.player width:self.videoWidth height:self.videoHeight];

        }else {
            self.player.rotationMode = PLPlayerNoRotation;
            self.player.playerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        }
    }
    
    if ([self.model.state isEqualToString:@"14"] && [self.model.prizeState isEqualToString:@"1"]) {
        if (sender.selected == NO) {
            self.btn6.hidden = NO;
        }
        
    }
    
    sender.hidden = NO;
}

#pragma mark -清屏
- (IBAction)btn2:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSLog(@"%d",sender.selected);
    
    if (sender.selected == YES) {
        [self issubeView:YES];
    }else {
        [self issubeView:NO];
    }
    
    
    if ([self.model.state isEqualToString:@"14"] && [self.model.prizeState isEqualToString:@"1"]) {
        
        if (sender.selected == YES) {
            self.btn6.hidden  = YES;
        }else {
            self.btn6.hidden  = NO;
        }
    }
}

-(void)issubeView:(BOOL)isshow {
    self.heaberImage.hidden = isshow;
    self.fanuiBtn.hidden = isshow;
    self.btnduoBtn.hidden = isshow;
    self.nameTitle.hidden = isshow;
    self.shuliangLabel.hidden = isshow;
    self.btn1.hidden = isshow;
    self.btn4.hidden = isshow;
    self.btnView5.hidden = isshow;
    self.bottomView.hidden = isshow;
    self.videoMessageListView.hidden = isshow;
    

    
}


#pragma mark -聊天
- (IBAction)btn3:(id)sender {
    HDusergouCarxiangfa *zhibochouiangView = [[[NSBundle mainBundle]loadNibNamed:@"HDusergouCarxiangfa" owner:nil options:nil]lastObject];
    zhibochouiangView.uuid = self.model.uuid;
    zhibochouiangView.superVc = self;
//
    if ([self.model.prizeState isEqualToString:@"1"]) {
        zhibochouiangView.titlealpath = 1.0;
    }else {
        zhibochouiangView.titlealpath = 0.0;
    }
    zhibochouiangView.Handler = ^{
        self.isSubmitted = YES;
    };
    [self.view addSubview:zhibochouiangView];
    [zhibochouiangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark -分享
- (IBAction)btn4:(id)sender {
    if (!self.shareView.superview) {
        [self.view addSubview:self.shareView];

        [UKNetworkHelper POST:[NSString stringWithFormat:@"/user-center/share/live-video/%@",self.model.uuid] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
                    
        } failure:nil];
         
    }
}

#pragma mark -抽奖
- (IBAction)btn5:(id)sender {
        
    self.videolikechoujiang = [[[NSBundle mainBundle]loadNibNamed:@"HDzhibochouiangView" owner:nil options:nil]lastObject];
    self.videolikechoujiang.selectIndex = self.userDrawInteger;
    __weak __typeof(self) weakSelf = self;
    self.videolikechoujiang.Handler = ^{
        weakSelf.userDrawInteger = weakSelf.userDrawInteger + 1;
    };
    self.videolikechoujiang.model = self.model;
    [self.view addSubview:self.videolikechoujiang];
    [self.videolikechoujiang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

-(void)dismmHDCommentView {
    [self.commentView removeFromSuperview];
    self.commentView = nil;
    
}
#pragma mark - HDShareViewDelegate

//
- (void)hd_shareViewdidClickWchat {
    [self fenxiang:WXSceneSession];
}

//weixnpeng
- (void)hd_shareViewdidClickWchatZone {
    [self fenxiang:WXSceneTimeline];
}

- (void)fenxiang:(int)scene {
    
    [self.shareView removeFromSuperview];

    HDUkeConfigurationModel *ConfigurationModel = [HDUkeInfoCenter sharedCenter].configurationModel;
    NSString *url = [NSString stringWithFormat:@"%@live=1&uuid=%@",ConfigurationModel.shareURL,self.model.uuid];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shareNotification" object:self userInfo:@{@"url":url}];

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];

    WXWebpageObject *object = [[WXWebpageObject alloc] init];
    WXMediaMessage *message = [WXMediaMessage message];

    object.webpageUrl = url;
    message.mediaObject = object;
    UIImage *image = [UIImage imageNamed:HDBundleImage(@"navgation/WechatIM")];
    message.thumbData = UIImageJPEGRepresentation(image, 1.0f);
    message.title = self.model.title;
    message.description = @"更多精彩短视频，前往解放行司机版";
    req.message = message;
    req.scene = scene;
    req.bText = NO;
    [WXApi sendReq:req completion:^(BOOL success) {
        NSLog(@"sendReq %d", success);
    }];

    [HDServicesManager getuserVideoFenxiangCouponDataWithResuluuid:self.model.uuid block:^(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString) {

    }];
}

-(void)commentButtonAction {
    
}


//
- (void)hd_shareViewdidClickQQZone {
        
    HDUkeConfigurationModel *ConfigurationModel = [HDUkeInfoCenter sharedCenter].configurationModel;
    NSString *url = [NSString stringWithFormat:@"%@live=1&uuid=%@",ConfigurationModel.shareURL,self.model.uuid];

    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:url];
     if (pab == nil) {
         [SVProgressHUD showErrorWithStatus:@"复制失败"];
     }else
     {
        [SVProgressHUD showSuccessWithStatus:@"已复制"];
     }
}

- (void)hd_shareViewdidClickClose {
    self.shareView = nil;
    [self.shareView removeFromSuperview];

}

-(void)setuppingCount:(int)count {
    
    [self.commentButton setTitle:[NSString stringWithFormat:@"%@",[self stringToInt:[NSString stringWithFormat:@"%d",count]]] forState:UIControlStateNormal];
}

- (void)commentButtonAction:(UIButton *)sender {

    if (!self.commentView.superview) {
        self.commentView.islikeVideo = YES;
        self.commentView.videoUUID = self.model.uuid;
       
        [self.view addSubview:self.commentView];
    }

}

-(void)dianshi:(BOOL)isdianzan {
    if (isdianzan == YES) {//点赞
        if ([self.model.state intValue]== 14) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"event"] = @"like";
            dic[@"data"] = @{};
            [[SocketRocketUtility instance] sendData:[dic mj_JSONString]];
            
            int count = [self.model.likeCount intValue] + 1;
            self.model.likeCount = [NSNumber numberWithInt:count];
            self.model.isLiked = [NSNumber numberWithInt:1];
            self.likeView.likeCount.text = [self.model.likeCount stringValue];
            if ([self.model.isLiked intValue] == 1) {
                self.likeView.likeAfter.hidden = NO;
            }else {
                self.likeView.likeAfter.hidden = YES;
            }
            NSLog(@"点赞成功");
            if ([self.delegate respondsToSelector:@selector(userVideodianzan:)]) {
                [self.delegate userVideodianzan:self.model];
            }

        }else {
            [HDServicesManager getzhibodianzanDataWithResul:self.model.uuid block:^(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString) {
                if (isSuccess == YES) {
                    int count = [self.model.likeCount intValue] + 1;
                    self.model.likeCount = [NSNumber numberWithInt:count];
                    self.model.isLiked = [NSNumber numberWithInt:1];
                    self.likeView.likeCount.text = [self.model.likeCount stringValue];
                    if ([self.model.isLiked intValue] == 1) {
                        self.likeView.likeAfter.hidden = NO;
                    }else {
                        self.likeView.likeAfter.hidden = YES;
                    }
                    NSLog(@"点赞成功");
                    if ([self.delegate respondsToSelector:@selector(userVideodianzan:)]) {
                        [self.delegate userVideodianzan:self.model];
                    }
                }else {
                    NSLog(@"点赞失败");
                    self.likeView.likeAfter.hidden = YES;
                    [SVProgressHUD showErrorWithStatus:alertString];
                }
            }];
        }
        
        
       

    }else {
        
        if ([self.model.state intValue]== 14) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"event"] = @"dislike";
            dic[@"data"] = @{};
            [[SocketRocketUtility instance] sendData:[dic mj_JSONString]];
            
            int count = [self.model.likeCount intValue] - 1;
            self.model.likeCount = [NSNumber numberWithInt:count];
            self.model.isLiked = [NSNumber numberWithInt:0];;
            self.likeView.likeCount.text = [self.model.likeCount stringValue];
            if ([self.model.isLiked intValue] == 1) {
                self.likeView.likeAfter.hidden = NO;
            }else {
                self.likeView.likeAfter.hidden = YES;
            }
            if ([self.delegate respondsToSelector:@selector(userVideodianzan:)]) {
                [self.delegate userVideodianzan:self.model];
            }
            
        }else {
            [HDServicesManager getzhiboquxiaoDataWithResul:self.model.uuid block:^(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString) {
                if (isSuccess == YES) {
                    int count = [self.model.likeCount intValue] - 1;
                    self.model.likeCount = [NSNumber numberWithInt:count];
                    self.model.isLiked = [NSNumber numberWithInt:0];;
                    self.likeView.likeCount.text = [self.model.likeCount stringValue];
                    if ([self.model.isLiked intValue] == 1) {
                        self.likeView.likeAfter.hidden = NO;
                    }else {
                        self.likeView.likeAfter.hidden = YES;
                    }
                    if ([self.delegate respondsToSelector:@selector(userVideodianzan:)]) {
                        [self.delegate userVideodianzan:self.model];
                    }
                    
                    
                    NSLog(@"取消点赞");
                }else {
                    self.likeView.likeAfter.hidden = NO;
                    [SVProgressHUD showErrorWithStatus:alertString];
                    NSLog(@"取消点赞失败");
                }
            }];
        }
       
    }

}



-(void)stopController {
    [self.timer invalidate];
    self.timer = nil;
    
    [self.timerWork invalidate];
    self.timerWork = nil;
    // 停止
    [self.player stop];
    
    [self.playerView pause];
    self.playerView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - HDtuichuviewdddelegate
- (void)closetuichaView
{
    [[SocketRocketUtility instance] SRWebSocketClose];
    [self stopController];
    [self.navigationController popViewControllerAnimated:YES];
}

///关注主播,不迷路
- (void)foucsZhuboClickWithSender:(UIButton *)sender UserID:(NSString *)userID publisherId:(NSString *)publisherId flag:(NSString *)flag {
    [HDServicesManager getPayOrClearAttentionWithPublisherId:publisherId userId:userID flag:flag block:^(BOOL isSuccess, NSDictionary * _Nullable dataDic, NSString * _Nullable alertString) {
        if (isSuccess) {///改变按钮状态
            if (sender.isSelected) {
                sender.selected = NO;
            }else{
                sender.selected = YES;
            }
        }
    }];
}
///点击主播用户头像
- (void)anchorUserIconDidClick {
    [self recog];
}
#pragma mark - customfunc
//图片在上，文字在下
- (void)changeButtonType:(UIButton *)button {
    CGFloat interval = 4.0;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    CGSize imageSize = button.imageView.bounds.size;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width), 0, 0)];
    CGSize titleSize = button.titleLabel.bounds.size;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + interval, -(titleSize.width))];
}

@end
