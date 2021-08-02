//
//  HDMineCollectionViewCell.h
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/5.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDUserVideoListModel.h"
#import "HDzhiboListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDMineCollectionViewCell : UICollectionViewCell

@property(nonatomic,assign) BOOL isshow;
@property(nonatomic,strong) HDUserVideoListModel *model;
@property(nonatomic,strong) HDzhiboListModel *model1;

@end

NS_ASSUME_NONNULL_END
