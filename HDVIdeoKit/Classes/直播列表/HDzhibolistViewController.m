//
//  HDzhibolistViewController.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/10/28.
//

#import "HDzhibolistViewController.h"
#import "Macro.h"
#import "UKBaseRequest.h"
#import "HDServicesManager.h"
#import "HDzhiboTableViewCell.h"
#import "HDuserVideolaliuController.h"
#import "HDServicesManager.h"
#import "HDzhiboListModel.h"
#import "HDzhiboyugaoViewController.h"
#import "HDtuiliuVideoViewController.h"
#import "HDUkeInfoCenter.h"
@interface HDzhibolistViewController ()<UITableViewDelegate,UITableViewDataSource,HDuserVideolaliuControllerdelegate,HDzhiboyugaoViewControllerdelegate>
@property(nonatomic , strong)UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property(nonatomic , strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UKBaseRequest *request;

@end

@implementation HDzhibolistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.dataArr = [NSMutableArray array];
    self.page = 0;
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [[UIView alloc]init];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = UkeColorHex(0xEDEDED);
    [self.tableView registerNib:[UINib nibWithNibName:@"HDzhiboTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDzhiboTableViewCell"];
    self.tableView.mj_header=[MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha=YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(0);
    }];
    
    [self loadNewData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"liveVideoLose" object:nil];
}

-(void)loadNewData {
    [self updataNetWork:YES];
}

-(void)loadMoreData {
    [self updataNetWork:NO];
}

-(void)updataNetWork:(BOOL)refresh {
    NSInteger paged = 1;
    if (refresh == YES) {
        [self.tableView.mj_footer endRefreshing];
        paged = 1;
    }else {
        [self.tableView.mj_header endRefreshing];
        paged = self.page + 1;
    }
    
    if (self.request.isRequesting) {
       [self.request cancelCurrentRequest];
    }
    
    self.request = [HDServicesManager getzhibolistWithResullastId:[NSString stringWithFormat:@"%ld",(long)paged] block:^(BOOL isSuccess, NSArray * _Nullable arr, NSString * _Nullable alertString) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (refresh == YES) {
            self.dataArr = [HDzhiboListModel mj_objectArrayWithKeyValuesArray:arr];
            if (arr.count > 0) {
                if (!self.tableView.mj_footer) {
                    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
                }
            }
        }else {
            [self.dataArr addObjectsFromArray:[HDzhiboListModel mj_objectArrayWithKeyValuesArray:arr]];
        }
        
        if (isSuccess == YES && arr.count > 0) {
            self.page = paged;
        }
        
        if (arr.count <= 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
        
        if (isSuccess == NO) {
            [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络状态"];
        }

    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDzhiboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDzhiboTableViewCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HDzhiboListModel *model = self.dataArr[indexPath.row];
    
    
    [SVProgressHUD show];
    [HDServicesManager getdeosdddafDataWithResul:model.uuid block:^(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString) {
        
        [SVProgressHUD dismiss];
        
        if (isSuccess == NO) {
            [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络状态"];
        }else {
            [self setModelpuvc:dic];
        }
    }];
    
}

-(void)setModelpuvc:(HDzhiboModel *)model {
    if ([model.state intValue] == 13) {//13直播预告,14直播中,15直播已结束,16直播暂停中,17直播被关闭

        NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:model.beginTime];
        int datea = [self compareOneDay:timeDate withAnotherDay:[self getCurrentTime]];
        if (datea == 1) {
            
            HDzhiboyugaoViewController *vc = [[HDzhiboyugaoViewController alloc]init];
            vc.model = model;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            [self push1:model isyingjianzhibo:NO];
        }
    }else if ([model.state intValue] == 14) {
        
        if ([model.liveType isEqualToString:@"2"])//手机直播
        {
            [self push1:model isyingjianzhibo:NO];
        }else//硬件直播
        {
            [self push1:model isyingjianzhibo:YES];
        }
        
    }else if ([model.state intValue] == 15) {
        HDuserVideolaliuController *vc = [[HDuserVideolaliuController alloc]init];
        vc.delegate = self;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)push1:(HDzhiboModel *)model isyingjianzhibo:(BOOL)isyingjianzhibo{
    
    if ([[HDUkeInfoCenter sharedCenter].userModel.uuid isEqualToString:model.userUuid]) {
        HDtuiliuVideoViewController *vide = [[HDtuiliuVideoViewController alloc]init];
        vide.uuid = model.uuid;
        vide.ispopview = YES;
        vide.isyingjianzhibo = isyingjianzhibo;
        [self.navigationController pushViewController:vide animated:YES];
    }else {
        HDuserVideolaliuController *vc = [[HDuserVideolaliuController alloc]init];
        vc.model = model;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)daoshijianzhibo:(HDzhiboModel *)moedl {
    
    [self setModelpuvc:moedl];
}

- (void)daoshiguanzhong:(HDzhiboModel *)moedl {
    [self setModelpuvc:moedl];
}

-(void)currentModelremove:(HDzhiboModel *)model {
    
    NSMutableArray *arr =[NSMutableArray array];
    for (HDzhiboListModel *models in self.dataArr) {
        if ([models.uuid isEqualToString:model.uuid]) {
          
        }else {
            [arr addObject:models];
        }
    }
    self.dataArr = arr;
    [self.tableView reloadData];
}
#pragma mark -得到当前时间date
- (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    return date;
}

//返回1 - 过期, 0 - 相等, -1 - 没过期
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        NSLog(@"oneDay  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //刚好时间一样.
    //NSLog(@"Both dates are the same");
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 260;
}

- (void)userVideodianzan:(HDzhiboModel *)model {
    for (HDzhiboListModel *models in self.dataArr) {
        if ([models.uuid isEqualToString:model.uuid]) {
            models.likeCount = model.likeCount;
            models.isLiked = model.isLiked;
            break;
        }
    }
    
    [self.tableView reloadData];
}
@end
