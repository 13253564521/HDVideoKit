//
//  HDUserLikeViewController.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/9/28.
//

#import "HDUserLikeViewController.h"
#import "HDUserLikeView.h"
#import "Macro.h"
#import "HDMyViewController.h"
@interface HDUserLikeViewController ()<HDUserLikeViewdelegate>

@end

@implementation HDUserLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    HDUserLikeView *vie = [[HDUserLikeView alloc]initWithFrame:CGRectZero];
    vie.delegate = self;
    vie.indext = self.indext;
    [self.view addSubview:vie];
    [vie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
  
}

- (void)didSelectRowAtIndexPath:(NSString *)uuid {
    HDMyViewController * vc = [[HDMyViewController alloc]init];
    vc.userID = uuid;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
