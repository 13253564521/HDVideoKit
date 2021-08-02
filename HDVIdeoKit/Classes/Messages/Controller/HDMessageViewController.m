//
//  HDMessageViewController.m
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/28.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDMessageViewController.h"
#import "HDCusTomSlelectView.h"
#import "HDMessagesTableViewCell.h"
#import "HDMessagesComentCell.h"
#import "Macro.h"
#import "HDServicesManager.h"
#import "HDMessageModel.h"
#import "HDMyViewController.h"
#import "HDAttentionViewController.h"
#import "HDCustomTabBar.h"
#import "UKNetworkHelper.h"

@interface HDMessageViewController ()<UITableViewDelegate,UITableViewDataSource,HDCusTomSlelectViewDelegate,HDMyViewControllerdelegate>
@property(nonatomic , strong)HDCusTomSlelectView *selectView;
@property(nonatomic , strong)UITableView *tableView;
/** 当前选中转台 */
@property(nonatomic,assign) NSInteger currentIndex;

@property(nonatomic , strong) NSMutableArray<HDMessageModel *> *dataArr1;
@property(nonatomic , strong) NSMutableArray<HDMessagePinglunModel *> *dataArr2;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger page1;
@property (nonatomic, strong) UKBaseRequest *request;
@property (nonatomic, strong) UILabel *errorLabel;
@end
static NSString *messagesIdenfier = @"messagesIdenfier_cell";
static NSString *messages_commentIdenfier = @"messages_commentIdenfier_cell";
@implementation HDMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr1 = [NSMutableArray array];
    self.dataArr2 = [NSMutableArray array];
    self.currentIndex = 0;
    
    self.title = @"消息";
    [self initSubViews];
    [self loadNewData];
}
- (void)initSubViews {
    CGFloat selectViewL = 20;
    CGFloat selectViewH = 50;
    self.selectView = [HDCusTomSlelectView initializeWithNames:@[@"通知",@"评论"]];
    self.selectView.delegate = self;
    self.selectView.frame = CGRectMake(selectViewL, 6, self.view.frame.size.width - selectViewL * 2, selectViewH);
    [self.view addSubview:self.selectView];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectView.frame) + 10, self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.selectView.frame) - GS_TabbarHeight - 10) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HDMessagesTableViewCell class] forCellReuseIdentifier:messagesIdenfier];
    [self.tableView registerClass:[HDMessagesComentCell class] forCellReuseIdentifier:messages_commentIdenfier];
    self.tableView.mj_header=[MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha=YES;
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.selectView.mas_bottom).offset(5);
    }];
    
    self.errorLabel = [[UILabel alloc]init];
    self.errorLabel.text = @"当前没有数据";
    self.errorLabel.font = [UIFont systemFontOfSize:18];
    self.errorLabel.textColor = [UIColor blackColor];
      [self.errorLabel sizeToFit];
    self.errorLabel.hidden = YES;
    [self.tableView addSubview:self.errorLabel];
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.tableView);
    }];
 
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
        page = self.page+1;
    }
    
    if (self.request.isRequesting) {
       [self.request cancelCurrentRequest];
    }
    
    self.request = [HDServicesManager getuserfenxiCouponDataWithResulblock:(int)page size:20 isindex:self.currentIndex block:^(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString) {
        if (refresh == YES) {
            if (self.currentIndex == 0) {
                self.dataArr1 = arr;
            }else {
                self.dataArr2 = arr;
                [HDServicesManager getmessagesstateDataWithResuluuid:@"0" block:^(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString) {
                    if (isSuccess == YES) {
                        [[HDCustomTabBar sharedManager]dismmxiaoxi];
                    }
                }];
                
            }
        }else {
            if (self.currentIndex == 0) {
                [self.dataArr1 addObjectsFromArray:arr];
            }else {
                [self.dataArr2 addObjectsFromArray:arr];
            }
        }
        
        if (arr.count > 0) {
            self.page = page;
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    if (self.currentIndex == 0) {
        NSInteger page1 = 1;
        if (refresh == YES) {
            page1 = 1;
        }else {
            page1 = self.page1+1;
        }
        [UKNetworkHelper GET:@"/messages" parameters:@{@"page":@(page1),@"size":@"20",@"target":@"100"} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
            NSNumber *code = response[@"code"];
            if ([[code stringValue] isEqualToString:@"0"]) {
                NSMutableArray *arr= [HDMessageModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                for (HDMessageModel *model in arr) {
                    if (model.target == 14 || model.target == 7 || model.target ==  8|| model.target == 9 || model.target == 5 || model.target == 6 || model.target == 12) {
                        model.isguangfangtongzhi = YES;
                        [self.dataArr1 addObject:model];
                    }
                }
                if (arr.count > 0) {
                    self.page1 = page1;
                }
                [self.tableView reloadData];
            }
        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        }];
    }
   
}
#pragma mark - HDCusTomSlelectViewDelegate
- (void)hd_CusTomSlelectViewDidSlectItemIndex:(NSInteger)itemIndex {
    self.currentIndex = itemIndex;
    
    if (self.currentIndex == 0) {
        if (self.dataArr1.count == 0) {
            [self loadNewData];
        }else {
            [self.tableView reloadData];
        }
    }else {
        if (self.dataArr2.count == 0) {
            [self loadNewData];
        }else {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.currentIndex == 0) {
        self.tableView.mj_footer.hidden = self.dataArr1.count >7?NO:YES;
        self.errorLabel.hidden = self.dataArr1.count>0?YES:NO;
        return self.dataArr1.count;

    }else {
        self.tableView.mj_footer.hidden = self.dataArr2.count >7?NO:YES;
        self.errorLabel.hidden = self.dataArr2.count>0?YES:NO;
        return self.dataArr2.count;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndex == 0) {
         HDMessagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messagesIdenfier];
         if (!cell) {
             cell = [[HDMessagesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messagesIdenfier];
         }
        cell.model = self.dataArr1[indexPath.row];
        
        return cell;
    }else if (self.currentIndex == 1){
         HDMessagesComentCell *cell = [tableView dequeueReusableCellWithIdentifier:messages_commentIdenfier];
         if (!cell) {
             cell = [[HDMessagesComentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messages_commentIdenfier];
         }
        cell.model = self.dataArr2[indexPath.row];
        
        return cell;
    }
     return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndex == 0) {
        HDMyViewController * vc = [[HDMyViewController alloc]init];
        HDMessageModel *model = self.dataArr1[indexPath.row];
        vc.userID = model.targetUserUuid;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [SVProgressHUD show];
        HDMessagePinglunModel *model = self.dataArr2[indexPath.row];
        [HDServicesManager getVideoXiaqCouponDataWithResulblock:model.targetInfo[@"uuid"] black:^(BOOL isSuccess, HDUserVideoListModel * _Nullable cellModel, NSString * _Nullable alertString) {
            
            if (cellModel) {
                NSMutableArray *arr= [NSMutableArray array];
                [arr addObject:cellModel];
                
                HDAttentionViewController *vc = [[HDAttentionViewController alloc]init];
                vc.currentIndex = 0;
                vc.dataArr = arr;
                [self.navigationController pushViewController:vc animated:YES];
                [SVProgressHUD dismiss];
            }else {
                [SVProgressHUD showErrorWithStatus:alertString];
            }
            
        }];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndex == 0) {
        return 60;
    }else if (self.currentIndex == 1){
        return 100;
    }
    return 60;
}

-(void)controllerpopView {
    [self loadNewData];
}
@end
