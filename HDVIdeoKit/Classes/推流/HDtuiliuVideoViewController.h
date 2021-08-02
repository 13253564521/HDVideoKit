//
//  HDtuiliuVideoViewController.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/10/27.
//

#import "HDBaseViewController.h"
#import "HDNavigationProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDtuiliuVideoViewController : HDBaseViewController<HDNavigationProtocol>
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, assign)BOOL ispopview;
@property (nonatomic, assign)BOOL isliveVideoparticulars;//直播详情跳转过来
@property (nonatomic, assign)BOOL isyingjianzhibo;//yes为硬件直播

@end

NS_ASSUME_NONNULL_END
