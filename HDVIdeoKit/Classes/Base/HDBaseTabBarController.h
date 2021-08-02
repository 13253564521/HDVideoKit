//
//  HDBaseTabBarController.h
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/28.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDUkeInfoCenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDBaseTabBarController : UITabBarController

@property (nonatomic,strong) HDUkeConfigurationModel *configuration;

@end

NS_ASSUME_NONNULL_END
