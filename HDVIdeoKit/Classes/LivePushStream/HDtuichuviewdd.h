//
//  HDtuichuviewdd.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/23.
//

#import <UIKit/UIKit.h>
#import "HDzhiboModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HDtuichuviewdddelegate <NSObject>

- (void)closetuichaView;

@optional
///关注主播,不迷路
- (void)foucsZhuboClickWithSender:(UIButton *)sender UserID:(NSString *)userID publisherId:(NSString *)publisherId flag:(NSString *)flag;
///点击主播用户头像
- (void)anchorUserIconDidClick;

@end

@interface HDtuichuviewdd : UIView
@property(nonatomic,strong) HDzhiboModel *model;
@property(nonatomic,weak) id<HDtuichuviewdddelegate> delegate;


- (void)showfoucsButton:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
