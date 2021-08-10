//
//  HDVideoProtocol.h
//  HDVideoKitDemok
//
//  Created by LiuGaoSheng on 2021/8/10.
//  Copyright © 2021 刘高升. All rights reserved.
//通用协议制定

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol HDVideoProtocol <NSObject>
/**
 用户点击头像，并携带UserId
 */
- (void)hd_videoProtocolDidClickUserIconWithUserId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
