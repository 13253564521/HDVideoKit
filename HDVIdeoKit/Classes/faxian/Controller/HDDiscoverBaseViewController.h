//
//  HDDiscoverBaseViewController.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/11.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HDDiscoverBaseViewControllerdelegate <NSObject>

-(void)popviewcontrooler;

@end

@interface HDDiscoverBaseViewController : HDBaseViewController
@property(nonatomic,weak)id<HDDiscoverBaseViewControllerdelegate>delegate;
@end

NS_ASSUME_NONNULL_END
