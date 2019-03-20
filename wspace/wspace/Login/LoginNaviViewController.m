//
//  LoginNaviViewController.m
//  yixiuti
//
//  Created by 汉德 on 2017/11/20.
//  Copyright © 2017年 易修梯. All rights reserved.
//

#import "LoginNaviViewController.h"
#import "Common.h"

@interface LoginNaviViewController ()

@end

@implementation LoginNaviViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    //NavigationBar背景颜色
    [[UINavigationBar appearance]  setBackgroundImage:[Common imageWithColor:[Common colorWithHexString:@"ffffff"]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //设置navigationBar阴影（去掉黑线）
//    [UINavigationBar appearance].shadowImage = [[UIImage alloc] init];
//    //设置navigationBar返回按钮颜色
    [[UINavigationBar appearance] setTintColor:[Common colorWithHexString:TDCOLOR]];
 //设置navigationBar字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[Common colorWithHexString:@"4f4f4f"]}];
    
    
    
    //设置状态栏颜色为默认黑色
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
