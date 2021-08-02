//
//  HDActivityIDModel.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/25.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDActivityIDModel.h"

@implementation HDActivityIDModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"activityId":@"id"
    };

}
@end
