//
//  HDVideoMessageListViewCell.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/5.
//

#import "HDVideoMessageListViewCell.h"
#import "Macro.h"

@interface HDVideoMessageListViewCell()
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HDVideoMessageListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor =  [UIColor clearColor];
        
        UIView *top = [[UIView alloc]init];
        top.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:top];
        [top mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(4);
        }];
    
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = RGBA(0, 0, 0, 0.3);
        backView.layer.cornerRadius = 5;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(top.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_bottom);

            
        }];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = [UIColor whiteColor];
        [backView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-8);
        }];
        

    }
    return self;
    
}

-(void)setModel:(HDVideoMessageListModel *)model {
    _model = model;
     NSString *contentStr  = [NSString stringWithFormat:@"%@: %@",model.nickName,model.content];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentStr];
    [attributedString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],NSForegroundColorAttributeName : RGBA(55, 113, 255, 1)} range:[contentStr rangeOfString:[NSString stringWithFormat:@"%@:",model.nickName]]];
    [attributedString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],NSForegroundColorAttributeName : [UIColor whiteColor]} range:[contentStr rangeOfString:model.content]];

    [self.titleLabel setAttributedText:attributedString];
    [self layoutIfNeeded];
}
@end
