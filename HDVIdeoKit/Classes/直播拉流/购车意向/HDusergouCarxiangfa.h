//
//  HDusergouCarxiangfa.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDusergouCarxiangfa : UIView

@property (nonatomic, copy) void(^Handler)(void);
@property(nonatomic,strong) NSString *uuid;
@property(nonatomic,assign) CGFloat titlealpath;
@property(nonatomic,strong) UIViewController *superVc;
@end

NS_ASSUME_NONNULL_END
