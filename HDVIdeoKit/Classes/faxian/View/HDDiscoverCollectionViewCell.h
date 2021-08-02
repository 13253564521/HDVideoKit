//
//  HDDiscoverCollectionViewCell.h
//  HDVideoKit
//
//  Created by liugaosheng on 2020/8/30.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDUserVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDDiscoverCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) HDUserVideoListModel *model;

@property(nonatomic,assign)BOOL ishiddeView;

-(void)setModeldate:(HDUserVideoListModel *)model;
@end

NS_ASSUME_NONNULL_END
