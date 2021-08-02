//
//  HDCoomCollectionView.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/16.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDCoomCollectionView.h"
#import "HDWaterfallLayout.h"
#import "Macro.h"
#import "HDDiscoverCollectionViewCell.h"
#import "UKNetworkHelper.h"
#import "UKRequestURLPath.h"
#import "HDServicesManager.h"
@interface HDCoomCollectionView()<UICollectionViewDelegate , UICollectionViewDataSource,HDWaterfallLayoutDelegate>
/** 当前页码 */  // 上啦加载必要的参数
@property (nonatomic, assign) int page;
@property (nonatomic, strong) UKBaseRequest *request;
@property (nonatomic, strong)NSMutableArray <HDUserVideoListModel*> *dataArr;

@end

static NSString *dicoverIdentifier = @"dicoverIdentifier_cell";

@implementation HDCoomCollectionView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewData];
 
    CGFloat leftMargin = 16;
   
    HDWaterfallLayout *layout = [HDWaterfallLayout waterFallLayoutWithColumnCount:2];
    [layout setColumnSpacing:16 rowSpacing:15 sectionInset:UIEdgeInsetsMake(12, leftMargin, 0, leftMargin)];
    layout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = RGB(237, 237, 237);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[HDDiscoverCollectionViewCell class] forCellWithReuseIdentifier:dicoverIdentifier];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.top.bottom.mas_equalTo(self.view);
    }];

     self.collectionView.mj_header=[MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
     
     
     // 自动改变透明度
    self.collectionView.mj_header.automaticallyChangeAlpha=YES;
    self.collectionView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)loadNewData {
    // 结束上啦
    [self.collectionView.mj_footer endRefreshing];
       
    if (self.request.isRequesting) {
        [self.request cancelCurrentRequest];
    }
    
    int page = 1;
    [HDServicesManager getlistfaxinCouponDataWithResultage:page size:20 lastVideoUuid:@"" block:^(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString) {
        self.dataArr = arr;
        self.page = page;
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    }];
}

-(void)loadMoreData {
    [self.collectionView.mj_header endRefreshing];
     
    if (self.request.isRequesting) {
        [self.request cancelCurrentRequest];
    }

    HDUserVideoListModel * model  = self.dataArr.lastObject;
    int page = self.page + 1;
    
    [HDServicesManager getlistfaxinCouponDataWithResultage:page size:20 lastVideoUuid:model.uuid block:^(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString) {
        [self.dataArr addObjectsFromArray:arr];
        [self.collectionView.mj_footer endRefreshing];
         if (arr.count > 0) {
          self.page = page;
         }else {
             [self.collectionView.mj_footer endRefreshingWithNoMoreData];
         }
        [self.collectionView reloadData];

    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.collectionView.mj_footer.hidden = self.dataArr.count >7?NO:YES;
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDDiscoverCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dicoverIdentifier forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    HDUserVideoListModel * model = self.dataArr[indexPath.row];

    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:data:)]) {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath data:self.dataArr];
    }
}

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(HDWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    HDUserVideoListModel *model = self.dataArr[indexPath.item];
    return model.cellHeight;
}
@end
