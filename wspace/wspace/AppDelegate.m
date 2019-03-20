//
//  AppDelegate.m
//  wspace
//
//  Created by 汉德 on 2019/2/12.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
#import "IQKeyboardManager.h"
#import "LoginNaviViewController.h"
#import "TabbarViewController.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <UShareUI/UShareUI.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // UMConfigure 通用设置，请参考SDKs集成做统一初始化。
    // 以下仅列出U-Share初始化部分
    // U-Share 平台设置
    [UMConfigure initWithAppkey:@"5afd2c25a40fa3778b0000de" channel:@"App Store"];
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    // Override point for customization after application launch.
    
    
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:14.0f]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离

    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Login"] isEqualToString:@"Y"]){
        //主页
        [self enterMainView];
    }else{
        //登录
        [self enterLoginView];
    }
    
    return YES;
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx7eb826ec73b692c1" appSecret:@"32b5b4164727bf01faa6b96ea68a4813" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
   
    /* 设置Twitter的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
    /* 设置Facebook的appKey和UrlString */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"506027402887373"  appSecret:nil redirectURL:@"http://www.umeng.com/social"];
   
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)enterMainView{
    
    //NavigationBar背景颜色
    [[UINavigationBar appearance]  setBackgroundImage:[Common imageWithColor:[Common colorWithHexString:@"212121"]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
    //设置全局状态栏字体颜色为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //设置navigationBar返回按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //设置navigationBar字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置tabBar背景颜色
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:@"Login"];
   
    UIStoryboard * storyBoard = [UIStoryboard
                                 storyboardWithName:@"Main" bundle:nil];
    TabbarViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"TabbarViewController"];
    self.window.rootViewController = vc;
}

-(void)enterLoginView{
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //退出登录
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//设置状态栏字体颜色为黑色
    UIStoryboard * storyBoard = [UIStoryboard
                                 storyboardWithName:@"Login" bundle:nil];
    LoginNaviViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"LoginNaviViewController"];
    self.window.rootViewController = vc;
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
