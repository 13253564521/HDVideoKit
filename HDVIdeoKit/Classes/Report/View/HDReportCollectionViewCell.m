//
//  HDReportCollectionViewCell.m
//  HDVideoKitDemok
//
//  Created by LiuGaoSheng on 2021/7/19.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDReportCollectionViewCell.h"
#import "Macro.h"
@interface HDReportCollectionViewCell()
{
    UIView *_imageContentView;
}
@end
@implementation HDReportCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        _imageContentView = [[UIView alloc]initWithFrame:self.contentView.bounds];
        _imageContentView.backgroundColor = RGBA(57, 60, 67, 0.06);
        [self.contentView addSubview:_imageContentView];
        
        [_imageContentView addSubview:self.imagev];
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

- (UIImageView *)imagev{
    if (!_imagev) {
        self.imagev = [[UIImageView alloc] initWithFrame:_imageContentView.bounds];
        self.imagev.backgroundColor = RGBA(57, 60, 67, 0.06);
        self.imagev.contentMode = UIViewContentModeScaleAspectFit;
        self.imagev.layer.cornerRadius = 5;
        self.imagev.layer.masksToBounds = YES;
        self.imagev.userInteractionEnabled = YES;
    }
    return _imagev;
}
- (UIButton *)deleteButton{
    if (!_deleteButton) {
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(CGRectGetWidth(self.bounds)-32, 0, 32, 32);
        [_deleteButton setBackgroundImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_shangchuantu_shanchu")] forState:UIControlStateNormal];

    }
    return _deleteButton;
}

@end
