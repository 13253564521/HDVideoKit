//
//  HDCusTomSlelectView.h
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/5.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HDCusTomSlelectViewDelegate <NSObject>

- (void)hd_CusTomSlelectViewDidSlectItemIndex:(NSInteger)itemIndex;

@end
@interface HDCusTomSlelectView : UIView
/** 代理 */
@property(nonatomic,weak) id<HDCusTomSlelectViewDelegate> delegate;

+ (instancetype)initializeWithNames:(NSArray<NSString *> *)names;

@end

NS_ASSUME_NONNULL_END
