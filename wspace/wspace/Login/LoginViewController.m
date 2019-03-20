//
//  LoginViewController.m
//  wspace
//
//  Created by Hand02 on 2019/2/12.
//  Copyright © 2019 Hand02. All rights reserved.
//

#import "LoginViewController.h"
#import "Common.h"
#import "MBProgressHUD+JDragon.h"
#import "HDAFNetWork.h"
#import "AppDelegate.h"
#import "ForgetPsdViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>{
    Boolean open;
    Boolean agree;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    open = NO;
    agree = NO;
    _emailTextField.delegate = self;
    //登录的按钮加上圆角
    _loginBtn.layer.cornerRadius = 23;
    _loginBtn.clipsToBounds = YES;
    _loginBtnWidth.constant = 0.8*SCREENWIDTH;
    _errorLabel.hidden=YES;
    
    
    
    [self.agreeBtn setImage:[UIImage imageNamed:@"noAgree"] forState:UIControlStateNormal];
    
    //给忘记密码添加点击事件
    //添加点击事件
    [_forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //给服务按钮的字体加上下划线
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"用户服务协议"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [_serviceBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    //给隐私按钮的字体加上下划线
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"用户隐私协议"];
    NSRange strRange1 = {0,[str1 length]};
    [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
    [_privacyBtn setAttributedTitle:str1 forState:UIControlStateNormal];
    
}

-(void)forgetBtnClick{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    ForgetPsdViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ForgetPsdViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

//页面将要出现 隐藏标题栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

//页面将要消失 显示标题栏
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

/// 点击小眼睛 密码的明暗显示
- (IBAction)clickCheckPsd:(id)sender {
    if(!open){
      _psdTextField.secureTextEntry = NO;
    }else{
      _psdTextField.secureTextEntry = YES;
    }
    open = !open;
}

/// 点击同意协议按钮
- (IBAction)clickCheckagree:(id)sender {
    if(!agree){
        [self.agreeBtn setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
    }else{
        [self.agreeBtn setImage:[UIImage imageNamed:@"noAgree"] forState:UIControlStateNormal];
    }
    agree = !agree;
}

/// 点击登录按钮
- (IBAction)clickToLogin:(id)sender {
    if ([self.emailTextField.text isEqualToString:@""] || [self.psdTextField.text isEqualToString:@""]) {
        [MBProgressHUD showTipMessageInWindow:@"用户名和密码不能为空！" timer:1 yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if(!agree){
        [MBProgressHUD showTipMessageInWindow:@"请同意用户服务协议！" timer:1 yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    NSMutableDictionary *paramsDic = [NSMutableDictionary new];
    NSString *url = [NSString stringWithFormat:@"%@Login/login",HOSTURL];
    [paramsDic setValue:self.emailTextField.text forKey:@"email"];
    [paramsDic setValue:self.psdTextField.text forKey:@"password"];
    [HDAFNetWork GET:url params:paramsDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] isEqualToString:@"1"]) {
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][0][@"token"] forKey:@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][0][@"user_id"] forKey:@"uid"];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][0][@"name"] forKey:@"userName"];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][0][@"email"] forKey:@"email"];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][0][@"organization_id"] forKey:@"organization_id"];
                
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][0][@"contact_num"] forKey:@"contact_num"];
                
                NSString *a = [ [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"permission"]] isEqualToString: @"2"] ? @"1":@"0";
                [[NSUserDefaults standardUserDefaults] setObject:a forKey:@"isAdmin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [((AppDelegate *)[UIApplication sharedApplication].delegate) enterMainView];
            }
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}

/// 回收键盘 将两个textField作为第一反应者
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTextField resignFirstResponder];
    [self.psdTextField resignFirstResponder];
}

//结束编辑的时候调用
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"aaaaa");
    NSLog(@"%@",_emailTextField.text);
    if(![Common isValidateEmail:_emailTextField.text]){
//        [MBProgressHUD showTipMessageInWindow:@"邮箱格式错误！" yOffset:SCREENHEIGHT/2-100 color:nil];
        _errorLabel.hidden = NO;
        _loginBtn.backgroundColor = [Common colorWithHexString:MAINCOLOR];
        _loginBtn.enabled = NO;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _errorLabel.hidden = YES;
    _loginBtn.backgroundColor = [Common colorWithHexString:MAINYELLOWCOLOR];
    _loginBtn.enabled = YES;
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
