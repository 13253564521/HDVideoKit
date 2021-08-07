//
//  HDDiscoverViewController.m
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/28.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//发现

#import "HDDiscoverViewController.h"
#import "HDDiscoverCollectionViewCell.h"
#import "HDDiscoverDetailViewController.h"
#import "HDAttentionViewController.h"
#import "Macro.h"
#import "HDWaterfallLayout.h"
#import "HDCompilationModel.h"
#import "UKNetworkHelper.h"
#import "UKRequestURLPath.h"
#import "HDshangchuanViewController.h"
#import "HDUserVideoListModel.h"
#import "HDServicesManager.h"

@interface HDDiscoverViewController ()<UICollectionViewDelegate , UICollectionViewDataSource,HDWaterfallLayoutDelegate,HDAttentionViewControllerdelegate>
@property(nonatomic , strong) UICollectionView *collectionView;
@property(nonatomic , strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UKBaseRequest *request;
@property (nonatomic, strong) UILabel *errorLabel;

@end

static NSString *dicoverIdentifier = @"dicoverIdentifier_cell";
@implementation HDDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];



    [self initSubViews];
}

- (void)setDiscoverDataModel:(HDCompilationModel *)discoverDataModel {
    _discoverDataModel = discoverDataModel;
    
    [self loadNewData];

}

- (void)initSubViews {

    CGFloat leftMargin = 16;
   
    HDWaterfallLayout *layout = [HDWaterfallLayout waterFallLayoutWithColumnCount:2];
    [layout setColumnSpacing:leftMargin rowSpacing:15 sectionInset:UIEdgeInsetsMake(12, leftMargin, 0, leftMargin)];
    layout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = RGB(237, 237, 237);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[HDDiscoverCollectionViewCell class] forCellWithReuseIdentifier:dicoverIdentifier];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
     self.collectionView.mj_header=[MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.collectionView.mj_header.automaticallyChangeAlpha=YES;
    self.collectionView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
      self.errorLabel = [[UILabel alloc]init];
      self.errorLabel.text = @"当前没有数据";
      self.errorLabel.font = [UIFont systemFontOfSize:18];
      self.errorLabel.textColor = [UIColor blackColor];
        [self.errorLabel sizeToFit];
      self.errorLabel.hidden = YES;
      [self.collectionView addSubview:self.errorLabel];
      [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.center.mas_equalTo(self.collectionView);
      }];
}

-(void)loadNewData {
    [self updataNetWork:YES];
}

-(void)loadMoreData {
    [self updataNetWork:NO];
}


-(void)updataNetWork:(BOOL)refresh {
    
    if (refresh == YES) {
        [self.collectionView.mj_footer endRefreshing];
    }else {
        [self.collectionView.mj_header endRefreshing];
    }
    
    if (self.request.isRequesting) {
       [self.request cancelCurrentRequest];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",UKURL_GET_APP_UPDATE_hejiliebiao,self.discoverDataModel.uuid];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSInteger page = self.page+1;
     dic[@"page"] = @(page);
     dic[@"size"] = @"20";
    self.request = [UKNetworkHelper GET:urlString parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
             NSNumber *code = response[@"code"];
             if ([[code stringValue] isEqualToString:@"0"]) {
                 
                 [self.collectionView.mj_header endRefreshing];
                 [self.collectionView.mj_footer endRefreshing];
                 
                 NSMutableArray *arr = [HDUserVideoListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                 if (refresh == YES) {
                     self.dataArr = arr;
                 }else {
                     
                     if (arr.count > 0) {
                         [self.dataArr addObjectsFromArray:arr];
                         self.page = page;
                     }else {
                         [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                     }
                 }
             }
           
           [self.collectionView reloadData];
           
       } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
           [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
       }];
}
#pragma mark - UICollectionViewDelegate , UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    self.collectionView.mj_footer.hidden = self.dataArr.count >7?NO:YES;

    if (self.dataArr.count > 0) {
           self.errorLabel.hidden = YES;
       }else {
           self.errorLabel.hidden = NO;
       }
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDDiscoverCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dicoverIdentifier forIndexPath:indexPath];
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

-(void)setupmodel {
    [self.collectionView reloadData];
}

#pragma mark - HDWaterfallLayoutDelegate

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(HDWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    HDUserVideoListModel *model = self.dataArr[indexPath.item];
    return model.cellHeight;
}


@end
