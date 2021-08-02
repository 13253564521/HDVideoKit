//
//  HDCityBuyCarModel.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/28.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDCityBuyCarModel : NSObject
/** 城市ID */
@property(nonatomic,copy) NSString *cityID;

/** 城市名称*/
@property(nonatomic,copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
