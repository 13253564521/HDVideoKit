//
//  QNFaceUnityBeautyView.h
//  ShortVideo
//
//  Created by hxiongan on 2019/4/30.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QNFaceUnityBeautyView;

@protocol QNFaceUnityBeautyViewDelegate <NSObject>

- (void)beautyView:(QNFaceUnityBeautyView *)beautyView didSelectedIndex:(NSInteger)selectedIndex;

@end

@interface QNFaceUnityBeautyView : UIView

@property (nonatomic, assign) id<QNFaceUnityBeautyViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
/**
 重置
 */
- (void)reset;
/**
 还原上一次状态
 */
- (void)restoredstate;
@end

NS_ASSUME_NONNULL_END
