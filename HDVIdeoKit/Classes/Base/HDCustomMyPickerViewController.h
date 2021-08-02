//
//  HDCustomMyPickerViewController.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/18.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^customBlock)(NSString *compoentString,NSString *titileString);
@interface HDCustomMyPickerViewController : UIViewController
@property (nonatomic ,copy)customBlock getPickerValue;
/**
 初始化方法
 */
- (instancetype)initWithTitle:(NSString *)title leftDataArray:(NSArray *)leftArray rightData:(NSArray *)rightArray componenttitle:(NSString *)componenttitle dataArraytitle:(NSString *)dataArraytitle;

@end

NS_ASSUME_NONNULL_END
