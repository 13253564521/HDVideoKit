//
//  AVPlayerView.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "AVPlayerView.h"
#import "AVPlayerManager.h"

@interface AVPlayerView () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate,  AVAssetResourceLoaderDelegate>
@property (nonatomic ,strong) NSURL                *sourceURL;              //视频路径
@property (nonatomic ,strong) NSString             *sourceScheme;           //路径Scheme
@property (nonatomic ,strong) AVURLAsset           *urlAsset;               //视频资源
@property (nonatomic ,strong) AVPlayerItem         *playerItem;             //视频资源载体
@property (nonatomic ,strong) AVPlayerLayer        *playerLayer;            //视频播放器图形化载体
@property (nonatomic ,strong) id                   timeObserver;            //视频播放器周期性调用的观察者

@property (nonatomic, strong) NSMutableData        *data;                   //视频缓冲数据
@property (nonatomic, copy) NSString               *mimeType;               //资源格式
@property (nonatomic, assign) long long            expectedContentLength;   //资源大小
@property (nonatomic, strong) NSMutableArray       *pendingRequests;        //存储AVAssetResourceLoadingRequest的数组

@property (nonatomic, copy) NSString               *cacheFileKey;           //缓存文件key值
@property (nonatomic, strong) NSOperation          *queryCacheOperation;    //查找本地视频缓存数据的NSOperation
@property (nonatomic, strong) dispatch_queue_t     cancelLoadingQueue;

@property (nonatomic, assign) BOOL                 retried;
@end

@implementation AVPlayerView
//重写initWithFrame
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        //初始化存储AVAssetResourceLoadingRequest的数组
        _pendingRequests = [NSMutableArray array];
        
        //初始化播放器
        _player = [AVPlayer new];
        //添加视频播放器图形化载体AVPlayerLayer
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
//        _playerLayer.videoGravity = AVLayerVideoGravityResize;
        [self.layer addSublayer:_playerLayer];
        
        //初始化取消视频加载的队列
        _cancelLoadingQueue = dispatch_queue_create("com.start.cancelloadingqueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    //禁止隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _playerLayer.frame = self.layer.bounds;
    [CATransaction commit];
}

//设置播放路径
-(void)setPlayerWithUrl:(NSString *)url {
    //播放路径
    self.sourceURL = [NSURL URLWithString:url];
    
    //初始化AVURLAsset
    self.urlAsset = [AVURLAsset URLAssetWithURL:self.sourceURL options:nil];
    //设置AVAssetResourceLoaderDelegate代理
    [self.urlAsset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
    //初始化AVPlayerItem
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    //观察playerItem.status属性
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    //切换当前AVPlayer播放器的视频源
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    self.playerLayer.player = self.player;
    
//    NSLog(@"videoSize==%@===%@",NSStringFromCGSize(videoSize),NSStringFromCGRect([UIScreen mainScreen].bounds));
    
    //给AVPlayerLayer添加周期性调用的观察者，用于更新视频播放进度
    [self addProgressObserver];
}

//取消播放
-(void)cancelLoading {
    //暂停视频播放
    [self pause];
    
    //隐藏playerLayer
    [_playerLayer setHidden:YES];
    
    //取消查找本地视频缓存数据的NSOperation任务
    [_queryCacheOperation cancel];
    
    _player = nil;
    [_playerItem removeObserver:self forKeyPath:@"status"];
    _playerItem = nil;
    _playerLayer.player = nil;
    
    __weak __typeof(self) wself = self;
    dispatch_async(self.cancelLoadingQueue, ^{
        //取消AVURLAsset加载，这一步很重要，及时取消到AVAssetResourceLoaderDelegate视频源的加载，避免AVPlayer视频源切换时发生的错位现象
        [wself.urlAsset cancelLoading];
        wself.data = nil;
        //结束所有视频数据加载请求
        [wself.pendingRequests enumerateObjectsUsingBlock:^(id loadingRequest, NSUInteger idx, BOOL * stop) {
            if(![loadingRequest isFinished]) {
                [loadingRequest finishLoading];
            }
        }];
        [wself.pendingRequests removeAllObjects];
    });
    
    _retried = NO;
    
}

//更新AVPlayer状态，当前播放则暂停，当前暂停则播放
-(void)updatePlayerState {
    if(_player.rate == 0) {
        [self play];
    }else {
        [self pause];
    }
}

//播放
-(void)play {
    [[AVPlayerManager shareManager] play:_player];
}

//暂停
-(void)pause {
    [[AVPlayerManager shareManager] pause:_player];
}

//重新播放
-(void)replay {
    [[AVPlayerManager shareManager] replay:_player];
}

//播放速度
-(CGFloat)rate {
    return [_player rate];
}

//重新请求
-(void)retry {
    [self cancelLoading];
//    _sourceURL = [_sourceURL.absoluteString urlScheme:_sourceScheme];
    [self setPlayerWithUrl:_sourceURL.absoluteString];
    _retried = YES;
}


#pragma AVAssetResourceLoaderDelegate

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    //AVAssetResourceLoadingRequest请求被取消，移除视频加载请求
    [_pendingRequests removeObject:loadingRequest];
}


#pragma kvo

// 给AVPlayerLayer添加周期性调用的观察者，用于更新视频播放进度
-(void)addProgressObserver{
    __weak __typeof(self) weakSelf = self;
    //AVPlayer添加周期性回调观察者，一秒调用一次block，用于更新视频播放进度
    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 25) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if(weakSelf.playerItem.status == AVPlayerItemStatusReadyToPlay) {
            //获取当前播放时间
            float current = CMTimeGetSeconds(time);
            //获取视频播放总时间
            float total = CMTimeGetSeconds([weakSelf.playerItem duration]);
            //重新播放视频
            if(total == current) {
                [weakSelf replay];
            }
            //更新视频播放进度方法回调
            if(weakSelf.delegate) {
                [weakSelf.delegate onProgressUpdate:current total:total];
            }
        }
    }];
}

// 响应KVO值变化的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //AVPlayerItem.status
    if([keyPath isEqualToString:@"status"]) {
        if(_playerItem.status == AVPlayerItemStatusFailed) {
            if(!_retried) {
                [self retry];
            }
        }
        //视频源装备完毕，则显示playerLayer
        if(_playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [self.playerLayer setHidden:NO];
        }
        //视频播放状体更新方法回调
        if(self.delegate) {
            [_delegate onPlayItemStatusUpdate:_playerItem.status];
        }
    }else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_player removeTimeObserver:_timeObserver];
}

@end
