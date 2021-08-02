//
//  HDModifNameViewController.h
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/5.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HDModifNameViewControllerdelegate <NSObject>

-(void)nameScurre;

@end

@interface HDModifNameViewController : HDBaseViewController
@property(nonatomic,weak) id<HDModifNameViewControllerdelegate> delegate;

@end

NS_ASSUME_NONNULL_END
