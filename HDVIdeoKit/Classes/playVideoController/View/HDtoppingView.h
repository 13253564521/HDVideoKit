//
//  HDtoppingView.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/15.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDtoppingView : UIView
@property (nonatomic, copy) void(^sendBtnBlock)(NSString*text);
- (void)uke_resignFirstResponder;
- (void)uke_becomeFirstResponder;
@end

NS_ASSUME_NONNULL_END
