//
//  HDVideoButton.m
//  HDVideoKitDemok
//
//  Created by LiuGaoSheng on 2021/7/13.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDVideoButton.h"


#define LINEWIDTH 7
@interface HDVideoButton()
@property (nonatomic,strong) CAShapeLayer * borderLayer;

@property (nonatomic,strong) CAShapeLayer * incycleLayer;
@end
@implementation HDVideoButton
-(CAShapeLayer *)borderLayer{
    if (!_borderLayer) {
        _borderLayer = [[CAShapeLayer alloc] init];
        _borderLayer.borderWidth = LINEWIDTH;
        _borderLayer.cornerRadius = self.bounds.size.width/2;
        _borderLayer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
        
        [self.layer addSublayer:_borderLayer];

    }
    return _borderLayer;
}

-(CAShapeLayer *)incycleLayer{
    if (!_incycleLayer) {
        _incycleLayer = [[CAShapeLayer alloc] init];
        _incycleLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:_incycleLayer];
    }
    return _incycleLayer;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.incycleLayer.frame = CGRectMake(LINEWIDTH+3, LINEWIDTH+3, self.frame.size.width-(LINEWIDTH+3)*2, self.frame.size.height-(LINEWIDTH+3)*2);
        self.incycleLayer.cornerRadius = self.incycleLayer.frame.size.width/2;
        self.borderLayer.frame = self.bounds;
    }
    return self;
}

-(void)startRecording:(BOOL)state{
    CABasicAnimation *radiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    radiusAnimation.fromValue = @(self.incycleLayer.cornerRadius);
    CGRect bounds = self.incycleLayer.bounds;
    boundsAnimation.fromValue = [NSValue valueWithCGRect:bounds];
    if (state) {
        radiusAnimation.toValue = @(8);
        bounds.size.width = self.bounds.size.width*0.5;
        bounds.size.height = self.bounds.size.height*0.5;
        boundsAnimation.toValue = [NSValue valueWithCGRect:bounds];
        self.incycleLayer.cornerRadius = 8.0f;
        self.incycleLayer.bounds = bounds;
    }else{
        bounds.size.width = self.frame.size.width-(LINEWIDTH+4)*2;
        bounds.size.height = self.frame.size.height-(LINEWIDTH+4)*2;
        boundsAnimation.toValue = [NSValue valueWithCGRect:bounds];
        radiusAnimation.toValue = @(bounds.size.width/2);
        self.incycleLayer.cornerRadius = bounds.size.width/2;
        self.incycleLayer.bounds = bounds;
    }
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:radiusAnimation, boundsAnimation, nil];
    animGroup.duration = 0.3;

    [self.incycleLayer addAnimation:animGroup forKey:nil];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
