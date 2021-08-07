//
//  HDimageTagView.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/12.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDimageTagView;
NS_ASSUME_NONNULL_BEGIN

@protocol HDimageTagViewdeveloper <NSObject>

-(void)viewdismm:(int)tag;
-(void)pushImageController;
@end

@interface HDimageTagView : UIView
@property (nonatomic,weak)id <HDimageTagViewdeveloper> delegate;

@property (nonatomic,assign)int viewtag;

@property (nonatomic,strong)UIImage *imag;
@property (nonatomic,strong)UIButton *disButton;
@property (nonatomic,strong)UILabel *textlabel;
@property (nonatomic,assign)int currentTag;

@end

NS_ASSUME_NONNULL_END
