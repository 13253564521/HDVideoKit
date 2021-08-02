//
//  HDVideoMessageListModel.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDVideoMessageListModel : NSObject
@property (nonatomic, copy)NSString *userUuid;
/** 原为 id */
@property (nonatomic, copy)NSString *pinglunID;
@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)NSNumber *createTime;
@property (nonatomic, copy)NSString *avatar;
@property (nonatomic, strong)NSNumber *replyCount;
@property (nonatomic, strong)NSArray *children;

@end

NS_ASSUME_NONNULL_END
