//
//  LoginViewController.h
//  wspace
//
//  Created by Hand02 on 2019/2/12.
//  Copyright © 2019 Hand02. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *psdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnWidth;
@property (weak, nonatomic) IBOutlet UIButton *privacyBtn;

@end

NS_ASSUME_NONNULL_END
