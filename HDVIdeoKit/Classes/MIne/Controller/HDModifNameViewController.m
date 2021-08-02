//
//  HDModifNameViewController.m
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/5.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//修改昵称

#import "HDModifNameViewController.h"
#import "Macro.h"
#import "UKNetworkHelper.h"
#import "UKRequestURLPath.h"
#import "LHDAFNetworking.h"
#import "HDUkeInfoCenter.h"
#import "HDUkeInfoCenter.h"
@interface HDModifNameViewController ()<UITextFieldDelegate>
/** textField */
@property(nonatomic,strong) UITextField *searchtextField;
/** 字数提示 */
@property(nonatomic,strong) UILabel *textCountLabel;
/** 提交按钮 */
@property(nonatomic,strong) UIButton *submitButton;
/** 提示图 */
@property(nonatomic,strong) UIImageView *notiImageView;
/** 提示 */
@property(nonatomic,strong) UILabel *hintLabel;

@end

@implementation HDModifNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
}
- (void)initSubViews {
    CGFloat leftM = 20;
    CGFloat topM = 25;
    CGFloat textFieldW = self.view.frame.size.width - leftM * 2 ;
    CGFloat textFieldH = 44;

    //搜索框
    self.searchtextField = [[UITextField alloc]initWithFrame:CGRectMake(leftM, topM , textFieldW, textFieldH)];
    self.searchtextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[HDUkeInfoCenter sharedCenter].userModel.nickName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.searchtextField.returnKeyType = UIReturnKeyDone;
    self.searchtextField.borderStyle = UITextBorderStyleNone;
    self.searchtextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchtextField.backgroundColor = RGBA(237, 237, 237, 1);
    self.searchtextField.layer.cornerRadius = 4;
    self.searchtextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, leftM, textFieldH)];
    self.searchtextField.delegate = self;
    [self.searchtextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.searchtextField];
    
    CGFloat textCountLabelTM = 10 ;
    CGFloat textCountLabelH = 15 ;
    self.textCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftM * 2, CGRectGetMaxY(self.searchtextField.frame) + textCountLabelTM, self.searchtextField.frame.size.width - leftM * 4, textCountLabelH)];
    self.textCountLabel.font = [UIFont systemFontOfSize:15];
    self.textCountLabel.textColor = RGBA(102, 102, 102, 1);
    self.textCountLabel.text = @"0/20";
    [self.view addSubview:self.textCountLabel];
    
    CGFloat submitButtonTM = 15.5;
    CGFloat buttonH = 44;
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.frame = CGRectMake(leftM, CGRectGetMaxY(self.textCountLabel.frame) + submitButtonTM, self.view.frame.size.width - leftM * 2 , buttonH);
    [self.submitButton setBackgroundColor: RGBA(116, 156, 255, 1)];
    self.submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.submitButton.layer.cornerRadius = 4;
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    
    self.notiImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:HDBundleImage(@"mine/icon_reminder")]];
    self.notiImageView.frame = CGRectMake(self.submitButton.frame.origin.x + 2.5, CGRectGetMaxY(self.submitButton.frame) + textCountLabelTM, self.notiImageView.image.size.width, self.notiImageView.image.size.height);
    [self.view addSubview:self.notiImageView];
    
    self.hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.notiImageView.frame), self.notiImageView.frame.origin.y, self.submitButton.frame.size.width, self.notiImageView.image.size.height)];
    self.hintLabel.textColor = RGBA(102, 102, 102, 1);
    self.hintLabel.font = [UIFont systemFontOfSize:11];
    self.hintLabel.text = @"该昵称仅显示在短视频功能内，解放行APP原有用户名称不变";
    [self.view addSubview:self.hintLabel];
    
}

#pragma mark - buttonClick
- (void)submitButtonAction {

     LHDAFHTTPSessionManager *session = [LHDAFHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", nil];
        //post 发送json格式数据的时候加上这两句。
        session.requestSerializer = [AFJSONRequestSerializer serializer];
        session.responseSerializer = [AFJSONResponseSerializer serializer];
        session.requestSerializer.timeoutInterval = 15;
 
        NSString * requestUrl  = [NSString stringWithFormat:@"%@%@",[HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL,UKURL_GET_APP_UPDATE_gengxinname];

    NSDictionary *dic = @{@"value":self.searchtextField.text};

    [SVProgressHUD show];
    [[session PUT:requestUrl parameters:dic headers:@{@"Authorization":[HDUkeInfoCenter sharedCenter].userModel.token} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [HDUkeInfoCenter sharedCenter].userModel.nickName = self.searchtextField.text;
            [self.delegate nameScurre];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"失败"];

    }]resume];
}


 - (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    if (textField.text.length > 20)  // MAXLENGTH为最大字数
    {
        self.searchtextField.text = [self.searchtextField.text substringToIndex:20];
        //超出限制字数时所要做的事
    }else{
        self.textCountLabel.text = [NSString stringWithFormat:@"%lu/20",(unsigned long)self.searchtextField.text.length];
    }
}
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
   
    return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    NSLog(@"%@",string);
 
    
    return YES;
}

- (int)convertToInt:(NSString *)strtemp//判断中英混合的的字符串长度
{
    int strlength = 0;
    for (int i=0; i< [strtemp length]; i++) {
        int a = [strtemp characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) { //判断是否为中文
            strlength += 2;
        }
    }
    return strlength;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
