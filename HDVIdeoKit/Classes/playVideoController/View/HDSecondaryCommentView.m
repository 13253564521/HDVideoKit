//
//  HDSecondaryCommentView.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/26.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDSecondaryCommentView.h"
#import "Macro.h"
#import "HDCommentViewCell.h"
#import "HDCommentCellModel.h"
#import "HDVideoCommentTools.h"
#import "HDServicesManager.h"
#import "UKRequestURLPath.h"

#import "HDUkeInfoCenter.h"

@interface HDSecondaryCommentView()<UITableViewDelegate,UITableViewDataSource,HDCommentViewCellDelegate>
@property(nonatomic , strong)UIView *lineView;
@property(nonatomic , strong)UIView *commentView;
@property(nonatomic , strong)UILabel *commentCountLabel;
@property(nonatomic , strong)UIButton *closeButton;
@property(nonatomic , strong)UITableView *tableView;

@property (nonatomic, strong)HDWriteCommentView *writeCommentView;

@property(nonatomic , strong)HDCommentCellModel *selectModel;

@property(nonatomic , strong)NSMutableArray *dataArr;

@property(nonatomic , copy)NSString *commentId;


/** page */
@property(nonatomic,assign) NSInteger currentPage;
/** 是否是下啦刷新中 */
@property(nonatomic,assign) BOOL ispullState;

@end

@implementation HDSecondaryCommentView
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArr = [NSMutableArray array];

        //监听键盘的通知事件  已有变化就发出通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jianpantongzhi:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [self initSubViews];
        
    }
    return self;
}



- (void)setVideoUUID:(NSString *)videoUUID {
    _videoUUID = videoUUID;
 
}
- (void)setPinglunID:(NSString *)pinglunID {
    _pinglunID = pinglunID;
}


-(void)setupNwrwork {
    @WeakObj(self);
    [SVProgressHUD show];

  
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *str = @"";
    if (self.islikeVideo == YES) {
        str = [NSString stringWithFormat:@"/live/videos/%@/comments/%@",self.videoUUID,self.pinglunID];
        dic[@"size"] = @(100);
//        if (self.dataArr.count > 0) {
//            HDCommentCellModel *model = self.dataArr.lastObject;
//            dic[@"lastId"] = model.pinglunID;
//        }else {
            dic[@"lastId"] = @(0);
//        }
    }else {
        str = [NSString stringWithFormat:@"%@/%@%@/%@",UKURL_GET_APP_UPDATE_chaxunpinglun1,self.videoUUID,UKURL_GET_APP_UPDATE_pinglun,self.pinglunID];
        dic[@"page"] = @(self.currentPage);
        dic[@"size"] = @(20);

    }
    [HDServicesManager getchaxunpinglun2CouponDataWithResuldic:str dic:dic block:^(BOOL isSuccess, NSMutableArray * _Nullable twreArr, int pinCount, NSString * _Nullable alertString) {
        [SVProgressHUD dismiss];
        if (selfWeak.ispullState) {//上拉舒心
            [selfWeak.tableView.mj_footer endRefreshing];
        }else{//下拉刷新
            [selfWeak.tableView.mj_header endRefreshing];
        }
        
        [SVProgressHUD dismiss];
        if (twreArr.count == 0) {
            if (selfWeak.tableView.mj_footer) {
                [selfWeak.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [SVProgressHUD showErrorWithStatus:@"当前暂无评论数据"];
            }
            
        }else {
            if ([selfWeak.dataArr containsObject:twreArr] || selfWeak.dataArr.count == pinCount) {
                [selfWeak.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            [selfWeak.dataArr addObjectsFromArray:twreArr];

            selfWeak.commentCountLabel.text = [NSString stringWithFormat:@"%d条评论",pinCount];

            [selfWeak.tableView reloadData];
            if (!selfWeak.tableView.mj_footer) {
                selfWeak.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
                    selfWeak.ispullState = NO;
                    [selfWeak setupNwrwork];
                }];
            }

            
            selfWeak.currentPage ++;
        }
    }];


}


- (void)initSubViews {
    self.backgroundColor = RGBA(0, 0, 0, 0.6);
    self.commentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height / 3, self.frame.size.width , self.frame.size.height * 2 / 3)];
    ///添加圆角
    CGFloat radius = 15; // 圆角大小
    UIRectCorner corner = UIRectCornerTopLeft|UIRectCornerTopRight; // 圆角位置，全部位置
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.commentView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.commentView.bounds;
    maskLayer.path = path.CGPath;
    self.commentView.layer.mask = maskLayer;
    [self addSubview:self.commentView];

    ///渐变色
    CAGradientLayer *gradientLayer = [self getGradientLayerWithBounds:self.commentView.bounds colorsArray:[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil]];
    [self.commentView.layer insertSublayer:gradientLayer atIndex:0];

    self.commentCountLabel = [[UILabel alloc]init];
    self.commentCountLabel.font = [UIFont boldSystemFontOfSize:15];
    self.commentCountLabel.textColor = [UIColor blackColor];
    self.commentCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.commentView addSubview:self.commentCountLabel];
    [self.commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentView).offset(20);
        make.left.right.mas_equalTo(self.commentView);
        
    }];
    
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:HDBundleImage(@"video/btn_x")] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.commentView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.commentView).offset(-16);
        make.centerY.mas_equalTo(self.commentCountLabel);
    }];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      if (@available(iOS 11.0, *)) {
          self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      }
    [self.tableView registerClass:[HDCommentViewCell class] forCellReuseIdentifier:@"cell"];
    [self.commentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.commentView);
        make.top.mas_equalTo(self.commentCountLabel.mas_bottom).offset(19);
        make.bottom.equalTo(self.commentView.mas_bottom);
    }];
    
    @WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        selfWeak.ispullState = NO;
        selfWeak.currentPage = 0;
        [selfWeak.dataArr removeAllObjects];
        [self setupNwrwork];
    }];
    
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = RGBA(50, 60, 67, 0.08);
    [self.commentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.commentView);
        make.bottom.equalTo(self.tableView.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    
    

    
    
    self.writeCommentView = [[HDWriteCommentView alloc]initWithFrame:CGRectMake(0, kScreenHeight, self.frame.size.width, kScreenHeight)];
    [self addSubview:self.writeCommentView];
    ///发送【评论
    @weakify(self);
    self.writeCommentView.sendBtnBlock = ^(NSString * _Nonnull text) {
        [weak_self netWork:text];
    };
    
    ///取消评论
    self.writeCommentView.cancleBtnBlock = ^{
        
    };
    

    
}


-(void)netWork:(NSString *)text {
    
    if (text.length <= 0) return;
    @WeakObj(self);
    NSString *str = @"";
    NSDictionary *dic = @{};
    if (self.pinglunID.length > 0) {
        
        if (self.islikeVideo == YES) {//直播
            str = [NSString stringWithFormat:@"/live/videos/%@/comments/%@",self.videoUUID,self.pinglunID];
        }else {
            str = [NSString stringWithFormat:@"%@/%@%@/%@",UKURL_GET_APP_UPDATE_chaxunpinglun1,self.videoUUID,UKURL_GET_APP_UPDATE_pinglun,self.pinglunID];
        }
        
        dic = @{@"content":text};
    }
    [HDServicesManager getpinglunCouponDataWithResul:str :dic block:^(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString) {

        if (isSuccess == YES) {
            [SVProgressHUD showSuccessWithStatus:@"评论成功"];
            [selfWeak.tableView.mj_header beginRefreshing];
        }else {
            NSNumber *state = [HDUkeInfoCenter sharedCenter].userModel.state;
            if ([state intValue] == 10) {
                
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"由于您多次违规操作，已被禁用该功能" preferredStyle:UIAlertControllerStyleAlert];

                   UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
                   }];

                   [alertVc addAction:sureBtn];
                   [[selfWeak topController] presentViewController:alertVc animated:YES completion:nil];
//                [SVProgressHUD showErrorWithStatus:@"由于您多次违规操作，已被禁用该功能"];
            }else {
                [SVProgressHUD showErrorWithStatus:@"发布失败"];
            }
        }
        self.commentId = @"";
        [self.writeCommentView uke_resignFirstResponder];
    }];
}

- (UIViewController *)topController {
    
    UIViewController *topC = [self topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    
    while (topC.presentedViewController) {
        topC = [self topViewController:topC.presentedViewController];
    }
    return topC;
}

- (UIViewController *)topViewController:(UIViewController *)controller {
    if ([controller isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)controller topViewController]];
    } else if ([controller isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)controller selectedViewController]];
    } else {
        return controller;
    }
}


-(BOOL)ispanduanshifouxiangdeng:(NSString *)pinglunID{
        
    BOOL isxiangden = NO;
    for (HDCommentCellModel *model in self.dataArr) {
        if ([model.pinglunID isEqualToString:pinglunID]) {
            isxiangden = YES;
        }
    }
    return isxiangden;
}

-(void)jianpantongzhi:(NSNotification *)note
{
    CGFloat durtion =[note.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];

    //  取出键盘的frame
    CGRect frame=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
     [UIView animateWithDuration:durtion animations:^{
       
       if (frame.origin.y == kScreenHeight) {
           self.writeCommentView .transform = CGAffineTransformIdentity;
           self.commentId = @"";
       }else {
           self.writeCommentView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight - frame.size.height);
       }
       
   }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
#pragma mark - buttonClick

- (void)closeAction {
    if ([self.delegate respondsToSelector:@selector(dismmHDSecondaryCommentView)]) {
        [self.delegate dismmHDSecondaryCommentView];
    }
 
}


#pragma mark - tableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    HDCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[HDCommentViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.islikeVideo = self.islikeVideo;
    cell.cellindex = indexPath.row;
    cell.videUUID = self.videoUUID;
    cell.model = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void)hd_CommentViewCellhuifuWithModel:(HDCommentCellModel *)model lastPinglunId:(NSString *)lastPinglunId {
    self.commentId = lastPinglunId;
    [self.writeCommentView uke_becomeFirstResponder];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches.allObjects lastObject];
    CGPoint point = [touch locationInView:self];
    BOOL result = CGRectContainsPoint(self.commentView.frame, point);
    if (!result) {
        [self closeAction];
    }
   
}

- (CAGradientLayer *)getGradientLayerWithBounds:(CGRect)bounds  colorsArray:(NSArray *)colorsArray {
    //添加渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = bounds;
    // 渐变色颜色数组,可多个
    gradientLayer.colors = colorsArray;//[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil];
    // 渐变的开始点 (不同的起始点可以实现不同位置的渐变,如图)
    gradientLayer.startPoint = CGPointMake(0.5f, 0); //(0, 0)
    // 渐变的结束点
    gradientLayer.endPoint = CGPointMake(0.5f, 1.f); //(1, 1)
    
    return gradientLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
