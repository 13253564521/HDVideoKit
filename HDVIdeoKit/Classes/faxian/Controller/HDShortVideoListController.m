//
//  HDShortVideoListController.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/28.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDShortVideoListController.h"
#import "HDWaterfallLayout.h"
#import "Macro.h"
#import "HDDiscoverCollectionViewCell.h"
#import "UKNetworkHelper.h"
#import "UKRequestURLPath.h"
#import "HDServicesManager.h"
#import "HDAttentionViewController.h"

@interface HDShortVideoListController ()<UICollectionViewDelegate , UICollectionViewDataSource,HDWaterfallLayoutDelegate,HDAttentionViewControllerdelegate>
@property (nonatomic, strong) UKBaseRequest *request;
@property (nonatomic, strong) NSMutableArray <HDUserVideoListModel*> *dataArr;
@property(nonatomic , strong) UICollectionView *collectionView;

@end
static NSString *shortVideosIdentifier = @"shortVideosIdentifier_cell";
@implementation HDShortVideoListController
#pragma mark - 懒加载
- (NSMutableArray<HDUserVideoListModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSubViews];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    ///加载数据
    [self loadNewData];
}

- (void)initSubViews {
    CGFloat leftMargin = 16;
   
    HDWaterfallLayout *layout = [HDWaterfallLayout waterFallLayoutWithColumnCount:2];
    [layout setColumnSpacing:16 rowSpacing:15 sectionInset:UIEdgeInsetsMake(12, leftMargin, 0, leftMargin)];
    layout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = RGB(237, 237, 237);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[HDDiscoverCollectionViewCell class] forCellWithReuseIdentifier:shortVideosIdentifier];
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
    

    [self.dataArr removeAllObjects];
    [HDServicesManager getShortVideoLisrDataWithBlockId:@(0) lastId:@(0) block:^(BOOL isSuccess, NSArray * _Nullable arr, NSString * _Nullable alertString) {
        [self.collectionView.mj_header endRefreshing];
        if (isSuccess) {
            [self.dataArr addObjectsFromArray:arr];
            [self.collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取短视频信息失败!"];
        }
    }];

}

-(void)loadMoreData {
    [self.collectionView.mj_header endRefreshing];
     
    if (self.request.isRequesting) {
        [self.request cancelCurrentRequest];
    }

    HDUserVideoListModel * model  = self.dataArr.lastObject;
    
    [HDServicesManager getShortVideoLisrDataWithBlockId:model.block  lastId:model.lastId block:^(BOOL isSuccess, NSArray * _Nullable arr, NSString * _Nullable alertString) {
        [self.collectionView.mj_footer endRefreshing];
        if (isSuccess) {
            
             if (arr.count > 0) {
                 [self.dataArr addObjectsFromArray:arr];
             }else {
                 [self.collectionView.mj_footer endRefreshingWithNoMoreData];
             }
            [self.collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取更多短视频信息失败!"];
        }
    }];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.collectionView.mj_footer.hidden = self.dataArr.count >7?NO:YES;
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDDiscoverCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shortVideosIdentifier forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HDAttentionViewController *detailVc = [[HDAttentionViewController alloc]init];
    detailVc.delegate = self;
    detailVc.dataArr = self.dataArr;
    detailVc.currentIndex = indexPath.row;
    [self.navigationController pushViewController:detailVc animated:NO];
}

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(HDWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    HDUserVideoListModel *model = self.dataArr[indexPath.item];
    return model.cellHeight;
}

#pragma mark - HDAttentionViewControllerdelegate
- (void)userdeleteVideo {
    [self.collectionView.mj_header beginRefreshing];
}
-(void)setupmodel {
    [self.collectionView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
