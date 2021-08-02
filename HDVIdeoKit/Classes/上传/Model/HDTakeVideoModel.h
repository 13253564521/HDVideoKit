//
//  HDTakeVideoModel.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/14.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDTakeVideoModel : NSObject
/** 图片名称 */
@property(nonatomic,copy) NSString *imageName;

/** 主标题 */
@property(nonatomic,copy) NSString *title;

/** 副标题 */
@property(nonatomic,copy) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
