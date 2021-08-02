//
//  HDCommentViewCell.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/15.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDCommentViewCell.h"
#import "Macro.h"
#import "HDCommentViewTableView.h"
#import "HDServicesManager.h"
#import "YYWebImage.h"
#import "NSDate+MJ.h"
#import "UKRequestURLPath.h"
#import "HDCommentCellModel.h"
#import "HDSecondaryCommentCell.h"

NSString *const sencond_identifier = @"secondarycomment_identifier";
@interface HDCommentViewCell()<UITableViewDelegate,UITableViewDataSource,HDCommentViewTableViewDelegate,HDSecondaryCommentCellDelegate>
@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UILabel *connmLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIButton *zanBUtton;
@property (nonatomic, strong)UIButton *huifuBUtton;

@property(nonatomic , strong)UITableView *tableView;

@property(nonatomic , assign)BOOL isshuaxin;
@property(nonatomic , strong)UIView *xianView;

@property (nonatomic, assign) BOOL isNetWork;
@end

@implementation HDCommentViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.clipsToBounds = YES;
        self.isNetWork = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initAddView];
    }
    return self;
}

-(void)initAddView {
      self.backgroundColor = [UIColor clearColor];
      self.headerImage = [[UIImageView alloc]init];
      self.headerImage.layer.cornerRadius = 28 /2;
      self.headerImage.layer.masksToBounds = YES;
      [self.contentView addSubview:self.headerImage];
      [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(self.contentView).offset(12);
          make.left.mas_equalTo(self.contentView).offset(16);
          make.height.width.mas_equalTo(28);
      }];
      
    self.zanBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zanBUtton setTitle:@"点赞" forState:0];
    [self.zanBUtton setTitle:@"已赞" forState:UIControlStateSelected];
    [self.zanBUtton setTitleColor:RGBA(50, 60, 67, 0.56) forState:0];
    [self.zanBUtton setTitleColor:RGBA(50, 60, 67, 0.56) forState:UIControlStateSelected];
    [self.zanBUtton setImage:[UIImage imageNamed:HDBundleImage(@"currency/icon_comment_zan")] forState:UIControlStateNormal];
    [self.zanBUtton setImage:[UIImage imageNamed:HDBundleImage(@"currency/icon_comment_yidianzan")] forState:UIControlStateSelected];
    
    self.zanBUtton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.zanBUtton addTarget:self action:@selector(zandidBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.zanBUtton];
    [self.zanBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.headerImage.mas_centerY);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(60);
    }];
    self.zanBUtton.hidden = YES;
    
    
      self.nameLable = [[UILabel alloc]init];
      self.nameLable.font = [UIFont systemFontOfSize:12];
      self.nameLable.textColor = RGBA(57, 60, 67, 1);
      [self.contentView addSubview:self.nameLable];
      [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.headerImage.mas_right).offset(8);
          make.centerY.equalTo(self.headerImage.mas_centerY);
          make.right.equalTo(self.zanBUtton.mas_left).offset(-8);
      }];
      
      self.connmLabel = [[UILabel alloc]init];
      self.connmLabel.font = [UIFont systemFontOfSize:14];
     self.connmLabel.textColor = RGBA(57, 60, 67, 1);
      self.connmLabel.numberOfLines = 0;
      [self.contentView addSubview:self.connmLabel];
      [self.connmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.nameLable.mas_left);
          make.top.equalTo(self.headerImage.mas_bottom).offset(8);
          make.right.equalTo(self.contentView.mas_right).offset(-16);
      }];
      
      
     self.timeLabel = [[UILabel alloc]init];
     self.timeLabel.font = [UIFont systemFontOfSize:10];
     self.timeLabel.textColor = UkeColorHex(0x999999);
     [self.contentView addSubview:self.timeLabel];
     [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.nameLable.mas_left);
         make.top.equalTo(self.connmLabel.mas_bottom).offset(13);
     }];
      
      self.huifuBUtton = [[UIButton alloc]init];
      [self.huifuBUtton setBackgroundColor:RGBA(57, 60, 67, 0.12)];
      [self.huifuBUtton setTitle:@"回复" forState:0];
      [self.huifuBUtton setTitleColor: RGBA(57, 60, 67, 1) forState:0];
      self.huifuBUtton.titleLabel.font = [UIFont systemFontOfSize:12];
      self.huifuBUtton.layer.cornerRadius = 10;
      self.huifuBUtton.layer.masksToBounds = YES;
      [self.huifuBUtton addTarget:self action:@selector(huifudidBtn) forControlEvents:UIControlEventTouchUpInside];
      [self.contentView addSubview:self.huifuBUtton];
      [self.huifuBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.timeLabel.mas_right).offset(12);
          make.centerY.equalTo(self.timeLabel.mas_centerY);
          make.width.mas_equalTo(40);
          make.height.mas_equalTo(22);
          
      }];
      

    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      if (@available(iOS 11.0, *)) {
          _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      }
    [self.tableView registerClass:[HDSecondaryCommentCell class] forCellReuseIdentifier:sencond_identifier];
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable.mas_left).offset(-16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(21);
        make.height.mas_equalTo(0);
    }];
    
    
    self.xianView = [[UIView alloc]init];
    self.xianView.backgroundColor = UkeColorHex(0xEDEDED);
    [self.contentView addSubview:self.xianView];
    [self.xianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(16);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
  
}

-(void)setModel:(HDCommentCellModel *)model {
    _model = model;
    
    self.nameLable.text = model.nickName;
    self.connmLabel.text = model.content;

    [self.tableView reloadData];
    
    NSDate *date = [[NSDate alloc]init];
    self.timeLabel.text = [date timeStringWithTimeInterval:[model.createTime stringValue]];
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];
    if (model.children.count > 0 ) {
        //重新计算tableview 高度
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLable.mas_left).offset(-16);
            make.right.equalTo(self.contentView.mas_right).offset(-16);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(21);
            make.height.mas_equalTo(model.CellTableViewHeight);
        }];
        
    }
    
}



-(void)huifudidBtn {
    if ([self.delegate respondsToSelector:@selector(hd_CommentViewCellhuifuWithModel:lastPinglunId:)]) {
        [self.delegate hd_CommentViewCellhuifuWithModel:self.model lastPinglunId:self.model.pinglunID];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.model.children.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,indexPath.row];
    HDSecondaryCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:sencond_identifier forIndexPath:indexPath];
    cell.model = self.model.children[indexPath.row];
    cell.pinglunID = self.model.pinglunID;
    cell.delegate = self;
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.model.replyCount integerValue] >= 2) {
        UIView *footView = [[UIView alloc]init];

        UIButton *button = [[UIButton alloc]init];
        button.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        [button setTitle:[NSString stringWithFormat:@"查看全部 %@ 条回复", self.model.replyCount] forState:0];
        [button setImage:[UIImage imageNamed:HDBundleImage(@"video/icon_zhibo_choujiang_jiantou2")] forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:RGBA(0, 61, 227, 1) forState:0];
        [button addTarget:self action:@selector(zhankaiBUttondid) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(footView);
            make.left.equalTo(footView.mas_left).offset(48);
        }];
        NSLog(@"replyCount:=%@",self.model.replyCount);
        return footView;
    }
    return  nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    NSLog(@"%d",[self.model.replyCount intValue]);
    if ([self.model.replyCount intValue] < 2 || self.model.children.count == 0 || self.model.isUserSelect == YES ) {
        return 0;
    }
    return 36;
}


-(void)zhankaiBUttondid {
    if ([self.delegate respondsToSelector:@selector(tablefooterViewIndex:videoUUID:pinglunId:islikeVideo:)]) {
        [self.delegate tablefooterViewIndex:self.cellindex videoUUID:self.videUUID pinglunId:self.model.pinglunID islikeVideo:self.islikeVideo];
    }

}


- (void)zandidBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - HDSecondaryCommentCellDelegate
- (void)hd_secondaryCommentCellDidClickHuifuWithModel:(HDCommentCellModel *)model lastPinglunId:(NSString *)lastPinglunId {
    if ([self.delegate respondsToSelector:@selector(hd_CommentViewCellhuifuWithModel:lastPinglunId:)]) {
        [self.delegate hd_CommentViewCellhuifuWithModel:model lastPinglunId:lastPinglunId];
    }
}
@end
