//
//  HDSearchViewController.m
//  HDVideoKit
//
//  Created by liugaosheng on 2020/8/30.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDSearchViewController.h"
#import "HDDiscoverDetailViewController.h"
#import "HDWaterfallLayout.h"
#import "HDDiscoverCollectionViewCell.h"
#import "Macro.h"
#import "HDAttentionViewController.h"
#import "HDServicesManager.h"
#import "UKBaseRequest.h"
#import "HDUserVideoListModel.h"
@interface HDSearchViewController ()<UITextFieldDelegate , UICollectionViewDelegate , UICollectionViewDataSource,HDWaterfallLayoutDelegate>
@property(nonatomic , strong) UICollectionView *collectionView;
/** 关闭按钮 */
@property(nonatomic,strong) UIButton *closeButton;
/** textField */
@property(nonatomic,strong) UITextField *searchtextField;

/** 取消操作 */
@property(nonatomic,strong) UIButton *cancleButton;

@property(nonatomic,strong) UKBaseRequest *request;

@property(nonatomic , strong) NSMutableArray *dataArr;

@property (nonatomic, assign) NSInteger page;
@end
static NSString *searchIdentifier = @"searchIdentifier_cell";
@implementation HDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArr = [NSMutableArray array];
    [self initSubViews];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)uke_resignFirstResponder {
    @try {
        if (self.searchtextField.isFirstResponder == NO) {
            return;
        }
        [self.searchtextField resignFirstResponder];
    } @catch (NSException *exception) {} @finally {}
}

- (void)uke_becomeFirstResponder {
    @try {
        if (self.searchtextField.isFirstResponder) {
            return;
        }
        [self.searchtextField becomeFirstResponder];
    } @catch (NSException *exception) {} @finally {}
}


- (void)initSubViews {
    CGFloat closeWH = 40;
    CGFloat closetTM = 5;
//关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(10, GS_StatusBarHeight + closetTM, closeWH, closeWH);
    [self.closeButton setImage:[UIImage imageNamed:HDBundleImage(@"navgation/btn_back1")] forState:0];
    [self.closeButton setTitle:@"  " forState:0];
    [self.closeButton setTitleColor:[UIColor blackColor] forState:0];
    self.closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    
    
    // 取消按钮
    CGFloat cancleW = 64;
    CGFloat cancleMR = 5;
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleButton.frame = CGRectMake(self.view.frame.size.width - cancleMR - cancleW, self.closeButton.frame.origin.y, cancleW, closeWH);
    [self.cancleButton setTitleColor:RGBA(52, 52, 62, 1) forState:UIControlStateNormal];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(cancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancleButton];
    

    CGFloat textFieldW = self.view.frame.size.width - CGRectGetMaxX(self.closeButton.frame) - closetTM - cancleW - cancleMR ;
    CGFloat textFieldH = 32;

    //搜索框
    self.searchtextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.closeButton.frame) + closetTM , self.closeButton.frame.origin.y + 4.5, textFieldW, textFieldH)];
    self.searchtextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"搜索" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.searchtextField.returnKeyType = UIReturnKeyDone;
    self.searchtextField.borderStyle = UITextBorderStyleNone;
    self.searchtextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchtextField.backgroundColor = RGBA(237, 237, 237, 1);
    self.searchtextField.layer.cornerRadius = 4;
    self.searchtextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4.5, textFieldH)];
    self.searchtextField.delegate = self;
    
    [self.view addSubview:self.searchtextField];
    [self uke_becomeFirstResponder];
   
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
       
       keyboardDoneButtonView.barStyle = UIBarStyleDefault;
       
       keyboardDoneButtonView.translucent = YES;
       
       keyboardDoneButtonView.tintColor = nil;
       
       [keyboardDoneButtonView sizeToFit];
       
       UIBarButtonItem *SpaceButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]; // 让完成按钮显示在右侧
       
       UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(pickerDoneClicked)];
       
       [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:SpaceButton, doneButton, nil]];
       
    self.searchtextField.inputAccessoryView = keyboardDoneButtonView;
     CGFloat leftMargin = 16;
    
     HDWaterfallLayout *layout = [HDWaterfallLayout waterFallLayoutWithColumnCount:2];
     [layout setColumnSpacing:16 rowSpacing:15 sectionInset:UIEdgeInsetsMake(12, leftMargin, 0, leftMargin)];
     layout.delegate = self;
     
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.closeButton.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.closeButton.frame)) collectionViewLayout:layout];
     self.collectionView.backgroundColor = [UIColor whiteColor];
     self.collectionView.delegate = self;
     self.collectionView.dataSource = self;
     [self.collectionView registerClass:[HDDiscoverCollectionViewCell class] forCellWithReuseIdentifier:searchIdentifier];
     [self.view addSubview:self.collectionView];
//      self.collectionView.mj_header=[MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//     self.collectionView.mj_header.automaticallyChangeAlpha=YES;
//     self.collectionView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeOneCI:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)textFieldTextDidChangeOneCI:(NSNotification *)notification
 {
     UITextField *textfield=[notification object];
     NSLog(@"%@",textfield.text);
     if (textfield.text.length >= 2) {
//         [self updataNetWork:YES];
     }
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
//        self.collectionVi.mj_header
    }
    
    if (self.request.isRequesting) {
       [self.request cancelCurrentRequest];
    }
    
    [SVProgressHUD dismiss];

    [SVProgressHUD show];
     NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"word"] = self.searchtextField.text;
      NSInteger page = self.page+1;
      dic[@"page"] = @(page);
      dic[@"size"] = @"20";
    
       self.request = [HDServicesManager getsousuoCouponDataWithResul:dic block:^(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString) {
           
           if (refresh == YES) {
               self.dataArr = arr;
           }else {
               [self.dataArr addObjectsFromArray:arr];
               
               if (arr.count > 0) {
                   self.page = page;
               }
           }
           
           [self.collectionView reloadData];

           [self.collectionView.mj_header endRefreshing];
           [self.collectionView.mj_footer endRefreshing];
           
           if (arr == 0) {
               [SVProgressHUD showErrorWithStatus:@"暂无数据"];
           }else {
               [SVProgressHUD dismiss];
           }
       }];
}


-(void)pickerDoneClicked {

    [self uke_resignFirstResponder];
    
    if (self.searchtextField.text.length >= 2) {
        [self updataNetWork:YES];
    }
   
}


#pragma mark - buttonClick
- (void)closeButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancleButtonAction {

    [self.view endEditing:YES];
    self.searchtextField.text = @"";
    self.dataArr = nil;
    [self uke_resignFirstResponder];
    [self.collectionView reloadData];

}
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    [self uke_becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.searchtextField.text.length >= 2) {
        [self updataNetWork:YES];
    }
   
    return [textField resignFirstResponder];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"%@",self.searchtextField.text);
//    //开始编辑时触发，文本字段将成为first responder
//    if (textField.text.length >= 2) {
//        [self updataNetWork:YES];
//    }
//    return YES;
//}


#pragma mark - UICollectionViewDelegate , UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.collectionView.mj_footer.hidden = self.dataArr.count > 6?NO:YES;
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDDiscoverCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:searchIdentifier forIndexPath:indexPath];
    [cell setModeldate:self.dataArr[indexPath.item]];
    cell.ishiddeView = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中对应item： %ld",(long)indexPath.row);
    HDAttentionViewController *detailVc = [[HDAttentionViewController alloc]init];
    detailVc.dataArr = self.dataArr;
    detailVc.currentIndex = indexPath.row;
    [self.navigationController pushViewController:detailVc animated:NO];
    
}


#pragma mark - HDWaterfallLayoutDelegate

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(HDWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    HDUserVideoListModel *model = self.dataArr[indexPath.item];
    return model.cellHeight;
}

@end
