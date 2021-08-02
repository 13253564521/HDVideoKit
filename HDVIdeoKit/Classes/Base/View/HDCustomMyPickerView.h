//
//  HDCustomMyPickerView.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/18.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^customBlock)(NSString *compoentString,NSString *titileString);

@interface HDCustomMyPickerView : UIView
@property (nonatomic ,copy)NSString *componentString;
@property (nonatomic ,copy)NSString *titleString;
@property (nonatomic ,copy)customBlock getPickerValue;

@property (nonatomic ,copy)NSString *valueString;
/**
 设置标题
 */
@property (nonatomic ,copy)NSString *title;


- (instancetype)initWithComponentDataArray:(NSArray *)ComponentDataArray titleDataArray:(NSArray *)titleDataArray componenttitle:(NSString *)componenttitle dataArraytitle:(NSString *)dataArraytitle;


@end

NS_ASSUME_NONNULL_END
