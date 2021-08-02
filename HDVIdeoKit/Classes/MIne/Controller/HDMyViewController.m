//
//  HDMyViewController.m
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/28.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDMyViewController.h"
#import "HDParallaxHeader.h"
#import "HDMineHeaderView.h"
#import "HDCusTomSlelectView.h"
#import "HDMineCollectionViewCell.h"
#import "HDDiscoverDetailViewController.h"
#import "HDModifNameViewController.h"
#import "HDUserReportViewController.h"
#import "Macro.h"
#import "HDshangchuanViewController.h"

#import "UKNetworkHelper.h"
#import "UKRequestURLPath.h"
#import "HDHDMyModel.h"
#import "HDUserVideoListModel.h"
#import "HDAttentionViewController.h"

#import "HDUserLikeViewController.h"
#import "HDzhiboListModel.h"
#import "HDuserVideolaliuController.h"
#import "HDServicesManager.h"
#import "HDzhiboyugaoViewController.h"
#import "HDUkeInfoCenter.h"
#import "HDtuiliuVideoViewController.h"
#import "HDMineCollectionViewCell1.h"
#import "HDauditVideoViewController.h"

@interface HDMyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HDCusTomSlelectViewDelegate,HDMineHeaderViewDelegate,HDAttentionViewControllerdelegate,HDModifNameViewControllerdelegate,HDuserVideolaliuControllerdelegate,HDzhiboyugaoViewControllerdelegate>
@property (nonatomic , strong)HDMineHeaderView *headerView;
@property (nonatomic , strong)UICollectionView *collectionView;
/** 当前选中类型 */
@property(nonatomic,assign) NSInteger currentIndex;

@property(nonatomic,strong) NSMutableArray<HDUserVideoListModel *> *dataArr;
@property(nonatomic,strong) NSMutableArray<HDUserVideoListModel *> *dataArr1;
@property(nonatomic,strong) NSMutableArray<HDzhiboListModel *> *dataArr2;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UKBaseRequest *request;

@property (nonatomic, strong) UILabel *errorLabel;


@end
static NSString *identifier = @"identifier_cell";
@implementation HDMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.dataArr = [NSMutableArray array];
    
    [self loadNewData];
    [self initSubViews];
    [self setNwtWork];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarselection) name:@"tabbarselection" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNwtWork) name:@"usetmedidselecti" object:nil];

}

-(void)tabbarselection {
    [self loadNewData];
}

- (void)setNwtWork {
    NSString *url = @"";
    if (self.userID) {
        url = [NSString stringWithFormat:@"/user-home/%@/profile",self.userID];
    }else {
        url = UKURL_GET_APP_UPDATE_usercenterprofile;
    }
    
    [UKNetworkHelper GET:url parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
          NSNumber *code = response[@"code"];
          if (![[code stringValue] isEqualToString:@"0"]) {
              [SVProgressHUD showErrorWithStatus:response[@"message"]];
              return ;
          }
        
        HDHDMyModel *model = [HDHDMyModel mj_objectWithKeyValues:response[@"data"]];
        self.headerView.userID = self.userID;
        self.headerView.model = model;
        } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}


- (void)initSubViews {
    self.currentIndex = 0;
    
    self.headerView = [[HDMineHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250 + GS_SAFEAREA_TOP)];
    self.headerView.delegate = self;
    self.headerView.selectView.delegate = self;
    [self.view addSubview:self.headerView];
    
    CGFloat itemL = 20;
    CGFloat itemB = 16;
    CGFloat itemM = 5;
    CGFloat itemT = 13.5;
    CGFloat itemW = (self.view.frame.size.width - itemL * 2 - itemM * 2) / 3.0;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemW, 145 + 30 + 10);
    layout.minimumLineSpacing = itemB;
    layout.minimumInteritemSpacing =  itemM;
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(itemT, itemL, 0, itemL);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), self.view.frame.size.width, self.view.frame.size.height - self.headerView.frame.size.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor  = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.bottom.right.mas_equalTo(self.view);
    }];

    
     self.collectionView.mj_header=[MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_header.automaticallyChangeAlpha=YES;
    self.collectionView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    self.errorLabel = [[UILabel alloc]init];
    self.errorLabel.text = @"当前没有数据";
    self.errorLabel.font = [UIFont systemFontOfSize:18];
    self.errorLabel.textColor = [UIColor blackColor];
    self.errorLabel.hidden = YES;
    [self.view addSubview:self.errorLabel];
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.collectionView);
    }];
    
    if (self.userID) {
         UIButton *leftBUtton = [[UIButton alloc]initWithFrame:CGRectMake(20, GS_StatusBarHeight, 30, 30)];
        [leftBUtton setImage:[UIImage imageNamed:HDBundleImage(@"video/btn_back")] forState:0];
        [leftBUtton addTarget:self action:@selector(leftdidbutton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:leftBUtton];
        
        UIButton *tibu = [[UIButton alloc]init];
         [tibu setImage:[UIImage imageNamed:HDBundleImage(@"mine/btn_more")] forState:0];
         tibu.frame = CGRectMake(kScreenWidth - 60, GS_StatusBarHeight, 40, 40);

         [tibu addTarget:self action:@selector(jubaocon) forControlEvents:UIControlEventTouchUpInside];
         [self.view addSubview:tibu];
    }

}

-(void)leftdidbutton{
    [self.delegate controllerpopView];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadNewData {

    [self.collectionView.mj_footer endRefreshing];
          
    if (self.request.isRequesting) {
       [self.request cancelCurrentRequest];
    }
    NSDictionary *dic1 = @{@"page":@(1),@"size":@(20)};

    NSString *url = @"";
    if (self.userID) {
         if (self.currentIndex == 0) {
             url = [NSString stringWithFormat:@"/user-home/%@/videos",self.userID];
         }else if (self.currentIndex == 1) {
             url = [NSString stringWithFormat:@"/user-home/%@/like-videos",self.userID];
         }else if (self.currentIndex == 2) {
             url = [NSString stringWithFormat:@"/user-home/%@/live/videos",self.userID];
         }
     }else {
         if (self.currentIndex == 0) {
             url = UKURL_GET_APP_UPDATE_usercentervideos;
         }else if (self.currentIndex == 1) {
             url = UKURL_GET_APP_UPDATE_likevideos;
         }else if (self.currentIndex == 2) {
             url = UKURL_GET_APP_UPDATE_mezhibolist;
         }
     }
    
    
   self.request = [UKNetworkHelper GET:url parameters:dic1 success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
          NSNumber *code = response[@"code"];
          if ([[code stringValue] isEqualToString:@"0"]) {
              
              if (self.currentIndex == 0) {
                  self.dataArr = [HDUserVideoListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                  self.page = 1;
              }else if (self.currentIndex == 1) {
                  self.dataArr1 = [HDUserVideoListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                  self.page = 1;
              }else if (self.currentIndex == 2) {
                  self.dataArr2 = [HDzhiboListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
              }
          }
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        
    } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

-(void)loadMoreData {
      [self.collectionView.mj_header endRefreshing];
       
      if (self.request.isRequesting) {
          [self.request cancelCurrentRequest];
      }
    
    NSString *url = @"";
    
    NSInteger page = self.page+1;
    NSDictionary *dic = @{@"page":@(page),@"size":@(20)};
    
    
    if (self.userID) {
        if (self.currentIndex == 0) {
            url = [NSString stringWithFormat:@"/user-home/%@/videos",self.userID];
        }else if (self.currentIndex == 1) {
            url = [NSString stringWithFormat:@"/user-home/%@/like-videos",self.userID];
        }else if (self.currentIndex == 2) {
            url = [NSString stringWithFormat:@"/user-home/%@/like/videos",self.userID];;
        }
    }else {
        if (self.currentIndex == 0) {
            url = UKURL_GET_APP_UPDATE_usercentervideos;
        }else if (self.currentIndex == 1) {
            url = UKURL_GET_APP_UPDATE_likevideos;
        }else if (self.currentIndex == 2) {
            url = UKURL_GET_APP_UPDATE_mezhibolist;
        }
    }
    
    self.request = [UKNetworkHelper GET:url parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
            NSNumber *code = response[@"code"];
            if ([[code stringValue] isEqualToString:@"0"]) {
                NSArray *arr = [HDUserVideoListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];

                if (self.currentIndex == 0){
                    [self.dataArr addObjectsFromArray:arr];
                }else if (self.currentIndex == 1) {
                    [self.dataArr1 addObjectsFromArray:arr];
                }else if (self.currentIndex == 2) {
                    [self.dataArr2 addObjectsFromArray:[HDzhiboListModel mj_objectArrayWithKeyValuesArray:response[@"data"]]];
                }
                if (arr.count > 0) {
                    self.page = page;
                }else {
                    self.collectionView.mj_footer.hidden = YES;
                    self.collectionView.mj_footer = nil;
                }
                
            }
         
             [self.collectionView reloadData];
             [self.collectionView.mj_footer endRefreshing];
        } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
            [self.collectionView.mj_footer endRefreshing];
     }];
}

#pragma mark - HDMineHeaderViewDelegate
- (void)hd_mineHeaderViewDidClickModifName {
    
    if (self.userID) {
        
    }else {
        
        HDModifNameViewController *modifyVc = [[HDModifNameViewController alloc]init];
        modifyVc.delegate = self;
        modifyVc.title = @"修改昵称";
        [self.navigationController pushViewController:modifyVc animated:NO];
    }

}
#pragma mark - HDCusTomSlelectViewDelegate
- (void)hd_CusTomSlelectViewDidSlectItemIndex:(NSInteger)itemIndex {
    self.currentIndex = itemIndex;
    
    CGFloat itemL = 20;
    CGFloat itemB = 16;
    CGFloat itemM = 5;
    CGFloat itemT = 13.5;
    CGFloat itemW = (self.view.frame.size.width - itemL * 2 - itemM * 2) / 3.0;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    if (itemIndex == 2) {
        layout.itemSize = CGSizeMake((kScreenWidth - 50)/2 , 180);
        layout.minimumLineSpacing = itemB;
        layout.minimumInteritemSpacing =  itemM;
        layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(itemT, itemL, 0, itemL);
    }else {
        layout.itemSize = CGSizeMake(itemW, 145 + 30 + 10);
        layout.minimumLineSpacing = itemB;
        layout.minimumInteritemSpacing =  itemM;
        layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(itemT, itemL, 0, itemL);
    }
    
//    [self.collectionView setCollectionViewLayout:layout];

    [self.collectionView setCollectionViewLayout:layout animated:YES];
    
//    if (self.dataArr.count > 0) {
//        self.errorLabel.hidden = NO;
//    }else {
//        self.errorLabel.hidden = YES;
//    }
    [self loadNewData];

}

#pragma mark - UICollectionViewDelegate , UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.currentIndex == 0) {
        self.collectionView.mj_footer.hidden = self.dataArr.count >7?NO:YES;
        self.errorLabel.hidden = self.dataArr.count > 0?YES:NO;
        return self.dataArr.count;

    }else if (self.currentIndex == 1) {
        self.collectionView.mj_footer.hidden = self.dataArr1.count >7?NO:YES;
        self.errorLabel.hidden = self.dataArr1.count > 0?YES:NO;
        return self.dataArr1.count;
    }else {
        self.collectionView.mj_footer.hidden = self.dataArr2.count >7?NO:YES;
        self.errorLabel.hidden = self.dataArr2.count > 0?YES:NO;
        return self.dataArr2.count;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndex == 2) {
        NSString *identityName = [NSString stringWithFormat:@"HDMineCollectionViewCell1_%ld",(long)indexPath.row];
        [self.collectionView registerClass:[HDMineCollectionViewCell1 class] forCellWithReuseIdentifier:identityName];
        HDMineCollectionViewCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identityName forIndexPath:indexPath];
        cell.model1 = self.dataArr2[indexPath.item];
        return cell;
    }else {
        NSString *identityName = [NSString stringWithFormat:@"HDVideoMessageListViewCell_%ld",(long)indexPath.row];
        [self.collectionView registerClass:[HDMineCollectionViewCell class] forCellWithReuseIdentifier:identityName];
        HDMineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identityName forIndexPath:indexPath];

        if (self.currentIndex == 0) {
            cell.isshow = YES;
            cell.model = self.dataArr[indexPath.item];

        }else if (self.currentIndex == 1) {
            cell.isshow = NO;
            cell.model = self.dataArr1[indexPath.item];
        }
        return cell;
    }
 
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.currentIndex == 2) {
        HDzhiboListModel *model = self.dataArr2[indexPath.row];
        [SVProgressHUD show];
        [HDServicesManager getdeosdddafDataWithResul:model.uuid block:^(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString) {
            
            [SVProgressHUD dismiss];
            
            if (isSuccess == NO) {
                [SVProgressHUD showErrorWithStatus:@"接口请求失败"];
            }else {
                [self setModelpuvc:dic];
            }
        }];
        
        return;
    }
    
    if (self.currentIndex == 0) {
        HDUserVideoListModel *model = self.dataArr[indexPath.item];
        if (![[HDUkeInfoCenter sharedCenter].userModel.uuid isEqualToString:model.userUuid]) {
            if ([model.state intValue] != 1) {
                return [SVProgressHUD showErrorWithStatus:@"当前视频没有通过审核"];
            }
        }
        
        if ([model.state intValue] == 2) {
            HDauditVideoViewController *vc = [[HDauditVideoViewController alloc]init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:NO];
            return;
        }
    }
    
    HDAttentionViewController *detailVc = [[HDAttentionViewController alloc]init];
    detailVc.delegate = self;
    if (self.currentIndex == 0) {
        detailVc.dataArr = self.dataArr;
    }else {
        detailVc.dataArr = self.dataArr1;
    }
    detailVc.currentIndex = indexPath.row;
    [self.navigationController pushViewController:detailVc animated:NO];
    
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
    }
    else if ([model.state intValue] == 14) {
        
        if ([model.liveType isEqualToString:@"2"])//手机直播
        {
            [self push1:model isyingjianzhibo:NO];
        }else//硬件直播
        {
            [self push1:model isyingjianzhibo:YES];
        }
        
    }
    else if ([model.state intValue] == 15) {
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
    for (HDzhiboListModel *models in self.dataArr2) {
        if ([models.uuid isEqualToString:model.uuid]) {
          
        }else {
            [arr addObject:models];
        }
    }
    self.dataArr2 = arr;
    [self.collectionView reloadData];
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

- (void)userVideodianzan:(HDzhiboModel *)model {
    for (HDzhiboListModel *models in self.dataArr2) {
        if ([models.uuid isEqualToString:model.uuid]) {
            models.likeCount = model.likeCount;
            models.isLiked = model.isLiked;
            break;
        }
    }
    
    [self.collectionView reloadData];
}

- (void)setupmodel {
    [self.collectionView reloadData];
}

-(void)nameScurre {
    [self setNwtWork];
}

-(void)jubaocon{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
       UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
       UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
           HDUserReportViewController * userb =[[HDUserReportViewController alloc]init];
           userb.title = @"用户举报";
           userb.UUID =self.userID;
           userb.isjubaoVideo = NO;
           userb.juboanetwo = NO;
           [self.navigationController pushViewController:userb animated:YES];
       }];

       [alert addAction:action2];
       [alert addAction:action1];

       [self presentViewController:alert animated:YES completion:nil];
}
-(void)userdeleteVideo {
    [self loadNewData];
}

- (void)hd_UserfenxiDidButton {
    
    if (!self.userID ) {
        HDUserLikeViewController *vc = [[HDUserLikeViewController alloc]init];
        vc.indext = 1;
        vc.title =@"粉丝";
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)hd_UserguanzhuDidButton {
    if (!self.userID ) {
        HDUserLikeViewController *vc = [[HDUserLikeViewController alloc]init];
        vc.title =@"关注";
        vc.indext = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)hd_UserzanDidButton {
    
//    if (!self.userID ) {
//        HDUserLikeViewController *vc = [[HDUserLikeViewController alloc]init];
//        vc.title =@"获赞";
//        vc.indext = 3;
//        [self.navigationController pushViewController:vc animated:YES];
//    }

}

@end
