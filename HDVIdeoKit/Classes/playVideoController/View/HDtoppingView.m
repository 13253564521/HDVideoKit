//
//  HDtoppingView.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/15.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDtoppingView.h"
#import "Macro.h"

@interface HDtoppingView()<UITextFieldDelegate>
@property(nonatomic , strong)UITextField *textfield;
//@property(nonatomic , strong)UIButton *butt;

@end
@implementation HDtoppingView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        
        
//        self.butt = [[UIButton alloc]init];
//        self.butt.backgroundColor = UkeColorHex(0x344FFE);
//        [self.butt setTitle:@"发送" forState:0];
//        [self.butt setTitleColor:[UIColor whiteColor] forState:0];
//        [self.butt addTarget:self action:@selector(fasongbutt) forControlEvents:UIControlEventTouchUpInside];
//        self.butt.layer.cornerRadius = 13;
//        self.butt.layer.masksToBounds = YES;
//        [self addSubview:self.butt];
        
        self.textfield = [[UITextField alloc]init];
        self.textfield.font = [UIFont systemFontOfSize:12];
        self.textfield.textColor = [UIColor whiteColor];
        self.textfield.backgroundColor = RGBA(255, 255, 255, 0.08);
        self.textfield.borderStyle = UITextBorderStyleNone;
        self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textfield.keyboardType = UIKeyboardTypeDefault;
        self.textfield.inputAccessoryView = [[UIView alloc]init];
        self.textfield.returnKeyType = UIReturnKeySend;
        self.textfield.delegate = self;
        self.textfield.leftViewMode = UITextFieldViewModeAlways;
        self.textfield.layer.cornerRadius = 10;
        self.textfield.layer.masksToBounds = YES;

        NSString *holderText = @"写评论...";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                                value:RGBA(255, 255, 255, 0.5)
                                range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, holderText.length)];
        self.textfield.attributedPlaceholder = placeholder;

        
        UIView *textLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:HDBundleImage(@"video/icon_bicolor_edit")]];
        leftImageView.contentMode  = UIViewContentModeScaleAspectFit;
        leftImageView.frame = CGRectMake(12, 0, leftImageView.image.size.width, textLeftView.frame.size.height);
        [textLeftView addSubview:leftImageView];
        self.textfield.leftView = textLeftView;

        [self addSubview:self.textfield];
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{

    NSLog(@"点击了发送");
    if (self.textfield.text.length > 0) {
        if (self.sendBtnBlock) {
            if (self.textfield.text.length > 50) {
                [SVProgressHUD showErrorWithStatus:@"最多输入50字"];
            }else {
                self.sendBtnBlock(self.textfield.text.copy);
                self.textfield.text = @"";
            }
            
        }
    }
    return YES;

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.textfield) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (self.textfield.text.length >= 50) {
            self.textfield.text = [textField.text substringToIndex:50];
            return NO;
        }
    }
    return YES;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.textfield.frame = CGRectMake(16, 12, self.frame.size.width - 16 * 2 , 32);
}


- (void)uke_resignFirstResponder {
    @try {
        if (self.textfield.isFirstResponder == NO) {
            return;
        }
        [self.textfield resignFirstResponder];
    } @catch (NSException *exception) {} @finally {}
}

- (void)uke_becomeFirstResponder {
    @try {
        if (self.textfield.isFirstResponder) {
            return;
        }
        [self.textfield becomeFirstResponder];
    } @catch (NSException *exception) {} @finally {}
}
@end
