//
//  HDCoomCollectionView.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/16.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDUserVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HDCoomCollectionViewDelagete <NSObject>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath data:(NSMutableArray *)data;

@end

@interface HDCoomCollectionView : UIViewController
@property(nonatomic , weak) id<HDCoomCollectionViewDelagete> delegate;
@property(nonatomic , strong) UICollectionView *collectionView;

-(void)loadNewData;
@end

NS_ASSUME_NONNULL_END
