//
//  ForgetPsdViewController.m
//  wspace
//
//  Created by Hand02 on 2019/2/14.
//  Copyright © 2019 Hand02. All rights reserved.
//

#import "ForgetPsdViewController.h"
#import "Common.h"
#import "HDAFNetWork.h"
#import "MBProgressHUD+JDragon.h"

@interface ForgetPsdViewController ()<UITextFieldDelegate>{
    Boolean openPsd;
    Boolean opensPsd;
    __block int timeout;
}

@end

@implementation ForgetPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    openPsd = NO;
    opensPsd = NO;
    self.title = @"找回密码";
    _emailTextField.delegate = self;
    //设置获取验证码的边框
    _getVerifyBtn.layer.cornerRadius = 15;
    _getVerifyBtn.layer.borderColor =  [[Common colorWithHexString:@"aeaeae"] CGColor];
    _getVerifyBtn.layer.borderWidth = 1;
    
    //点击获取验证码/Users/hand02/Desktop/wspace2.18/wspace.xcodeproj
    [_getVerifyBtn addTarget:self action:@selector(getVerifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //点击提交按钮
    //添加点击事件
    [_commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //设置提交按钮的样式
    _commitBtn.layer.cornerRadius = 23;
    _commitBtn.clipsToBounds = YES;
    _commitBtn.backgroundColor = [Common colorWithHexString:MAINYELLOWCOLOR];
    
    
    // Do any additional setup after loading the view.
}

//结束编辑的时候调用
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(![Common isValidateEmail:_emailTextField.text]){
     [MBProgressHUD showTipMessageInWindow:@"邮箱格式错误！" yOffset:SCREENHEIGHT/2-300 color:nil];
    }
}

//点击提交按钮
-(void)commitBtnClick{
    if([_emailTextField.text isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"请输入邮箱账号！" yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if(![Common isValidateEmail:_emailTextField.text]){
        [MBProgressHUD showTipMessageInWindow:@"邮箱格式错误！" yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if([_verifyTextField.text isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"请填写验证码！" yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if(_verifyTextField.text.length != 6){
        [MBProgressHUD showTipMessageInWindow:@"验证码为6位！" yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if([_psdTextField.text isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"新密码不能为空！" yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if(_psdTextField.text.length>16||_psdTextField.text.length<8){
        [MBProgressHUD showTipMessageInWindow:@"密码应为8-16位！" yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if([_sPsdTextField.text isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"确认密码不能为空！" yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if(_psdTextField.text!=_sPsdTextField.text){
        [MBProgressHUD showTipMessageInWindow:@"两次输入的密码不一致！" yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    NSLog(@"您可以登录了");
    //接口参数
    NSMutableDictionary *paramsDic = [NSMutableDictionary new];//email code pwd pwd2  不需要token
    [paramsDic setObject:_emailTextField.text forKey:@"email"];
    [paramsDic setObject:_verifyTextField.text forKey:@"code"];
    [paramsDic setObject:_psdTextField.text forKey:@"pwd"];
    [paramsDic setObject:_sPsdTextField.text forKey:@"pwd2"];
    NSString *url = [NSString stringWithFormat:@"%@Login/changePassword",HOSTURL];
    [HDAFNetWork POST:url params:paramsDic success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD showTipMessageInWindow:response[@"msg"] timer:2 yOffset:SCREENHEIGHT/2-300 color:nil];
        
    }fail:^(NSURLSessionDataTask *task, NSError *error) {
        //            [MBProgressHUD hideHUD];
    }];
    
}

/// 回收键盘 将两个textField作为第一反应者
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTextField resignFirstResponder];
    [self.verifyTextField resignFirstResponder];
    [self.sPsdTextField resignFirstResponder];
    [self.psdTextField resignFirstResponder];
}

///点击获取验证码
-(void)getVerifyBtnClick{
    if([_emailTextField.text isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"请填写邮箱！" yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if(![Common isValidateEmail:_emailTextField.text]){
        [MBProgressHUD showTipMessageInWindow:@"邮箱格式错误！" yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    [self startTime];
    //接口参数
    NSMutableDictionary *paramsDic = [NSMutableDictionary new];
    [paramsDic setObject:_emailTextField.text forKey:@"email"];
    NSString *url = [NSString stringWithFormat:@"%@Login/sendCode",HOSTURL];
    [HDAFNetWork POST:url params:paramsDic success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD showTipMessageInWindow:@"已发送验证码" timer:2 yOffset:SCREENHEIGHT/2-300 color:nil];

    }fail:^(NSURLSessionDataTask *task, NSError *error) {
        //            [MBProgressHUD hideHUD];
    }];
}



///开始计时
-(void)startTime{
    
    timeout=89; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(self->timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self->_getVerifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self->_getVerifyBtn.userInteractionEnabled = YES;
                //添加点击事件
                [self.getVerifyBtn addTarget:self action:@selector(getVerifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = self->timeout % 90;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self->_getVerifyBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                self->_getVerifyBtn.userInteractionEnabled = NO;
            });
            self->timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

/// 点击小眼睛 密码的明暗显示
- (IBAction)clickCheckPsd:(id)sender {
    if(!openPsd){
        _psdTextField.secureTextEntry = NO;
    }else{
        _psdTextField.secureTextEntry = YES;
    }
    openPsd = !openPsd;
}
- (IBAction)clickCheckSPsd:(id)sender {
    if(!opensPsd){
        _sPsdTextField.secureTextEntry = NO;
    }else{
        _sPsdTextField.secureTextEntry = YES;
    }
    opensPsd = !opensPsd;
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
