//
//  HDCustomTabBar.h
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/28.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HDCustomTabBar;
 //HDCustomTabBar的代理必须实现addButtonClick，以响应中间“+”按钮的点击事件
@protocol HDCustomTabBarDelegate <NSObject>
@required
- (void)addButtonClick:(HDCustomTabBar *)tabBar clickItem:(UIButton *)item;
@end
@interface HDCustomTabBar : UITabBar
@property (nonatomic,weak) id<HDCustomTabBarDelegate> delegate;

+ (instancetype)sharedManager;
-(void)showxiaoxi;
-(void)dismmxiaoxi;
@end

NS_ASSUME_NONNULL_END
