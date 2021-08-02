//
//  HDPlatesModel.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/22.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDPlatesModel : NSObject
/** 名称 */
@property(nonatomic,copy) NSString *name;
/** id */
@property(nonatomic,copy) NSString *platesid;

/** 是否被选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
