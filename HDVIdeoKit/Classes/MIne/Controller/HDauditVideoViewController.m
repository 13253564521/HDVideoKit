//
//  HDauditVideoViewController.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/12/6.
//

#import "HDauditVideoViewController.h"
#import "Macro.h"

@interface HDauditVideoViewController ()

@end

@implementation HDauditVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backimage = [[UIImageView alloc]init];
    backimage.contentMode = UIViewContentModeScaleAspectFill;
    [backimage yy_setImageWithURL:[NSURL URLWithString:self.model.coverUrl] placeholder:nil];

    [self.view addSubview:backimage];
    [backimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"视频正在审核中，请稍等" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVc addAction:sureBtn];
    [self presentViewController:alertVc animated:YES completion:nil];
    // Do any additional setup after loading the view.
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
