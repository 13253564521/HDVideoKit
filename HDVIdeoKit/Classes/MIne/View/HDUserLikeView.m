//
//  HDUserLikeView.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/9/28.
//

#import "HDUserLikeView.h"
#import "Macro.h"
#import "HDServicesManager.h"
#import "HDUserLikeViewViewCell.h"
#import "HDMyViewController.h"
#import "UKNetworkHelper.h"
#import "UKRequestURLPath.h"
#import "HDUserVideoListModel.h"
#import "HDUserLikeViewView1Cell.h"
@interface HDUserLikeView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic , strong)UITableView *tableView;
@property(nonatomic , strong) NSMutableArray<HDMessageModel *> *dataArr;
@property(nonatomic , strong) NSMutableArray<HDUserVideoListModel *> *dataArr1;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UKBaseRequest *request;
@property (nonatomic, strong) UILabel *titLabel;

@end
@implementation HDUserLikeView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.dataArr = [NSMutableArray array];
        self.dataArr1 = [NSMutableArray array];
        
        self.tableView = [[UITableView alloc]init];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
          if (@available(iOS 11.0, *)) {
              _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
          }
        [self.tableView registerClass:[HDUserLikeViewViewCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerClass:[HDUserLikeViewView1Cell class] forCellReuseIdentifier:@"cell1"];

        self.tableView.mj_header=[MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.tableView.mj_header.automaticallyChangeAlpha=YES;
        self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        
        self.titLabel = [[UILabel alloc]init];
        self.titLabel.textColor = UkeColorHex(0x666666);
        self.titLabel.font = [UIFont systemFontOfSize:12];
        self.titLabel.hidden = YES;
        [self addSubview:self.titLabel];
        [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
    }
    return self;
}

-(void)setIndext:(int)indext {
    _indext = indext;
    [self loadNewData];
}

-(void)loadNewData {
    [self updataNetWork:YES];
}

-(void)loadMoreData {
    [self updataNetWork:NO];
}

-(void)updataNetWork:(BOOL)refresh {
    NSInteger page = 1;
    if (refresh == YES) {
        [self.tableView.mj_footer endRefreshing];
        page = 1;
    }else {
        [self.tableView.mj_header endRefreshing];
        page = self.page + page;
    }
    
    if (self.request.isRequesting) {
       [self.request cancelCurrentRequest];
    }
    
    
    if (self.indext == 1) {
        self.titLabel.text = @"还没有粉丝呦";
        self.request = [HDServicesManager getuserfenxiCouponDataWithResulblock:(int)page size:20 isindex:0 block:^(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString) {
            if (refresh == YES) {
                self.dataArr = arr;
                
            }else {
                [self.dataArr addObjectsFromArray:arr];
            }
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            if (arr.count > 0) {
                self.page = page;
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }];
    }else if (self.indext == 2) {
        self.titLabel.text = @"还没有关注的人";
        self.request =  [HDServicesManager getuserguanzhu1CouponDataWithResulblock:(int)page size:20 block:^(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString) {
            
            if (refresh == YES) {
                self.dataArr = arr;
                
            }else {
                [self.dataArr addObjectsFromArray:arr];
            }
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            if (arr.count > 0) {
                self.page = page;
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }else if (self.indext == 3)  {
        self.titLabel.text = @"还没有收到赞的，加油";
        self.request = [HDServicesManager getdianzaiVideoCouponDataWithResulblock:(int)page size:20 block:^(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString) {
            if (refresh == YES) {
                self.dataArr1 = arr;
                
            }else {
                [self.dataArr1 addObjectsFromArray:arr];
            }
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            if (arr.count > 0) {
                self.page = page;
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];

    }
    
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.indext == 3) {
        self.tableView.mj_footer.hidden = self.dataArr1.count >0?NO:YES;
        self.titLabel.hidden = self.dataArr1.count >0?YES:NO;
        return self.dataArr1.count;
    }
    self.tableView.mj_footer.hidden = self.dataArr.count >0?NO:YES;
    self.titLabel.hidden = self.dataArr.count >0?YES:NO;
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.indext == 3) {
        HDUserLikeViewView1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.model = self.dataArr1[indexPath.row];
        return cell;
    }
    
    HDUserLikeViewViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.indext= self.indext;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.indext == 3) {
        HDUserVideoListModel *model1 = self.dataArr1[indexPath.row];
        [self.delegate didSelectRowAtIndexPath:model1.userUuid];
    }else {
        HDMessageModel *model = self.dataArr[indexPath.row];
        [self.delegate didSelectRowAtIndexPath:model.targetUserUuid];
    }



}
@end
