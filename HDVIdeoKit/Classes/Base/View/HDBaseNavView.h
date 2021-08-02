//
//  HDBaseNavView.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/14.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NavBackBlcok)(void);

@interface HDBaseNavView : UIView
/** 返回回调 */
@property(nonatomic,copy) NavBackBlcok backBlock;
/** 导航标题 */
@property(nonatomic,copy) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;


@end

NS_ASSUME_NONNULL_END
