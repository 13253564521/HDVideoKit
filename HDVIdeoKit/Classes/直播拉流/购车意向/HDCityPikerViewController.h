//
//  HDCityPikerViewController.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/18.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HDCityBuyCarModel;
typedef void (^cityPikerVcBlock)(HDCityBuyCarModel *province, HDCityBuyCarModel *city);

@interface HDCityPikerViewController : UIViewController

@property (nonatomic ,copy)cityPikerVcBlock getPickerValue;
/**
 初始化方法
 */
- (instancetype)initWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
