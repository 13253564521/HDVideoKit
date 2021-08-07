//
//  HDCityPikerView.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/18.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HDCityBuyCarModel;
typedef void (^cityPikerBlock)(HDCityBuyCarModel *province,HDCityBuyCarModel *city);

typedef void (^provinceChangePikerBlock)(HDCityBuyCarModel *province);

@interface HDCityPikerView : UIView
@property (nonatomic ,copy)cityPikerBlock getPickerValue;
@property (nonatomic ,copy)provinceChangePikerBlock provinceChangeBlock;
/**
 设置标题
 */
@property (nonatomic ,copy)NSString *title;
@property (strong, nonatomic) NSArray<HDCityBuyCarModel *> *provinceArray;
@property (strong, nonatomic) NSArray<HDCityBuyCarModel *> *cityArray;


- (instancetype)initHDCityPikerViewWithtitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
