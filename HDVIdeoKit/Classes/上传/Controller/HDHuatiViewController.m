//
//  HDHuatiViewController.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/26.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDHuatiViewController.h"
#import "HDBaseNavView.h"
#import "Macro.h"
#import "HDHuatiModel.h"
#import "HDshangchuanTableViewCell.h"


NSString *const huati_identifier = @"hd_huati_identifier";
@interface HDHuatiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic , strong) HDBaseNavView *navView;
@property(nonatomic , strong) UIButton *ensureButton;
/** 列表 */
@property(nonatomic,strong) UITableView *tableView;

/** 选中数组 */
@property(nonatomic,strong) NSMutableArray<HDHuatiModel *> *selectedHuatiArray;
@end

@implementation HDHuatiViewController
- (NSMutableArray<HDHuatiModel *> *)selectedHuatiArray {
    if (!_selectedHuatiArray) {
        _selectedHuatiArray = [NSMutableArray array];
    }
    return _selectedHuatiArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubVeiws];
}

-(void)initSubVeiws {
    UIColor *pageColor = RGBA(225, 228, 233, 1);
    self.view.backgroundColor = pageColor;
    self.navView = [[HDBaseNavView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, GS_NavHeight) title:@"位置选择"];
    [self.view addSubview:self.navView];
    
    // 添加删除按钮
     self.ensureButton = [UIButton buttonWithType:UIButtonTypeSystem];
     [self.ensureButton setTitle:@"确定" forState:UIControlStateNormal];
     [self.ensureButton addTarget:self action:@selector(ensureButtonClick) forControlEvents:UIControlEventTouchUpInside];
     [self.navView addSubview:self.ensureButton];
     [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(self.navView.mas_right).offset(-16);
         make.top.equalTo(self.navView.mas_top).offset(GS_StatusBarHeight + 10);
         make.width.mas_equalTo(40);
         make.height.mas_equalTo(24);
     }];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 55;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[HDshangchuanTableViewCell class] forCellReuseIdentifier:huati_identifier];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
    }];

    @WeakObj(self);
    self.navView.backBlock = ^{

        [selfWeak.selectedHuatiArray removeAllObjects];
        [selfWeak.navigationController popViewControllerAnimated:YES];

    };
}

- (void)ensureButtonClick {
    //判断话题是否大于30 个字符,大于重新选择
    NSString *huatiStr = @"";
    for (HDHuatiModel *model in self.selectedHuatiArray) {
        huatiStr = [NSString stringWithFormat:@"%@#%@",huatiStr,model.name];
    }
    if (huatiStr.length > 30) {
        return [SVProgressHUD showErrorWithStatus:@"话题不能超过30个字，请重新选择"];
    }
    
    !self.huatiSelectedblock ? : self.huatiSelectedblock(self.selectedHuatiArray);
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.huatisArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //填充视频数据
    HDshangchuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:huati_identifier forIndexPath:indexPath];
    cell.model = self.huatisArray[indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDHuatiModel *model = self.huatisArray[indexPath.row];
    model.isxuanzhong = !model.isxuanzhong;
    if (model.isxuanzhong) {
        [self.selectedHuatiArray addObject:model];
    }else{
        [self.selectedHuatiArray removeObject:model];
    }
    //刷新cell
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)setHuatisArray:(NSArray<HDHuatiModel *> *)huatisArray {
    _huatisArray = huatisArray;
    [self.tableView reloadData];
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
