//
//  ForgetPsdViewController.h
//  wspace
//
//  Created by Hand02 on 2019/2/14.
//  Copyright © 2019 Hand02. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForgetPsdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UITextField *psdTextField;
@property (weak, nonatomic) IBOutlet UITextField *sPsdTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkPsdBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkSPsdBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

NS_ASSUME_NONNULL_END
