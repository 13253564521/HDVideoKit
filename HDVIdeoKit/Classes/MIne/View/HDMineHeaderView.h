//
//  HDMineHeaderView.h
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/5.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDHDMyModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HDCusTomSlelectView;
@protocol HDMineHeaderViewDelegate <NSObject>

- (void)hd_mineHeaderViewDidClickModifName;
- (void)hd_UserfenxiDidButton;
- (void)hd_UserguanzhuDidButton;
- (void)hd_UserzanDidButton;
@end


@interface HDMineHeaderView : UIView
/** 代理 */
@property(nonatomic,weak) id<HDMineHeaderViewDelegate> delegate;
@property(nonatomic , strong)HDCusTomSlelectView *selectView;
@property(nonatomic , strong)HDHDMyModel *model;

@property(nonatomic,strong) NSString* userID;

@end

NS_ASSUME_NONNULL_END
