//
//  HDMessagesTableViewCell.h
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/5.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDMessagesTableViewCell : UITableViewCell

@property(nonatomic,strong) HDMessageModel *model;
@end

NS_ASSUME_NONNULL_END
