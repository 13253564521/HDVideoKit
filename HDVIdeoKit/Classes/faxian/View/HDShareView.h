//
//  HDShareView.h
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/9/2.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HDShareViewDelegate <NSObject>


- (void)hd_shareViewdidClickWchat;
- (void)hd_shareViewdidClickWchatZone;
- (void)hd_shareViewdidClickWebUrl;

- (void)hd_shareViewdidClickClose;
@end
@interface HDShareView : UIView
/** 代理 */
@property(nonatomic,weak) id<HDShareViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
