//
//  HDDiscoverBaseViewController.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/11.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDDiscoverBaseViewController.h"
#import "HDDiscoverViewController.h"
#import "UKNetworkHelper.h"
#import "UKRequestURLPath.h"
#import "Macro.h"
#import "HDCoomCollectionView.h"
#import "HDshangchuanViewController.h"
#import "HDAttentionViewController.h"
#import "HDUkeInfoCenter.h"
#import "HDServicesManager.h"
#import "HDAlertView.h"
#import "HDwbViewController.h"
#import "HDCustomTabBar.h"
#import "SGPageTitleViewConfigure.h"
#import "SGPageTitleView.h"
#import "SGPageContentCollectionView.h"
#import "HDzhibolistViewController.h"
@interface HDDiscoverBaseViewController ()<HDCoomCollectionViewDelagete,HDAlertViewdelegate,HDAttentionViewControllerdelegate,SGPageTitleViewDelegate, SGPageContentCollectionViewDelegate>
@property (nonatomic, strong) HDCoomCollectionView *vc;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isNetWork;
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;
@end

@implementation HDDiscoverBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNumber *state =[HDUkeInfoCenter sharedCenter].userModel.state;
    
    if ([state intValue] == 6) {
        HDAlertView *alerVIew = [HDAlertView showView:self.view];
         alerVIew.dalegate = self;
    }else {
        [self addview];
        [self.vc loadNewData];
        [self network1];
    }
    
    
    __weak __typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer timerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            if (weakSelf.isNetWork == NO) {
                weakSelf.isNetWork = YES;
                [HDServicesManager getxiaoxishuCouponDataWithResuluuid:@"3" state:@"2" block:^(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString) {
                    
                    if (isSuccess == YES) {
                        NSNumber *num = dic[@"count"];
                        if ([num intValue] > 0) {
                            [[HDCustomTabBar sharedManager]showxiaoxi];
                        }else {
                            [[HDCustomTabBar sharedManager]dismmxiaoxi];
                        }
                    }
                    weakSelf.isNetWork = NO;
                }];
            }
            
        }];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

    } else {
        // Fallback on earlier versions
    }

    
    
    [UKNetworkHelper GET:@"/setting/activities" parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
 
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        
    }];
}

-(void)network1 {
    
//    [HDUkeInfoCenter sharedCenter].userModel.liveVideo = 1;

    [UKNetworkHelper GET:@"/user-center/profile" parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            NSNumber *number = response[@"data"][@"liveVideo"];
            [HDUkeInfoCenter sharedCenter].userModel.liveVideo = [number intValue];
            
            NSNumber *liveVideoDevice = response[@"data"][@"liveVideoDevice"];
            [HDUkeInfoCenter sharedCenter].userModel.liveVideoDevice = [liveVideoDevice stringValue];
            NSLog(@"111:=%d--%d",[number intValue],[liveVideoDevice intValue]);
        }
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {

    }];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath data:(nonnull NSMutableArray *)data {
    HDAttentionViewController *detailVc = [[HDAttentionViewController alloc]init];
    detailVc.delegate = self;
//    HDUserVideoListModel *model = data[indexPath.row];
    detailVc.dataArr= data;
    detailVc.currentIndex = indexPath.item;
    [self.navigationController pushViewController:detailVc animated:NO];
    
}

-(void)setupmodel {
    [self.vc.collectionView reloadData];
}

-(void)tongyi{
    [HDServicesManager getxieyilun1CouponDataWithResulblock:^(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString) {
        
    }];
    [self addview];
}

-(void)didxieyi {
    HDwbViewController *webvie =[[HDwbViewController alloc]init];
    [self.navigationController pushViewController:webvie animated:YES];
}

-(void)dismms{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"需同意个人信息保护指引才能继续使用卡友视频功能" message:@"如不同意该指引，很遗憾，您将无法使用卡友视频功能" preferredStyle:UIAlertControllerStyleAlert];

       UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"退出功能" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull   action) {
           [self.delegate popviewcontrooler];
       }];
    
        UIAlertAction *sureBtn1 = [UIAlertAction actionWithTitle:@"查看指引" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull   action) {
            HDAlertView *alerVIew = [HDAlertView showView:self.view];
            alerVIew.dalegate = self;
        }];

        [alertVc addAction:sureBtn];
        [alertVc addAction:sureBtn1];
       //展示
       [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)addview {
    
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleTextZoom = YES;
    configure.titleTextZoomRatio = 0.5;
    configure.titleAdditionalWidth = 30;
    configure.titleGradientEffect = YES;

    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self titleNames:@[@"短视频",@"直播"] configure:configure];
    [self.pageTitleView resetTitleColor:UkeColorHex(0x333333) titleSelectedColor:UkeColorHex(0x749CFF) indicatorColor:UkeColorHex(0x749CFF)];
    [self.view addSubview:_pageTitleView];
    
    
    
    self.vc =[[HDCoomCollectionView alloc]init];
    self.vc.delegate =self;

    HDzhibolistViewController *listvc = [[HDzhibolistViewController alloc]init];
    
    
    NSMutableArray *vcArr = [NSMutableArray array];
    [vcArr addObject:self.vc];
    [vcArr addObject:listvc];

    
    CGFloat ContentCollectionViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame) - GS_TabbarHeight - 20;
    self.pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, ContentCollectionViewHeight) parentVC:self childVCs:vcArr];
    _pageContentCollectionView.delegatePageContentCollectionView = self;
    [self.view addSubview:_pageContentCollectionView];
}

-(void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentCollectionView setPageContentCollectionViewCurrentIndex:selectedIndex];
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}
@end
