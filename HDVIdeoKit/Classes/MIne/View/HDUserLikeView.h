//
//  HDUserLikeView.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/9/28.
//

#import <UIKit/UIKit.h>
#import "HDMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HDUserLikeViewdelegate <NSObject>

-(void)didSelectRowAtIndexPath:(NSString *)uuid;

@end

@interface HDUserLikeView : UIView
@property(nonatomic , assign)int indext;
@property(nonatomic , weak)id<HDUserLikeViewdelegate> delegate;

@end

NS_ASSUME_NONNULL_END
