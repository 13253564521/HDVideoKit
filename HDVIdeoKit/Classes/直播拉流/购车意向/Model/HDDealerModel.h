//
//  HDDealerModel.h
//  HDVideoKitDemok
//
//  Created by LiuGaoSheng on 2021/7/27.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDDealerModel : NSObject
/** dealerCode */
@property(nonatomic,copy) NSString *dealerCode;
/** dealerId */
@property(nonatomic,copy) NSString *dealerId;

/** dealerName  ----经销商名称*/
@property(nonatomic,copy) NSString *dealerName;
@end

NS_ASSUME_NONNULL_END
