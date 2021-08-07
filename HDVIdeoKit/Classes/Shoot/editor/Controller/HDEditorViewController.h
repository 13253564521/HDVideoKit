//
//  HDEditorViewController.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/12.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDEditorViewController : HDBaseViewController
@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) NSArray <NSURL *>* fileURLArray;
@end

NS_ASSUME_NONNULL_END
