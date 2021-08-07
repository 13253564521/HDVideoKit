//
//  HDPOISelectedViewController.m
//  HDVideoKitDemok
//
//  Created by LiuGaoSheng on 2021/7/21.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDPOISelectedViewController.h"

#import "HDBaseNavView.h"
#import "Macro.h"
#import "HDPOIsTableViewCell.h"
#import "HDPOIModel.h"


NSString *pois_identifier = @"hd_pois_cell";
@interface HDPOISelectedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic , strong) HDBaseNavView *navView;
/** 列表 */
@property(nonatomic,strong) UITableView *tableView;
/** 位置信息数组 */
@property(nonatomic,strong) NSMutableArray *new_poisArray;

/** 选中位置模型 */
@property(nonatomic,strong) HDPOIModel *selectedModel;


@end

@implementation HDPOISelectedViewController

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
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 55;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[HDPOIsTableViewCell class] forCellReuseIdentifier:pois_identifier];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
    }];

    @WeakObj(self);
    self.navView.backBlock = ^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
        !selfWeak.locationBlock ? : selfWeak.locationBlock(selfWeak.selectedModel);
    };
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.new_poisArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HDPOIsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pois_identifier forIndexPath:indexPath];
    
    cell.model = self.new_poisArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HDPOIsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //刷新其他cell
    NSArray *cells = [tableView visibleCells];
    for (HDPOIsTableViewCell *subcell in cells) {
        if (subcell == cell) {
            [subcell showSelectedView:YES];
        }else{
            [subcell showSelectedView:NO];
        }
    }
    
    ///回调
    self.selectedModel = self.new_poisArray[indexPath.row];
}

- (void)setPoisArray:(NSArray<HDPOIModel *> *)poisArray {
    _poisArray = poisArray;
    HDPOIModel *nolocationModel = [[HDPOIModel alloc]init];
    nolocationModel.name = @"不显示位置";
    [self.new_poisArray removeAllObjects];
    [self.new_poisArray addObjectsFromArray:poisArray];
    [self.new_poisArray insertObject:nolocationModel atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray *)new_poisArray {
    if (!_new_poisArray) {
        _new_poisArray = [NSMutableArray array];
        
    }
    return _new_poisArray;
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
