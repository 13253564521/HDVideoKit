//
//  HDCommentViewTableView.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/15.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDCommentCellModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol HDCommentViewTableViewDelegate <NSObject>

-(void)huifu:(HDSeedCellModel*)model;

@end

@interface HDCommentViewTableView : UITableViewCell
@property(nonatomic, strong)HDSeedCellModel *model;
@property(nonatomic, weak)id <HDCommentViewTableViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
