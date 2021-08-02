//
//  HDVidoCommentTools.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/25.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDVideoCommentTools : UIView
@property (nonatomic, copy) void(^writeCommentBlock)(void);
@end

@interface HDWriteCommentView : UIView
@property (nonatomic, copy) void(^cancleBtnBlock)(void);
@property (nonatomic, copy) void(^sendBtnBlock)(NSString*text);
- (void)uke_resignFirstResponder;
- (void)uke_becomeFirstResponder;
@end

NS_ASSUME_NONNULL_END
