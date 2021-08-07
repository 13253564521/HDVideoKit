//
//  HDzhibochouiangView.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/1.
//

#import <UIKit/UIKit.h>
#import "HDzhiboModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDzhibochouiangView : UIView
@property(nonatomic,strong) HDzhiboModel *model;
@property (assign, nonatomic)NSInteger selectIndex;
@property (nonatomic, copy) void(^Handler)(void);

@end

NS_ASSUME_NONNULL_END
