//
//  HDHuatiViewController.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/26.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class HDHuatiModel;

typedef void(^huatiSelectedBlock)(NSArray<HDHuatiModel *> *array);
@interface HDHuatiViewController : HDBaseViewController
/** 话题选择数组 */
@property(nonatomic,copy) huatiSelectedBlock huatiSelectedblock;
/** 话题数组 */
@property(nonatomic,strong) NSArray<HDHuatiModel *> *huatisArray;
@end

NS_ASSUME_NONNULL_END
