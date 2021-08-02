//
//  HDAlertView.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/21.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HDAlertViewdelegate <NSObject>


-(void)didxieyi;
-(void)dismms;
-(void)tongyi;
@end

@interface HDAlertView : UIView
@property(nonatomic,weak) id<HDAlertViewdelegate> dalegate;


+(instancetype)showView:(UIView*)view;
@end

NS_ASSUME_NONNULL_END
