//
//  HDVideoTableViewCell.m
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/31.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDVideoTableViewCell.h"
#import "HDTopImageBottomTextButton.h"
#import "HDLikeView.h"
#import "Macro.h"
#import "HDServicesManager.h"
#import "HDUkeInfoCenter.h"
#import "NSDate+MJ.h"

@interface HDVideoTableViewCell()<AVPlayerUpdateDelegate,HDLikeViewdelegate>
@property (nonatomic, strong) UIView  *container;
/** 用户头像 */
@property(nonatomic,strong) UIImageView *userIconImageView;
@property (nonatomic, strong) NSTimer *progressTimer;

/** 点赞 */
@property(nonatomic,strong) HDLikeView *likeView;

/** 转发 */
@property(nonatomic,strong) HDTopImageBottomTextButton *forwardButton;
/** 举报 */
@property(nonatomic,strong) UIButton *reportButton;

/** 主  标题 */
@property(nonatomic,strong) UILabel *title;
/** 副标题 */
@property(nonatomic,strong) UILabel *detailTitle;

@property(nonatomic,strong) UILabel *timetitle;
@property (nonatomic, strong) UITapGestureRecognizer   *singleTapGesture;
@property (nonatomic ,strong) UIImageView              *pauseIcon;
@property (nonatomic, assign) NSTimeInterval           lastTapTime;
@property (nonatomic, strong) UIView                   *playerStatusBar;//加载显示VIew

@property (nonatomic, assign) BOOL isNetWork;

@property (strong, nonatomic)UISlider *slider;
/**关注 */
@property (strong, nonatomic)UIButton  *foucsButton;

/** 是否关注标识 */
@property(nonatomic,copy) NSString *flag;
@end
@implementation HDVideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.isNetWork = NO;
        self.backgroundColor = [UIColor blackColor];
        
//        self.backImageView = [[UIImageView alloc] init];
//        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [self.contentView addSubview:self.backImageView];
//        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self.contentView);
//        }];
        
        _playerView = [AVPlayerView new];
        _playerView.delegate = self;
        [self.contentView addSubview:_playerView];

        _container = [UIView new];
        [self.contentView addSubview:_container];
       
        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [_container addGestureRecognizer:_singleTapGesture];
        

        
        
        _pauseIcon = [[UIImageView alloc] init];
        _pauseIcon.image = [UIImage imageNamed:HDBundleImage(@"video/icon_play_pause")];
        _pauseIcon.contentMode = UIViewContentModeCenter;
        _pauseIcon.layer.zPosition = 3;
        _pauseIcon.hidden = YES;
        [_container addSubview:_pauseIcon];
        [_pauseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(100);
        }];
        
        self.detailTitle = [[UILabel alloc]init];
        self.detailTitle.textColor = [UIColor whiteColor];
        self.detailTitle.textAlignment = NSTextAlignmentLeft;
        self.detailTitle.numberOfLines = 3;
        self.detailTitle.font = [UIFont systemFontOfSize:16];
//        self.detailTitle.text = @"解放的虎VR车型的日常保养";
        [_container addSubview:self.detailTitle];
        
        self.title = [[UILabel alloc]init];
        self.title.textColor = [UIColor whiteColor];
        self.title.numberOfLines = 0;
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont boldSystemFontOfSize:18];
        [_container addSubview:self.title];
        
        //由底部向上添加
        self.reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reportButton.titleLabel.font = [UIFont  systemFontOfSize:12];
        [self.reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.reportButton setTitle:@"举报" forState:UIControlStateNormal];
        [self.reportButton setImage:[UIImage imageNamed:HDBundleImage(@"discover/icon_report")] forState:UIControlStateNormal];
        [self.reportButton addTarget:self action:@selector(reportButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_container addSubview:self.reportButton];
      
        
        
        self.forwardButton = [HDTopImageBottomTextButton buttonWithType:UIButtonTypeCustom];
        self.forwardButton.titleLabel.font = [UIFont  systemFontOfSize:12];
        [self.forwardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.forwardButton setTitle:@"转发" forState:UIControlStateNormal];
        [self.forwardButton setImage:[UIImage imageNamed:HDBundleImage(@"video/icon_bicolor_article_share")] forState:UIControlStateNormal];
        [self.forwardButton addTarget:self action:@selector(forwardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_container addSubview:self.forwardButton];

        
        self.commentButton = [HDTopImageBottomTextButton buttonWithType:UIButtonTypeCustom];
        self.commentButton.titleLabel.font = [UIFont  systemFontOfSize:12];
        [self.commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [self.commentButton setImage:[UIImage imageNamed:HDBundleImage(@"discover/icon_comment")] forState:UIControlStateNormal];
        [self.commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_container addSubview:self.commentButton];
        
        
        self.likeView = [[HDLikeView alloc]init];
        self.likeView.likeDuration = 0.5;
        self.likeView.hdFillColor = RGBA(37, 96, 246, 1);
        self.likeView.delegate = self;
        [_container addSubview:self.likeView];
        
        self.userIconImageView = [[UIImageView alloc]init];
        self.userIconImageView.userInteractionEnabled = YES;
        self.userIconImageView.image = [UIImage imageNamed:HDBundleImage(@"testIcon")];
        [_container addSubview:self.userIconImageView];
        
        self.foucsButton = [HDTopImageBottomTextButton buttonWithType:UIButtonTypeCustom];
        [self.foucsButton setBackgroundImage:[UIImage imageNamed:HDBundleImage(@"discover/icon_shipin_xq_jiaguanzhu")] forState:UIControlStateNormal];
        [self.foucsButton setBackgroundImage:[UIImage imageNamed:HDBundleImage(@"discover/icon_shipin_xq_yiguanzhu")] forState:UIControlStateSelected];
        [self.foucsButton addTarget:self action:@selector(foucsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_container addSubview:self.foucsButton];
    
        
        
        
        //点击手势
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userIconClick)];
        [self.userIconImageView addGestureRecognizer:tapGes];
        
        _playerStatusBar = [[UIView alloc]init];
        _playerStatusBar.backgroundColor = [UIColor whiteColor];
        [_playerStatusBar setHidden:YES];
        [_container addSubview:_playerStatusBar];
        
        [_playerStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(49.5f + 0);
            make.width.mas_equalTo(1.0f);
            make.height.mas_equalTo(0.5f);
        }];
        
        
        self.timetitle = [[UILabel alloc]init];
        self.timetitle.font = [UIFont systemFontOfSize:14];
        self.timetitle.textColor = [UIColor whiteColor];
        [_container addSubview:self.timetitle];
        [self.timetitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_right).offset(10);
            make.centerY.equalTo(self.title.mas_centerY);
        }];
        
        
        self.slider = [[UISlider alloc]init];
        self.slider.backgroundColor = UIColor.clearColor;
        [self.slider setValue:0 animated:NO];
        self.slider.minimumValue = 0.0;
        self.slider.maximumValue = 1.0;
        [self.slider addTarget:self action:@selector(dragSliderDidStart:) forControlEvents:UIControlEventTouchDown];
        [self.slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventTouchUpInside];
        [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
//        self.slider.minimumTrackTintColor = [UIColor whiteColor];
//        self.slider.maximumTrackTintColor = [UIColor whiteColor];
//        self.slider.thumbTintColor = [UIColor whiteColor];
        [self.slider setMaximumTrackImage:[UIImage imageNamed:HDBundleImage(@"currency/MaximumTrackImage")] forState:0];
        [self.slider setMinimumTrackImage:[UIImage imageNamed:HDBundleImage(@"currency/MinimumTrackImage")] forState:0];
        [self.slider setThumbImage:[UIImage imageNamed:HDBundleImage(@"currency/jp_videoplayer_progress_handler_normal")] forState:0];
        [self.slider setThumbImage:[UIImage imageNamed:HDBundleImage(@"currency/jp_videoplayer_progress_handler_normal")] forState:UIControlStateHighlighted];
        [_container addSubview:self.slider];
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.right.equalTo(self.mas_right).offset(-16);
            make.bottom.equalTo(self.mas_bottom).offset(- GS_TabbarSafeBottomMargin);
        }];
        
        [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.right.equalTo(self.mas_right).offset(-16);
            make.bottom.equalTo(self.slider.mas_top).offset(-10);
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.detailTitle.mas_left);
            make.width.mas_equalTo(150);
            make.bottom.equalTo(self.detailTitle.mas_top).offset(-10);
        }];
        
        [self addProgressTimer];
    }
    return self;
}


-(void)addProgressTimer {
    if (self.progressTimer == nil) {
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
    }
}

-(void)updateProgressInfo {
    AVPlayerItem *currentItem = self.playerView.player.currentItem;
    CMTime duration = currentItem.duration; //total time
    CMTime currentTime = currentItem.currentTime; //playing time
    
    if (CMTimeGetSeconds(currentTime) > 0) {
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        CGFloat currentTime1 = CMTimeGetSeconds(currentTime);
        [self.slider setValue:currentTime1/totalDuration animated:YES];
    }
}

-(void)slider:(UISlider*)sender {
    
    
    AVPlayerItem *currentItem = self.playerView.player.currentItem;
    CMTime duration = currentItem.duration; //total time
    
    CGFloat totalDuration = CMTimeGetSeconds(duration);
    CMTime tom = duration;
    [self.playerView.player seekToTime:CMTimeMakeWithSeconds(totalDuration * sender.value,tom.timescale)];
    [self addProgressTimer];
}

-(void)sliderValueChange:(UISlider*)sender {
    
}


-(void)dragSliderDidStart:(UISlider*)sender {
    [self removeProgressTimer];
}
-(void)removeProgressTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

-(void)setModel:(HDUserVideoListModel *)model {
    _model = model;
    [self getUserRelationShipWithModel:model];
    
    self.title.text = [NSString stringWithFormat:@"@%@",model.nickName];
    
    self.likeView.likeCount.text = [self stringToInt:[model.likeCount stringValue]];
    self.detailTitle.text = model.title;
    self.userIconImageView.yy_imageURL = [NSURL URLWithString:model.avatar];
    [self.userIconImageView yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];

    NSDate *date = [[NSDate alloc]init];
    self.timetitle.text = [date timeStringWithTimeInterval:model.createTime];
    if ([model.userUuid isEqualToString:[HDUkeInfoCenter sharedCenter].userModel.uuid]) {
        [self.reportButton setImage:[UIImage imageNamed:HDBundleImage(@"discover/icon_5_delete")] forState:UIControlStateNormal];
        [self.reportButton setTitle:@"" forState:UIControlStateNormal];

    }else {
        [self.reportButton setImage:[UIImage imageNamed:HDBundleImage(@"discover/icon_report")] forState:UIControlStateNormal];
        [self.reportButton setTitle:@"举报" forState:UIControlStateNormal];
    }
    
    self.likeView.likeAfter.hidden = !model.isLiked;

        
    [HDServicesManager getVideoXiaqCouponDataWithResulblock:self.model.uuid black:^(BOOL isSuccess, HDUserVideoListModel * _Nullable cellModel, NSString * _Nullable alertString) {
        if (isSuccess == YES) {
            
            [self.commentButton setTitle:[NSString stringWithFormat:@"%@",[self stringToInt:cellModel.commentCount]] forState:UIControlStateNormal];
        }
    }];
   
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    _isPlayerReady = NO;
    [_playerView cancelLoading];
    [_pauseIcon setHidden:YES];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat rightMagin = 24;
    CGFloat bottomMagin = 146 + GS_TabbarSafeBottomMargin ;

    
    CGFloat topImageBottomTextW = 30;
    CGFloat topImageBottomTextH = 49;
    CGFloat itemM = 24;
    
    CGFloat userIconWH = 44;
    
    _playerView.frame = self.bounds;
    _container.frame = self.bounds;
    
    self.reportButton.frame = CGRectMake(self.contentView.frame.size.width - rightMagin - topImageBottomTextW, self.contentView.frame.size.height - bottomMagin - topImageBottomTextH, topImageBottomTextW, topImageBottomTextH);
    self.forwardButton.frame = CGRectMake(self.reportButton.frame.origin.x, self.reportButton.frame.origin.y - itemM - topImageBottomTextH, topImageBottomTextW, topImageBottomTextH);
    self.commentButton.frame = CGRectMake(self.forwardButton.frame.origin.x, self.forwardButton.frame.origin.y - itemM - topImageBottomTextH, topImageBottomTextW, topImageBottomTextH);
    self.likeView.frame = CGRectMake(self.forwardButton.frame.origin.x, self.commentButton.frame.origin.y - itemM - topImageBottomTextH, topImageBottomTextW, topImageBottomTextH);
    

    self.userIconImageView.frame = CGRectMake(self.forwardButton.frame.origin.x + topImageBottomTextW *0.5 - userIconWH * 0.5 , self.likeView.frame.origin.y - 53 - userIconWH, userIconWH, userIconWH);
    self.userIconImageView.layer.mask = [self cicleMaskLayerWithImageView:self.userIconImageView];
    
    
    self.foucsButton.frame = CGRectMake(self.userIconImageView.frame.origin.x + 3, CGRectGetMaxY(self.userIconImageView.frame) - 3, self.foucsButton.currentBackgroundImage.size.width, self.foucsButton.currentBackgroundImage.size.height);
    
    [self changeButtonType:self.reportButton];
    [self changeButtonType:self.forwardButton];
    [self changeButtonType:self.commentButton];
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

- (void)singleTapAction {
 
    [self showPauseViewAnim:[_playerView rate]];
    [_playerView updatePlayerState];
    
}

//暂停播放动画
- (void)showPauseViewAnim:(CGFloat)rate {
    if(rate == 0) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.pauseIcon.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             [self.pauseIcon setHidden:YES];
                         }];
    }else {
        [_pauseIcon setHidden:NO];
        _pauseIcon.transform = CGAffineTransformMakeScale(1.8f, 1.8f);
        _pauseIcon.alpha = 1.0f;
        [UIView animateWithDuration:0.25f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.pauseIcon.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                            } completion:^(BOOL finished) {
                            }];
    }
}

//加载动画
-(void)startLoadingPlayItemAnim:(BOOL)isStart {
    if (isStart) {
        _playerStatusBar.backgroundColor = [UIColor whiteColor];
        [_playerStatusBar setHidden:NO];
        [_playerStatusBar.layer removeAllAnimations];
        
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.duration = 0.5;
        animationGroup.beginTime = CACurrentMediaTime() + 0.5;
        animationGroup.repeatCount = MAXFLOAT;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animation];
        scaleAnimation.keyPath = @"transform.scale.x";
        scaleAnimation.fromValue = @(1.0f);
        scaleAnimation.toValue = @(1.0f * [UIScreen mainScreen].bounds.size.width);
        
        CABasicAnimation * alphaAnimation = [CABasicAnimation animation];
        alphaAnimation.keyPath = @"opacity";
        alphaAnimation.fromValue = @(1.0f);
        alphaAnimation.toValue = @(0.5f);
        [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
        [self.playerStatusBar.layer addAnimation:animationGroup forKey:nil];
    } else {
        [self.playerStatusBar.layer removeAllAnimations];
        [self.playerStatusBar setHidden:YES];
    }
    
}

// AVPlayerUpdateDelegate
-(void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
  
}

-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status {
    switch (status) {
        case AVPlayerItemStatusUnknown:
            [self startLoadingPlayItemAnim:YES];
            break;
        case AVPlayerItemStatusReadyToPlay:
            [self startLoadingPlayItemAnim:NO];
            
            _isPlayerReady = YES;
            
            if(_onPlayerReady) {
                _onPlayerReady();
            }
            break;
        case AVPlayerItemStatusFailed:
            [self startLoadingPlayItemAnim:NO];
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            break;
        default:
            break;
    }
}



- (CALayer *)cicleMaskLayerWithImageView:(UIImageView *)imageView {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = imageView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    
    return maskLayer;
}

- (void)play {
    [_playerView play];
    [_pauseIcon setHidden:YES];
}

- (void)pause {
    [_playerView pause];
    [_pauseIcon setHidden:NO];
}

- (void)replay {
    [_playerView replay];
    [_pauseIcon setHidden:YES];
}

- (void)startDownloadBackgroundTask {
    

//    [_playerView setPlayerWithUrl:@"https://live.huidi-data.com/0fca19664949e14e97974767c564c6dd/wt1p3/165988802c7e4a6ab272b24a90001284.mp4"];
    [_playerView setPlayerWithUrl:self.model.videoUrl];
}

#pragma mark - buttonFountion
- (void)reportButtonAction:(UIButton *)sender {
    
    if ([self.model.userUuid isEqualToString:[HDUkeInfoCenter sharedCenter].userModel.uuid]) {
        if ([self.delegate respondsToSelector:@selector(hd_Videodel)]) {
            [self.delegate hd_Videodel];
        }

    }else {
        if ([self.delegate respondsToSelector:@selector(hd_VideoTableViewCellDidClickReport)]) {
            [self.delegate hd_VideoTableViewCellDidClickReport];
        }

    }
    
}

- (void)forwardButtonAction:(UIButton *)sender {
        NSLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(hd_VideoTableViewCellDidClickForward)]) {
        [self.delegate hd_VideoTableViewCellDidClickForward];
    }
}
- (void)commentButtonAction:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(hd_VideoTableViewCellDidClickComment:)]) {
        [self.delegate hd_VideoTableViewCellDidClickComment:@"0"];
    }
}
- (void)likeButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
        NSLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(hd_VideoTableViewCellDidClicklikeState:)]) {
        [self.delegate hd_VideoTableViewCellDidClicklikeState:sender.isSelected];
    }
}

- (void)userIconClick {
     NSLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(hd_VideoTableViewCellDidClickUserIcon:)]) {
        [self.delegate hd_VideoTableViewCellDidClickUserIcon:self.model.userUuid];
    }
}

- (void)foucsButtonAction:(UIButton *)sender {///关注
    NSLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(hd_VideoTableViewCellDidClickFoucsSender:userID:publisherId:flag:)]) {
        [self.delegate hd_VideoTableViewCellDidClickFoucsSender:sender userID:self.model.userUuid publisherId:self.model.uuid flag:sender.isSelected ? @"1":@"0"];
    }
}

-(void)dianshi:(BOOL)isdianzan {
        
    if (isdianzan == YES) {//点赞

        int count = [self.model.likeCount intValue] + 1;
        self.model.likeCount = [NSNumber numberWithInt:count];
        self.model.isLiked = YES;
        [self setModel:self.model];
        
        [HDServicesManager getdianzanCouponDataWithResulblock:self.model.uuid black:^(BOOL isSuccess, NSString * _Nullable alertString) {
//            if (isSuccess == YES) {
//                NSLog(@"点赞成功");
//
//            }else {
//                [SVProgressHUD showErrorWithStatus:alertString];
//                self.likeView.likeAfter.hidden = YES;
//            }
        }];
    }else {

        [HDServicesManager getquxiaodianzanCouponDataWithResulblock:self.model.uuid black:^(BOOL isSuccess, NSString * _Nullable alertString) {
            if (isSuccess == YES) {
                NSLog(@"取消点赞");
                int count = [self.model.likeCount intValue] - 1;
                self.model.likeCount = [NSNumber numberWithInt:count];
                self.model.isLiked = NO;
                [self setModel:self.model];
            }
        }];
    }
//

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

#pragma mark - 查询关系
- (void)getUserRelationShipWithModel:(HDUserVideoListModel *)model
{
    @WeakObj(self);
    [HDServicesManager getUserRelationShipWithPublisherId:model.uuid userId:model.userUuid block:^(BOOL isSuccess, NSString * _Nullable judge, NSString * _Nullable alertString) {
        if (isSuccess) {
            selfWeak.foucsButton.hidden = NO;
            selfWeak.flag = judge;
            if ([judge isEqualToString:@"0"]) {
                selfWeak.foucsButton.selected = NO;
            }else{
                selfWeak.foucsButton.selected = YES;
            }
            
        }else{
            selfWeak.foucsButton.hidden = YES;
        }
    }];
    
}

@end
