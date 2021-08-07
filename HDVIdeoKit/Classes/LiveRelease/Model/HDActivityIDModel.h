//
//  HDActivityIDModel.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/25.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDActivityIDModel : NSObject
/** 活动id */
@property(nonatomic,copy) NSString *activityId;
/** 活动名称 */
@property(nonatomic,copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
