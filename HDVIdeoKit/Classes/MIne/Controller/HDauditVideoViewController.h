//
//  HDauditVideoViewController.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/12/6.
//

#import <UIKit/UIKit.h>
#import "HDUserVideoListModel.h"
#import "HDNavigationProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDauditVideoViewController : UIViewController<HDNavigationProtocol>
@property(nonatomic,strong) HDUserVideoListModel* model;

@end

NS_ASSUME_NONNULL_END
