//
//  HDCityPikerViewController.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/18.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDCityPikerViewController.h"
#import "HDCityPikerView.h"
#import "Macro.h"
#import "HDCityBuyCarModel.h"
#import "HDServicesManager.h"

@interface HDCityPikerViewController ()
{
    NSString *_title;
    NSArray  *_leftArray;
    NSArray  *_rightArray;
    HDCityPikerView *_pikerView;
}
@end

@implementation HDCityPikerViewController

- (instancetype)initWithTitle:(NSString *)title {
    _title = title;
    return [self init];
}
- (instancetype)init
{
    if (self = [super init])
    {
        
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        HDCityPikerView *view = [[HDCityPikerView alloc] initHDCityPikerViewWithtitle:_title];
        view.title = _title;
        [self.view addSubview:view];
        _pikerView = view;
        
        @WeakObj(self);
        view.getPickerValue = ^(HDCityBuyCarModel * _Nonnull province, HDCityBuyCarModel * _Nonnull city) {
            !selfWeak.getPickerValue ? : selfWeak.getPickerValue(province,city);
        };

        
        view.provinceChangeBlock = ^(HDCityBuyCarModel * _Nonnull province) {
            [HDServicesManager getWhereToBuyCarWithProvinceCode:province.cityID block:^(BOOL isSuccess, NSArray * _Nonnull dataArray, NSString * _Nonnull alertStr) {
                if (isSuccess) {
                    self->_rightArray = dataArray;
                    self->_pikerView.cityArray = dataArray;
                }
            }];
        };

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestProvinceinfo];
}
- (void)requestProvinceinfo {
    [SVProgressHUD show];
    [HDServicesManager getWhereToBuyCarWithProvinceCode:@"" block:^(BOOL isSuccess, NSArray * _Nonnull dataArray, NSString * _Nonnull alertStr) {
        [SVProgressHUD dismiss];
        if (isSuccess) {
            self->_leftArray = dataArray;
            self->_pikerView.provinceArray = dataArray;
        }
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self dismissViewControllerAnimated:self completion:nil];
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
