//
//  HDReportViewTableViewCell.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/11.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDReportViewTableViewCell.h"
#import "Macro.h"

@interface HDReportViewTableViewCell ()
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UILabel *label;

@end

@implementation HDReportViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.button = [[UIButton alloc]init];
        [self.button setImage:[UIImage imageNamed:HDBundleImage(@"currency/icon_choice_normal")] forState:0];
        [self.button setImage:[UIImage imageNamed:HDBundleImage(@"currency/icon_choice_selected")] forState:UIControlStateSelected];
        [self.contentView addSubview:self.button];
        [self.button addTarget:self action:@selector(didbutton) forControlEvents:UIControlEventTouchUpInside];        
        [self.button sizeToFit];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self).offset(-30);
        }];
        
        self.label = [[UILabel alloc]init];
        self.label.textColor = UkeColorHex(0x333333);
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(35);
        }];
 
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    

}

-(void)setModel:(HDReportModel *)model {
    _model = model;
    self.label.text = model.title;
    [self.label sizeToFit];
    
    self.button.hidden = !model.isShow;
    if (model.isShow) {
       self.label.textColor = UkeColorHex(0x333333);
       self.label.font = [UIFont systemFontOfSize:12];
    }else {
        
        self.label.textColor = UkeColorHex(0x666666);
        self.label.font = [UIFont systemFontOfSize:12];
    }
    
}

-(void)didbutton {
    self.button.selected = !self.button.selected;
    self.model.isxuanzhong = self.button.selected;
}

@end
