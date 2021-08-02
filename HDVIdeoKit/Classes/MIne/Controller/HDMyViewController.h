//
//  HDMyViewController.h
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/28.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDBaseViewController.h"
#import "HDNavigationProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HDMyViewControllerdelegate <NSObject>

-(void)controllerpopView;

@end

@interface HDMyViewController : HDBaseViewController<HDNavigationProtocol>
@property(nonatomic,strong) NSString* userID;
@property(nonatomic,weak) id<HDMyViewControllerdelegate>delegate;

@end

NS_ASSUME_NONNULL_END
