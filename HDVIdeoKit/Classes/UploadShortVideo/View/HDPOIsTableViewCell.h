//
//  HDPOIsTableViewCell.h
//  HDVideoKitDemok
//
//  Created by LiuGaoSheng on 2021/7/21.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class  HDPOIModel;
@interface HDPOIsTableViewCell : UITableViewCell
/** mdoel */
@property(nonatomic,strong) HDPOIModel *model;

- (void)showSelectedView:(BOOL)show;
@end

NS_ASSUME_NONNULL_END
