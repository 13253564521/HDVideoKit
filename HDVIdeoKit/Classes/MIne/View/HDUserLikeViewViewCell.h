//
//  HDUserLikeViewViewCell.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/9/28.
//

#import <UIKit/UIKit.h>
#import "HDMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDUserLikeViewViewCell : UITableViewCell
@property(nonatomic , strong) HDMessageModel *model;
@property(nonatomic , assign)int indext;

@end

NS_ASSUME_NONNULL_END
