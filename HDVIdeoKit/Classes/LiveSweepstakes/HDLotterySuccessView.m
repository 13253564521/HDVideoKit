//
//  HDLotterySuccessView.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/17.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDLotterySuccessView.h"
#import "Macro.h"

@interface HDLotterySuccessView()
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lotteryLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *lotteryImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *adressTextfield;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end


@implementation HDLotterySuccessView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    HDLotterySuccessView *successView = [[[NSBundle mainBundle] loadNibNamed:@"HDLotterySuccessView" owner:nil options:nil] lastObject];
    successView.frame = frame;
    self = [super initWithFrame:frame];
    if (self) {
        successView.backgroundColor = [UIColor clearColor];
    }
    return successView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 15;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.backgroundColor = RGBA(222, 225, 231, 1);
    self.titleImageView.image = [UIImage imageNamed:HDBundleImage(@"video/img_head")];
    [self.closeButton setBackgroundImage:[UIImage imageNamed:HDBundleImage(@"video/btn_x")] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_common_normal_bg")] forState:UIControlStateNormal];
    self.nameTextfield.layer.cornerRadius = 2;
    self.nameTextfield.layer.masksToBounds = YES;
    self.nameTextfield.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextfield.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 40)];
    
    
    self.phoneTextField.layer.cornerRadius = 2;
    self.phoneTextField.layer.masksToBounds = YES;
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 40)];
    
    self.adressTextfield.layer.cornerRadius = 2;
    self.adressTextfield.layer.masksToBounds = YES;
    self.adressTextfield.leftViewMode = UITextFieldViewModeAlways;
    self.adressTextfield.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 40)];
    
}
#pragma mark - click

- (IBAction)closeButtonClick:(UIButton *)sender {
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(hd_LotterySuccessViewDidClickclose)]) {
        [self.delegate hd_LotterySuccessViewDidClickclose];
    }
    
}
- (IBAction)submitClick:(UIButton *)sender {
    if (self.nameTextfield.text.length <= 0) {
        return [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
    }
    
    if (self.phoneTextField.text.length <= 0) {
        return [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
    }
    
    if (self.adressTextfield.text.length <= 0) {
        return [SVProgressHUD showErrorWithStatus:@"请输入地址"];
    }
    
    if ([self valiMobile:self.phoneTextField.text] == NO) {
        return [SVProgressHUD showErrorWithStatus:@"请输入正确手机号"];
    }
    
    if ([self.delegate respondsToSelector:@selector(hd_LotterySuccessViewDidClicksubmit:phone:address:)]) {
        [self.delegate hd_LotterySuccessViewDidClicksubmit:self.nameTextfield.text phone:self.phoneTextField.text address:self.adressTextfield.text];
    }
}
#pragma mark - setter
- (void)setLotteryInfo:(NSString *)lotteryInfo {
    _lotteryInfo = lotteryInfo;
    self.lotteryLabel.text = [NSString stringWithFormat:@"获得“%@”一辆",lotteryInfo];
}

- (void)setLotteryImageUrlStr:(NSString *)lotteryImageUrlStr {
    _lotteryImageUrlStr = lotteryImageUrlStr;
    [self.lotteryImageView yy_setImageWithURL:[NSURL URLWithString:lotteryImageUrlStr] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];
}

#pragma mark - cusfunc
-(BOOL)valiMobile:(NSString *)mobile {

    

    if (mobile.length != 11) {

        return NO;

    } else {

        /**

         * 移动号段正则表达式

         */

        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(17[0-9])|(18[2-4,7-8]))\\d{8}$";

        /**

         * 联通号段正则表达式

         */

        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[0-9])|(18[5,6]))\\d{8}$";

        /**

         * 电信号段正则表达式

         */

        NSString *CT_NUM = @"^((133)|(153)|(17[0-9])|(18[0,1,9]))\\d{8}$";

        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];

        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];

        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];

        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];

        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];

        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];

        

        if (isMatch1 || isMatch2 || isMatch3) {

            return YES;

        } else {

            return NO;

        }

    }

    

    return NO;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
