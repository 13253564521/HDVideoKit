//
//  HDshangchuanTableViewCell.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/10/8.
//

#import "HDshangchuanTableViewCell.h"
#import "Macro.h"
@interface HDshangchuanTableViewCell()
@property (nonatomic,strong)UIButton *button;

@property(nonatomic , strong)UILabel *title;

@end

@implementation HDshangchuanTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setImage:[UIImage imageNamed:HDBundleImage(@"currency/btn_checkbox_unselected")] forState:0];
        [self.button setImage:[UIImage imageNamed:HDBundleImage(@"currency/btn_checkbox_selected")] forState:UIControlStateSelected];
        [self.contentView addSubview:self.button];
        [self.button sizeToFit];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-16);
            make.width.height.mas_equalTo(24);
        }];
        
        UILabel *title = [[UILabel alloc]init];

        title.textColor = RGBA(57, 60, 67, 1);
        title.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(self.contentView.mas_left).offset(16);
            make.right.equalTo(self.button.mas_left).offset(-16);
            make.top.equalTo(self.contentView.mas_top).offset(14);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-14);
        }];
        self.title = title;
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBA(222, 225, 231, 1);
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(16);
            make.right.equalTo(self.contentView.mas_right).offset(-16);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
    
}

-(void)setModel:(HDHuatiModel *)model {
    _model = model;
    self.title.text = [NSString stringWithFormat:@"#%@",model.name];
    self.button.selected = model.isxuanzhong;
}

@end
