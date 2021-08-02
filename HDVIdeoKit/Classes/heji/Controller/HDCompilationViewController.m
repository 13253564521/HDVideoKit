//
//  HDCompilationViewController.m
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/28.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//合辑

#import "HDCompilationViewController.h"
#import "SGPagingView.h"
#import "HDDiscoverViewController.h"

#import "UKNetworkHelper.h"
#import "UKRequestURLPath.h"
#import "HDCompilationModel.h"
#import "Macro.h"
@interface HDCompilationViewController ()<SGPageTitleViewDelegate, SGPageContentCollectionViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;
@end

@implementation HDCompilationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"合辑";
    
    [SVProgressHUD show];
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_albums parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if (![[code stringValue] isEqualToString:@"0"]) {
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
            return ;
        }
        NSArray *dataArr = [HDCompilationModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        
        if (dataArr.count > 0) {
            [self setupView:dataArr];
        }
       
        [SVProgressHUD dismiss];
      } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
          [SVProgressHUD showErrorWithStatus:@"加载失败"];
      }];
 
}


- (void)setupView:(NSArray<HDCompilationModel *>*)model {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (HDCompilationModel *model1 in model) {
        [arr addObject:model1.name];
    }
    
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleTextZoom = YES;
    configure.titleTextZoomRatio = 0.5;
    configure.titleAdditionalWidth = 30;
    configure.titleGradientEffect = YES;

    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self titleNames:arr configure:configure];
    [self.pageTitleView resetTitleColor:UkeColorHex(0x333333) titleSelectedColor:UkeColorHex(0x749CFF) indicatorColor:UkeColorHex(0x749CFF)];
    [self.view addSubview:_pageTitleView];
    
    NSMutableArray *vcArr = [NSMutableArray array];
    for (HDCompilationModel *model1 in model) {
        HDDiscoverViewController *vc =[[HDDiscoverViewController alloc]init];
        vc.discoverDataModel = model1;
        [vcArr addObject:vc];
    }
    
    CGFloat ContentCollectionViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, ContentCollectionViewHeight) parentVC:self childVCs:vcArr];
    _pageContentCollectionView.delegatePageContentCollectionView = self;
    [self.view addSubview:_pageContentCollectionView];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentCollectionView setPageContentCollectionViewCurrentIndex:selectedIndex];
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}
@end
