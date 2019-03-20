//
//  Common.h
//  zdsApp
//
//  Created by 汉德 on 2017/2/17.
//  Copyright © 2017年 中电四公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCREENWIDTH ([UIScreen  mainScreen].bounds.size.width)
#define SCREENHEIGHT ([UIScreen  mainScreen].bounds.size.height)
#define IS_IPHONE_5_SCREEN [[UIScreen mainScreen] bounds].size.width == 320.0f//判断是否为iPhone4、5
#define IS_IPHONE_6_SCREEN [[UIScreen mainScreen] bounds].size.width == 375.0f//判断是否为iPhone6、7
#define IS_IPHONE_6P_SCREEN [[UIScreen mainScreen] bounds].size.width == 414.0f//判断是否为iPhone6P、7P

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度

#define kNavBarHeight 44.0 //导航栏高度

#define kTopHeight (kStatusBarHeight + kNavBarHeight) //导航栏高 + 状态栏高

#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20.1?83.0:49.0) //tabBar高

#define kTabBarArcHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20.1?34.0:0.0) //底部圆弧高

//替换 64px →kTopHeight

//替换 49px →kTabBarHeight

//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX
//#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IOS_11  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.f)
#define IS_IPHONE_X (IS_IOS_11 && IS_IPHONE && (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 375 && MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 812))

//#define MarginTopHeight (IS_IPHONE_Xs_Max || IS_IPHONE_Xr ? 88:64)
#define MarginTopHeight (IS_IPHONE_X ? 88:64)

#define ISIOS9 ([[[UIDevice currentDevice] systemVersion] intValue]==9)
#define ISIOS10 ([[[UIDevice currentDevice] systemVersion] intValue]==10)
#define ISIOS11 ([[[UIDevice currentDevice] systemVersion] intValue]==11)


#define TOKEN ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]==nil)?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]

#define UID ([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]==nil)?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]

#define USERNAME ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]==nil)?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]

#define ORGID ([[NSUserDefaults standardUserDefaults] objectForKey:@"organization_id"]==nil)?@"0":[[NSUserDefaults standardUserDefaults] objectForKey:@"organization_id"]

#define PHONE ([[NSUserDefaults standardUserDefaults] objectForKey:@"contact_num"]==nil)?@"0":[[NSUserDefaults standardUserDefaults] objectForKey:@"contact_num"]

#define EMAIL ([[NSUserDefaults standardUserDefaults] objectForKey:@"email"]==nil)?@"0":[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]

#define ISADMIN ([[NSUserDefaults standardUserDefaults] objectForKey:@"isAdmin"]==nil)?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"isAdmin"]
#define COMPANYNAME ([[NSUserDefaults standardUserDefaults] objectForKey:@"companyName"]==nil)?@"0":[[NSUserDefaults standardUserDefaults] objectForKey:@"companyName"]
//#define HOSTURL @"http://yxt.ccooddee.cn"
#define HOSTURL @"http://dac.ccooddee.cn/api_frontend/"

#define TBROWS 20 //tableview每页行数
#define TDCOLOR @"#333333"
#define TMCOLOR @"#949494"
#define TLCOLOR @"#999999"
#define BDCOLOR @"#eeeeee"
#define BLCOLOR @"#f1f1f1"
#define LINECOLOR @"#efefef"
#define PLACEHOLDERCOLOR @"#b9b9b9"

#define CellBGColor @"#f0f0f0"
#define CellLineColor @"#efefef"
#define TableBGColor @"#999999"
#define ControllBGColor @"#f0f0f0"
#define MAINCOLOR @"#212121"

#define MAINYELLOWCOLOR @"#d2b783"
#define MAINFONTCOLOR @"#4f4f4f"


#define MarginLR 16 //距离屏幕左右

#define BTITLEFONT 17 //PLUS标题字体大小
#define BSUBTITLEFONT 15 //PLUS副标题标题字体大小
#define BTIMEFONT 15 //PLUS时间字体大小
#define BSEARCHFONT 15 //PLUS搜索框字体大小

#define STITLEFONT 15 //非PLUS标题字体大小
#define SSUBTITLEFONT 14 //非PLUS副标题标题字体大小
#define STIMEFONT 14 //非PLUS时间字体大小
#define SSEARCHFONT 14 //非PLUS搜索框字体大小

#define BUTTONFONT 15 //按钮字体大小

//#define NAVICOLOR @"#29a1f7"

#define SHOWNONETWORKTIP [Common showNoNetWorkTip];
#define SHOWSERVERERRORTIP [Common showServerErrorTip];
#define APPDATA ((AppDelegate *)[UIApplication sharedApplication].delegate)
@interface Common : NSObject

//颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 *  获取tableViewCell的文字高度
 *
 *  @param size 计算前的文字区域
 *  @param font 字体
 *  @param text 文本
 *
 *  @return 计算后的文字区域大小
 */
+ (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font text:(NSString *)text;

//根据颜色返回图片
+(UIImage *) imageWithColor:(UIColor*)color;

// 将NSDictionary或NSArray转化为JSON串
+(NSString *)toJSONDataString:(id)theData;

//压缩图片
+(UIImage *)scaleImage:(UIImage *)img;

+(NSString*)get_uuid;

+(void)saveLocalData:(NSObject *)obj withKey:(NSString *)key;
+(NSMutableDictionary *)getLocalDataWithKey:(NSString *)key;
+(void)delLocalDataWithKey:(NSString *)key;

+(void)showNoNetWorkTip;

+(void)showServerErrorTip;

+(UIView *)getNoNetWorkView:(CGFloat)oy;

+(UIView *)getNoContentView:(CGFloat)oy;

+(UIView *)getNoNetWorkView;

+(UIView *)getNoContentView;

//判断是否为浮点形：
+(BOOL)isPureFloat:(NSString*)string;

//检测手机号格式
+ (BOOL)checkPhoneNum:(NSString *)phoneNum;

//AlertView无取消按钮
+ (void)showAlertViewWithoutCancelBtn:(NSString *)msg targetVC:(UIViewController *)vc;

//AlertView确定后返回上级
+ (void)showAlertViewPopVC:(NSString *)msg targetVC:(UIViewController *)vc;

//判断是否为整形：
+(BOOL)isPureInt:(NSString*)string;

+(NSString *)numberFormat:(NSString *)str;

+(BOOL)createDir:(NSString *)dirName;
+(NSString *)htmlEntityDecode:(NSString *)string;
+(void)drawShadow:(UIView *)view;
+(void)drawPickerShadow:(UIView *)view;
+(NSString*)getmd5WithString:(NSString *)string;

//通过获得秒数 转化为00:00:00
+(NSString *)getSFM:(NSString *)totalTime;
+(NSString *)getLongTime:(double)t;
+(NSString *)getShortTime:(double)t;
+(NSString *)getShortsTime:(double)t;
+(NSString *)getHourTime:(double)t;
+(NSString *)getTelTime:(double)t;

//点击图片变大效果
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview;

//再次点击图片缩小
+(void)hideImageView:(UITapGestureRecognizer *)tap;


/**
 *  @param contentImageview 图片所在的imageView
 */
+(void)ImageZoomWithImageView:(UIImageView *)contentImageview;
//  URL转UIImage
+(UIImage *) imageFromURLString: (NSString *) str;

+(void) setViewCornerTop:(UIView *)view left:(NSInteger)left right:(NSInteger)right;

+(void) setViewCornerBottom:(UIView *)view left:(NSInteger)left right:(NSInteger)right;

///获取当前的时间
+(NSString*)getCurrentTimes:(NSString *)formatterSrt;

///获取指定日期对应星期
+(NSString *)getWeekDayFordate:(NSTimeInterval)data nextDays:(int)days;

/// 得到当前时间N天前后的日期 传入正数 n天后   传入负数 N天前
+ (NSString *)getTimeAfterNowWithDay:(int)day formatter:(NSString *)formatterStr;

+ (CGSize) setLabelFontFix:(float )fontSize label:(UILabel *)label;

//检测邮箱格式
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 设置固定行间距文本
 
 @param lineSpace 行间距
 @param text 文本内容
 @param label 要设置的label
 */
+(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label;


/**
 *  改变图片的大小
 *
 *  @param img     需要改变的图片
 *  @param newsize 新图片的大小
 *
 *  @return 返回修改后的新图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;
@end
