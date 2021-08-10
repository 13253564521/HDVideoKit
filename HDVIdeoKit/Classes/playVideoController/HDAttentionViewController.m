//
//  HDAttentionViewController.m
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/31.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDAttentionViewController.h"
#import "HDVideoTableViewCell.h"
#import "HDShareView.h"
#import "HDCommentView.h"
#import "Macro.h"
#import "AVPlayerManager.h"
#import "HDVideoModel.h"
#import "HDSearchViewController.h"
#import "HDUserReportViewController.h"
#import "HDServicesManager.h"
#import "HDUkeInfoCenter.h"
#import <JFWechat/JFWechat.h>
#import "LHDAFNetworking.h"
#import "HDUserVideoListModel.h"

@interface HDAttentionViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HDVideoTableViewCellDelegate,HDShareViewDelegate,HDCommentViewdelegate>
/** tableView */
@property(nonatomic , strong) UITableView *tableView;
/** f分享视图  */
@property(nonatomic,strong) HDShareView *shareView;
@property(nonatomic , strong)HDCommentView *commentView;

@property (nonatomic, assign) BOOL  isCurPlayerPause;

@property(nonatomic , strong)UIView *topView;

@property (nonatomic, assign) BOOL  isCurrenPause;




@end
static NSString *identifier_video = @"identifier_video_cell";
@implementation HDAttentionViewController

#pragma mark - 懒加载
- (HDShareView *)shareView {
    if (!_shareView) {
        _shareView = [[HDShareView alloc]initWithFrame:self.view.bounds];
        _shareView.delegate  = self;
    }
    return _shareView;
}

- (HDCommentView *)commentView {
    if (!_commentView) {
        _commentView = [[HDCommentView alloc]initWithFrame:self.view.frame];
        _commentView.delegate = self;
    }
    return _commentView;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)dealloc {
    [self removeVideo];
     
}

-(void)removeVideo {
    [_tableView.layer removeAllAnimations];
    NSArray<HDVideoTableViewCell *> *cells = [_tableView visibleCells];
    for(HDVideoTableViewCell *cell in cells) {
        [cell.playerView cancelLoading];
    }
    [[AVPlayerManager shareManager] removeAllPlayers];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"currentIndex"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
  
    if (self.isCurrenPause == YES) {
        [self applicationEnterBackground];
    }
    
    [self.topView removeFromSuperview];
    self.topView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isCurrenPause == YES) {
        [self applicationBecomeActive];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   

    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    if (!self.topView) {
        self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        [window addSubview:self.topView];

         UIButton *leftBUtton = [[UIButton alloc]initWithFrame:CGRectMake(20, GS_StatusBarHeight, 30, 30)];
         [leftBUtton setImage:[UIImage imageNamed:HDBundleImage(@"video/btn_back")] forState:0];
         [leftBUtton addTarget:self action:@selector(leftdidbutton) forControlEvents:UIControlEventTouchUpInside];
         [self.topView addSubview:leftBUtton];

                
         UIButton *rightBUtton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 50, GS_StatusBarHeight, 30,   30)];
         [rightBUtton setImage:[UIImage imageNamed:HDBundleImage(@"discover/btn_find_hd")] forState:0];
         [rightBUtton addTarget:self action:@selector(rightdidbutton) forControlEvents:UIControlEventTouchUpInside];
//         [self.topView addSubview:rightBUtton];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCurPlayerPause = NO;
  
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
           self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    
    [self setBackgroundImage:HDBundleImage(@"video/img_video_loading")];
    [self initTableView];
    
    LHDAFNetworkReachabilityManager *manager = [LHDAFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == -1 || status == 0) {
            NSLog(@"未连接网络");
            [self setNetworktixingwang:@"当前无网络"];
        }
        
        if (status == 1) {
            NSLog(@"3G/4G网络");
            [self setNetworktixingwang:@"当前为非Wi-Fi环境，请注意流量消耗"];
        }
        
        if (status == 2) {
            NSLog(@"Wifi网络");
        }
    }];
}


-(void)setNetworktixingwang:(NSString *)str{
  
    if ([HDUkeInfoCenter sharedCenter].userModel.isNetWorktixing == NO) {
           [SVProgressHUD showErrorWithStatus:str];
           [HDUkeInfoCenter sharedCenter].userModel.isNetWorktixing = YES;
    }
}

-(void)leftdidbutton {
    if ([self.delegate respondsToSelector:@selector(setupmodel)]) {
        [self.delegate setupmodel];
    }
    [self removeVideo];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.topView removeFromSuperview];
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = NO;
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 0.0;
    self.tableView.estimatedSectionFooterHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        [self.tableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    });

    
}

- (void)rightdidbutton {
    self.isCurrenPause = YES;
    HDSearchViewController *search = [[HDSearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
    [self.topView removeFromSuperview];
}

- (void)setBackgroundImage:(NSString *)imageName {
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.clipsToBounds = YES;
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.image = [UIImage imageNamed:imageName];
    [self.view addSubview:background];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *Identifier = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    [self.tableView registerClass:[HDVideoTableViewCell class] forCellReuseIdentifier:Identifier];
    HDVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    //填充视频数据
    HDUserVideoListModel *molde = self.dataArr[indexPath.row];
    cell.model = molde;
    cell.delegate = self;
    [cell prepareForReuse];
    [cell startDownloadBackgroundTask];
    return cell;
}

#pragma mark -
#pragma mark - ScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        //UITableView禁止响应其他滑动手势
        scrollView.panGestureRecognizer.enabled = NO;

        if(translatedPoint.y < -50 && self.currentIndex < (self.dataArr.count - 1)) {
            self.currentIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.y > 50 && self.currentIndex > 0) {
            self.currentIndex --;   //向上滑动索引递减
        }
        
        NSLog(@"currentIndex::%ld",(long)self.currentIndex);
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                //UITableView滑动到指定cell
                                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                            } completion:^(BOOL finished) {
                                //UITableView可以响应其他滑动手势
                                scrollView.panGestureRecognizer.enabled = YES;
                            }];

    });
}


//观察currentIndex变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentIndex"]) {

        //设置用于标记当前视频是否播放的BOOL值为NO
        _isCurPlayerPause = NO;

        //获取当前显示的cell
        HDVideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];

        [cell startDownloadBackgroundTask];
        __weak typeof (cell) wcell = cell;
           __weak typeof (self) wself = self;
        //判断当前cell的视频源是否已经准备播放
        if(cell.isPlayerReady) {
            //播放视频
            [cell replay];
        }else {
            if (self.currentIndex != 0) {
                [[AVPlayerManager shareManager] pauseAll];
            }
            //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
            cell.onPlayerReady = ^{
                NSIndexPath *indexPath = [wself.tableView indexPathForCell:wcell];
                if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
                    [wcell play];
                    HDUserVideoListModel *molde = self.dataArr[indexPath.row];
                    [HDServicesManager getgenxinvideoCouponDataWithResuluuid:molde.uuid block:^(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString) {
                                            
                    }];
                }
            };
        }

    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)dismmHDCommentView {
    [self.commentView removeFromSuperview];
    self.commentView = nil;
    
}
- (void)applicationBecomeActive {
    HDVideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    if(!_isCurPlayerPause) {
        [cell.playerView play];
    }
}

- (void)applicationEnterBackground {
    HDVideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    _isCurPlayerPause = ![cell.playerView rate];
    [cell.playerView pause];
}



#pragma mark - HDVideoTableViewCellDelegate
///关注按钮
- (void)hd_VideoTableViewCellDidClickFoucsSender:(UIButton *)sender userID:(NSString *)userID publisherId:(NSString *)publisherId flag:(NSString *)flag {
    [HDServicesManager getPayOrClearAttentionWithPublisherId:publisherId userId:userID flag:flag block:^(BOOL isSuccess, NSDictionary * _Nullable dataDic, NSString * _Nullable alertString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isSuccess) {
                if ([flag isEqualToString:@"0"]) {
                    [SVProgressHUD showSuccessWithStatus:@"关注成功!"];
                    sender.selected = YES;
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"取消关注成功!"];
                    sender.selected = NO;
                }
            }else{
                [SVProgressHUD showErrorWithStatus:[flag isEqualToString:@"0"] ? @"关注失败!" : @"取消关注失败!"];
                if ([flag isEqualToString:@"0"]) {
                    sender.selected = NO;
                }else{
                    sender.selected = YES;
                }
            }
        });
 
    }];
    
}
- (void)hd_VideoTableViewCellDidClickUserIcon:(NSString *)userID {
    self.isCurrenPause = YES;
    if ([self.hdprotocol respondsToSelector:@selector(hd_videoProtocolDidClickUserIconWithUserId:)]) {
        [self.hdprotocol hd_videoProtocolDidClickUserIconWithUserId:userID];
    }
}
- (void)hd_VideoTableViewCellDidClicklikeState:(BOOL)state {
    
}
- (void)hd_VideoTableViewCellDidClickComment:(NSString *)commentCount {
    if (!self.commentView.superview) {
        HDUserVideoListModel *model = self.dataArr[_currentIndex];
        self.commentView.videoUUID = model.uuid;
//        self.commentView.model = model;
        [self.view addSubview:self.commentView];
    }
}
- (void)hd_VideoTableViewCellDidClickForward {
    if (!self.shareView.superview) {
        [self.view addSubview:self.shareView];
    }
}
- (void)hd_VideoTableViewCellDidClickReport {
    self.isCurrenPause = YES;
    HDUserReportViewController *reportVc = [[HDUserReportViewController alloc]init];
    reportVc.isjubaoVideo = NO;
    reportVc.juboanetwo = YES;
    reportVc.title = @"举报视频";
    HDUserVideoListModel *model = self.dataArr[_currentIndex];
    reportVc.UUID= model.uuid;
    [self.navigationController pushViewController:reportVc animated:NO];
}


#pragma mark - 删除
-(void)hd_Videodel {
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"您将删除该视频" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *sureBtn1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull   action) {
        
        }];
       UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
           [self videodele];
       }];
       [alertVc addAction:sureBtn1];
       [alertVc addAction:sureBtn];
       //展示
       [self presentViewController:alertVc animated:YES completion:nil];
    
    
   
}

-(void)videodele{
    [self applicationEnterBackground];
    HDUserVideoListModel *model = self.dataArr[self.currentIndex];
    [HDServicesManager getshanchushipinCouponDataWithResulblock:model.uuid black:^(BOOL isSuccess, NSString * _Nullable alertString) {
        if (isSuccess == YES) {
            if ([self.delegate respondsToSelector:@selector(userdeleteVideo)]) {
                [self.delegate userdeleteVideo];
            }
            
            if (self.dataArr.count == 1) {
                  self.dataArr = [NSMutableArray array];
                  [self.tableView reloadData];
                [self.navigationController popViewControllerAnimated:YES];
              }else {
                  [self.dataArr removeObjectAtIndex:self.currentIndex];
                  [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currentIndex inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
              }
        }else{
            [SVProgressHUD showErrorWithStatus:@"删除失败，请稍后重试!"];
        }
    }];
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
    
    HDUserVideoListModel *model = self.dataArr[self.currentIndex];
    
    
    [self.shareView removeFromSuperview];
    
    HDUkeConfigurationModel *ConfigurationModel = [HDUkeInfoCenter sharedCenter].configurationModel;
    NSString *url = [NSString stringWithFormat:@"%@uuid=%@",ConfigurationModel.shareURL,model.uuid];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shareNotification" object:self userInfo:@{@"url":url}];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    
    WXWebpageObject *object = [[WXWebpageObject alloc] init];
    WXMediaMessage *message = [WXMediaMessage message];
    
    object.webpageUrl = url;
    message.mediaObject = object;
    UIImage *image = [UIImage imageNamed:HDBundleImage(@"navgation/WechatIM")];
    message.thumbData = UIImageJPEGRepresentation(image, 1.0f);
    message.title = model.title;
    message.description = @"更多精彩短视频，前往解放行司机版";
    req.message = message;
    req.scene = scene;
    req.bText = NO;
    [WXApi sendReq:req completion:^(BOOL success) {
        NSLog(@"sendReq %d", success);
    }];

    [HDServicesManager getuserVideoFenxiangCouponDataWithResuluuid:model.uuid block:^(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString) {
            
    }];
}

//
- (void)hd_shareViewdidClickWebUrl {
        
    HDUserVideoListModel *model = self.dataArr[self.currentIndex];

    HDUkeConfigurationModel *ConfigurationModel = [HDUkeInfoCenter sharedCenter].configurationModel;
    NSString *url = [NSString stringWithFormat:@"%@uuid=%@",ConfigurationModel.shareURL,model.uuid];
    
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:url];
     if (pab == nil) {
         [SVProgressHUD showErrorWithStatus:@"复制失败"];
     }else
     {
        [SVProgressHUD showSuccessWithStatus:@"已复制"];
     }
}

-(void)setuppingCount:(int)count {
    HDVideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    [cell.commentButton setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
}
- (void)hd_shareViewdidClickClose {
    self.shareView = nil;
    [self.shareView removeFromSuperview];

}

@end 
