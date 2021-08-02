//
//  HDPOISelectedViewController.h
//  HDVideoKitDemok
//
//  Created by LiuGaoSheng on 2021/7/21.
//  Copyright © 2021 刘高升. All rights reserved.
//位置选择 POI 控制器

#import "HDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class HDPOIModel;
typedef void(^seletedLocationBlock)(HDPOIModel *model);

@interface HDPOISelectedViewController : HDBaseViewController
/** pois数组 */
@property(nonatomic,strong) NSArray<HDPOIModel *> *poisArray;

/** 选中位置回调 */
@property(nonatomic,copy) seletedLocationBlock locationBlock;


@end

NS_ASSUME_NONNULL_END
