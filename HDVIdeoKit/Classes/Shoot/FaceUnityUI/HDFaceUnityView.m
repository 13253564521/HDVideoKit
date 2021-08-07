//
//  HDFaceUnityView.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/12.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDFaceUnityView.h"
#import "QNFaceUnityBeautyView.h"
#import "HDFaceModel.h"
#import "Macro.h"
@interface HDFaceUnityView ()<QNFaceUnityBeautyViewDelegate>
@property (nonatomic, strong) UILabel *beautyLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) QNFaceUnityBeautyView *unityBeautyview;


@end
@implementation HDFaceUnityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
              
        self.beautyLabel = [[UILabel alloc]init];
        self.beautyLabel.textColor = [UIColor whiteColor];
        self.beautyLabel.font = [UIFont systemFontOfSize:14];
        self.beautyLabel.textAlignment = NSTextAlignmentRight;
        self.beautyLabel.text = @"0.00";
        [self addSubview:self.beautyLabel];
        [self.beautyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-16);
            make.top.equalTo(self.mas_top);
        }];
        
        self.slider = [[UISlider alloc] init];
        [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:(UIControlEventValueChanged)];
        self.slider.continuous = YES;
        self.slider.maximumValue = 1;
        self.slider.minimumValue = 0;
        self.slider.minimumTrackTintColor = UIColor.whiteColor;
        self.slider.maximumTrackTintColor = UIColor.grayColor;
        self.slider.value = 0;
        [self.slider setThumbImage:[UIImage imageNamed:HDBundleImage(@"paishe/slider_thumbImage")] forState:UIControlStateNormal];
        [self addSubview:_slider];
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.right.equalTo(self.mas_right).offset(-16);
            make.top.equalTo(self.beautyLabel.mas_bottom).offset(4);
        }];
        
        UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.slider.frame) + 12, self.frame.size.width, self.frame.size.height - CGRectGetMaxY(self.slider.frame) - 12)];
        backview.backgroundColor = RGBA(0, 0, 0, 0.6);
        ///设置圆角
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backview.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];

        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];

        //设置大小
        maskLayer.frame = backview.bounds;

        //设置图形样子
        maskLayer.path = maskPath.CGPath;

        backview.layer.mask = maskLayer;
        [self addSubview:backview];
//        [backview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self);
//            make.top.equalTo(self.slider.mas_bottom).offset(12);
//        }];

        
        
        
        self.unityBeautyview = [[QNFaceUnityBeautyView alloc]init];
        self.unityBeautyview.delegate = self;
        [backview addSubview:self.unityBeautyview];
        [self.unityBeautyview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(self);
           make.top.equalTo(backview.mas_top).offset(32);
        }];
        
        

    }
    return self;
}

- (void)resetSeting {
    for (HDFaceModel *model in self.unityBeautyview.dataArr) {
        model.value = 0;
    }
    [self.unityBeautyview reset];
}
- (void)showNmalSeting {
    [self.unityBeautyview restoredstate];
}
- (void)sliderValueChange:(UISlider *)slider {
    HDFaceModel *facemodel = [[HDFaceModel alloc]init];
    NSString *str = @"";
    for (HDFaceModel *model in self.unityBeautyview.dataArr) {
        if (model.isselection == YES) {
            str = model.title;
            facemodel = model;
        }
    }
    facemodel.value = slider.value;
    self.beautyLabel.text = [NSString stringWithFormat:@"%.2f",slider.value];
    
    HDFaceUnityType type = 0;
    if ([str isEqualToString:@"恢复"]) {
        type = 0;
    }else if ([str isEqualToString:@"磨皮"]) {
        type = 2;
    }else if ([str isEqualToString:@"美白"]) {
        type = 3;
    }else if ([str isEqualToString:@"美颜"]) {
        type = 1;
    }
    
    if ([self.delegate respondsToSelector:@selector(faceSetVaule:type:)]) {
        [self.delegate faceSetVaule:slider.value type:type];
    }
}

-(void)beautyView:(QNFaceUnityBeautyView *)beautyView didSelectedIndex:(NSInteger)selectedIndex {
    
    HDFaceModel *facemodel = self.unityBeautyview.dataArr[selectedIndex];
    self.slider.value = facemodel.value;
    self.beautyLabel.text = [NSString stringWithFormat:@"%.2f",facemodel.value];
    
    if (selectedIndex == 0) {
        if ([self.delegate respondsToSelector:@selector(faceSetVaule:type:)]) {
            [self.delegate faceSetVaule:0 type:0];
        }
    }else {
        
    }
}
@end
