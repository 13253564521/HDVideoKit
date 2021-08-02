//
//  HDCommentViewTableView.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/15.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDCommentViewTableView.h"
#import "Macro.h"
#import "NSDate+MJ.h"
#import "HDUkeInfoCenter.h"
@interface HDCommentViewTableView()
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UILabel *connmLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIButton *huifuBUtton;

@end

@implementation HDCommentViewTableView

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self addViews];
    }
    return self;
}

-(void)addViews{
    self.backgroundColor = UkeColorHex(0xF4F4F4);
           
    self.nameLable = [[UILabel alloc]init];
    self.nameLable.font = [UIFont systemFontOfSize:12];
    self.nameLable.textColor = UkeColorHex(0x999999);
    [self.contentView addSubview:self.nameLable];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(5);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(self.contentView).offset(5);
    }];
    
    self.connmLabel = [[UILabel alloc]init];
    self.connmLabel.font = [UIFont systemFontOfSize:12];
    self.connmLabel.textColor = UkeColorHex(0x333333);
    self.connmLabel.numberOfLines = 0;
    [self.contentView addSubview:self.connmLabel];
    [self.connmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLable);
        make.top.mas_equalTo(self.nameLable.mas_bottom).offset(5);
        make.right.mas_equalTo(self.nameLable);
    }];
    
    
   self.timeLabel = [[UILabel alloc]init];
   self.timeLabel.font = [UIFont systemFontOfSize:12];
   self.timeLabel.textColor = UkeColorHex(0x999999);
   [self.contentView addSubview:self.timeLabel];
   [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(self.nameLable);
       make.top.mas_equalTo(self.connmLabel.mas_bottom).offset(10);
   }];

  self.huifuBUtton = [[UIButton alloc]init];
  [self.huifuBUtton setTitle:@"回复" forState:0];
  [self.huifuBUtton setTitleColor:UkeColorHex(0x666666) forState:0];
  self.huifuBUtton.titleLabel.font = [UIFont systemFontOfSize:12];
  [self.huifuBUtton addTarget:self action:@selector(huifudidBtn) forControlEvents:UIControlEventTouchUpInside];
  [self.contentView addSubview:self.huifuBUtton];
  [self.huifuBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.mas_equalTo(self.contentView).offset(-10);
      make.centerY.mas_equalTo(self.timeLabel);
      
  }];

}


-(void)setModel:(HDSeedCellModel *)model {
    _model = model;
    self.nameLable.text = model.nickName;
    
    if ([model.targetUserUuid isEqualToString:model.userUuid] || [[HDUkeInfoCenter sharedCenter].userModel.uuid isEqualToString:model.userUuid]) {
        self.connmLabel.text = model.content;
    }else {
        NSString *string = [NSString stringWithFormat:@"回复%@:%@",model.targetNickName,model.content];
        NSLog(@"string %@---%@",string,model.targetNickName);
//        NSMutableAttributedString *mutableAttriteStr = [[NSMutableAttributedString alloc] init];
//        NSAttributedString *attributeStr1 = [[NSAttributedString alloc] initWithString:[string substringWithRange:NSMakeRange(2, model.targetNickName.length)] attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
//        NSAttributedString *attributeStr2 = [[NSAttributedString alloc] initWithString:[string substringWithRange:NSMakeRange(0, 2)] attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
//        NSAttributedString *attributeStr3 = [[NSAttributedString alloc] initWithString:[string substringWithRange:NSMakeRange(model.targetNickName.length + 2, model.content.length)] attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
//
//        [mutableAttriteStr appendAttributedString:attributeStr2];
//        [mutableAttriteStr appendAttributedString:attributeStr1];
//        [mutableAttriteStr appendAttributedString:attributeStr3];
//        self.connmLabel.attributedText = mutableAttriteStr;
        self.connmLabel.text = string;

    }
    
    NSDate *date = [[NSDate alloc]init];
    self.timeLabel.text = [date timeStringWithTimeInterval:model.createTime];
    
}


-(void)huifudidBtn {
    if ([self.delegate respondsToSelector:@selector(huifu:)]) {
        [self.delegate huifu:self.model];
    }
}
@end
