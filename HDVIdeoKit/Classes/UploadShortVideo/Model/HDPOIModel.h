//
//  HDPOIModel.h
//  HDVideoKitDemok
//
//  Created by LiuGaoSheng on 2021/7/21.
//  Copyright © 2021 刘高升. All rights reserved.
//poi相关model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDPOIModel : NSObject
/** 地址 */
@property(nonatomic,copy) NSString *address;
/** location */
@property(nonatomic,copy) NSString *location;
/**
 名称
 */
@property(nonatomic,copy) NSString *name;



@end

NS_ASSUME_NONNULL_END
