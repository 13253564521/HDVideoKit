//
//  HDTopImageBottomTextButton.m
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/31.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDTopImageBottomTextButton.h"

@implementation HDTopImageBottomTextButton

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float  spacing = self.space ? self.space : 0.5;//图片和文字的上下间距
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

- (void)setSpace:(CGFloat)space {
    _space = space;
    [self layoutIfNeeded];
    [self setNeedsLayout];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
