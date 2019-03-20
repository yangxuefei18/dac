//
//  Common.m
//  zdsApp
//
//  Created by 汉德 on 2017/2/17.
//  Copyright © 2017年 中电四公司. All rights reserved.
//

#import "Common.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+JDragon.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Common
static CGRect oldframe;
//IOS中十六进制的颜色转换为UIColor
+ (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


//获取文字高度
+ (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font text:(NSString *)text;
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
}

//根据颜色返回图片
+ (UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 320.0f, 49.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// 将NSDictionary或NSArray转化为JSON串
+ (NSString *)toJSONDataString:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonDataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonDataString;
    }else{
        return nil;
    }
}

//压缩图片
+(UIImage *)scaleImage:(UIImage *)img{
    NSInteger iWidth = img.size.width;
    NSInteger iHeight = img.size.height;
    
    //压缩图片
    if (img.size.width>=img.size.height && img.size.width>640)
    {
        iWidth = 640;
        iHeight = img.size.height/img.size.width * 640;
    }
    
    if (img.size.height>img.size.width && img.size.height>640) {
        iHeight = 640;
        iWidth = img.size.width/img.size.height *640;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(iWidth, iHeight));
    [img drawInRect:CGRectMake(0,0,iWidth,iHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

+(NSString*)get_uuid{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

+(void)saveLocalData:(NSObject *)obj withKey:(NSString *)key {
    if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
        NSData *cacheData=[NSKeyedArchiver archivedDataWithRootObject:obj];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:cacheData forKey:key];
        [defaults synchronize];
    }
}

+(NSMutableDictionary *)getLocalDataWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:key];
    NSMutableDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dictionary;
}

+(void)delLocalDataWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

//判断是否为整形：
+(BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+(void)showNoNetWorkTip{
    [MBProgressHUD showTipMessageInWindow:@"请检查网络是否正常！"];
}

+(void)showServerErrorTip{
    [MBProgressHUD showTipMessageInWindow:@"服务器业务繁忙，请稍后重试！"];
}

+(UIView *)errorBackView:(NSString *)imgName message:(NSString *)msg offsetY:(CGFloat)oy{
    
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,viewWidth ,viewHeight )];
    
    CGFloat imgWidth = viewWidth/2;
    CGFloat imgHeight =imgWidth/1.677;
    CGFloat imgX = (viewWidth-imgWidth)/2;
    CGFloat imgY = (viewHeight-imgHeight-64-44)/2-30-oy;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, imgWidth, imgHeight)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgY+imgHeight, viewWidth, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = msg;
    label.textColor = [Common colorWithHexString:TLCOLOR];
    
    imgView.image = [UIImage imageNamed:imgName];
    
    [bView addSubview:label];
    [bView addSubview:imgView];
    bView.tag = 66666;
    return bView;
    
}

+(UIView *)getNoNetWorkView{
    return [Common errorBackView:@"neterror" message:@"啊哦，网络不太顺畅喔～" offsetY:0];
}

+(UIView *)getNoContentView{
    return [Common errorBackView:@"noinfor" message:@"啊哦，还没有相关信息哦～" offsetY:0];
}

+(UIView *)getNoNetWorkView:(CGFloat)oy{
    return [Common errorBackView:@"neterror" message:@"啊哦，网络不太顺畅喔～" offsetY:oy];
}

+(UIView *)getNoContentView:(CGFloat)oy{
    return [Common errorBackView:@"noinfor" message:@"啊哦，还没有相关信息哦～" offsetY:oy];
}

//检测手机号格式
+ (BOOL)checkPhoneNum:(NSString *)phoneNum
{
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"1[23456789]([0-9]){9}"];
    BOOL matched = [pred evaluateWithObject:phoneNum];
    
    return matched;
}

+(NSString *)numberFormat:(NSString *)str {
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *numberStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]];
    return numberStr;
    //return [numberStr substringFromIndex:1];
    
}

+(BOOL)createDir:(NSString *)dirName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [NSString stringWithFormat:@"%@/%@",documentsDirectory,dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if  (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {//先判断目录是否存在，不存在才创建
        BOOL res=[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        return res;
    } else return NO;
}

//将 &lt 等类似的字符转化为HTML中的“<”等
+ (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

+ (void)drawShadow:(UIView *)view{
    view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(5,5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    view.layer.shadowRadius = 3;//阴影半径，默认3
    view.clipsToBounds = NO;
}

+ (void)drawPickerShadow:(UIView *)view{
    view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(0,-3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.1;//阴影透明度，默认0
    view.layer.shadowRadius = 2;//阴影半径，默认3
    view.clipsToBounds = NO;
}

+ (NSString*)getmd5WithString:(NSString *)string
{
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

+(NSString *)getLongTime:(double)t{
    // 把时间戳转化成时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    return timeStr;
}

+(NSString *)getShortTime:(double)t{
    // 把时间戳转化成时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    return timeStr;
}

+(NSString *)getShortsTime:(double)t{
    // 把时间戳转化成时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy年MM月dd日"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    return timeStr;
}


+(NSString *)getHourTime:(double)t{
    // 把时间戳转化成时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"HH:mm:ss"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    return timeStr;
}

+(NSString *)getTelTime:(double)t{
    // 把时间戳转化成时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    return timeStr;
}

+(NSString *)getSFM:(NSString *)totalTime{
    //将秒数 转换为时分秒
    NSInteger seconds = [totalTime integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    NSString *format_time;
    if(seconds<3600){
        //format of time
        format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    }else{
        //format of time
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];       
    }
     return format_time;
}

/**
 *  浏览大图
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview{
    
   
        //当前imageview的图片
        UIImage *image = currentImageview.image;
        //当前视图
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //背景
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
        oldframe = [currentImageview convertRect:currentImageview.bounds toView:window];
        [backgroundView setBackgroundColor:[UIColor blackColor]];
        //此时视图不会显示
        [backgroundView setAlpha:0];
        //将所展示的imageView重新绘制在Window中
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
        [imageView setImage:image];
        [imageView setTag:0];
        [backgroundView addSubview:imageView];
        //将原始视图添加到背景视图中
        [window addSubview:backgroundView];
        //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
        [backgroundView addGestureRecognizer:tapGestureRecognizer];
        //动画放大所展示的ImageView
    
        [UIView animateWithDuration:0.4 animations:^{
         @try{
            CGFloat y,width,height;
            y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
            //宽度为屏幕宽度
            width = [UIScreen mainScreen].bounds.size.width;
            //高度 根据图片宽高比设置
            height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
            [imageView setFrame:CGRectMake(0, y, width, height)];
        }@catch (NSException * e) {
            
        }
            //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
        } completion:^(BOOL finished) {
            
        }];
   
    
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:1];
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}
//  URL转UIImage
+(UIImage *) imageFromURLString: (NSString *) str{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
}

+(void) setViewCornerTop:(UIView *)view left:(NSInteger)left right:(NSInteger)right{
    //得到view的遮罩路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(left,right)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}


+(void) setViewCornerBottom:(UIView *)view left:(NSInteger)left right:(NSInteger)right{
    //得到view的遮罩路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(left,right)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

//获取当前的时间
+(NSString*)getCurrentTimes:(NSString *)formatterSrt{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:formatterSrt];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
        
    return currentTimeString;
    
}

///获取指定日期对应星期
+(NSString *)getWeekDayFordate:(NSTimeInterval)data nextDays:(int)days{ // 5
    //不可变字典一样可以字面常量初始化,key在前,value在后.
    NSDictionary *dic=@{@"1":@"周日",@"2":@"周一",@"3":@"周二",@"4":@"周三",@"5":@"周四",@"6":@"周五",@"7":@"周六",};
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];

    NSInteger res = days + components.weekday;
    res = res > 7? res % 7 :res;
    res = res == 0 ? 7:res;
    NSString *weekStr = dic[[NSString stringWithFormat:@"%ld",res]];//[weekday objectAtIndex:days];//3
    return weekStr;
}

/**
 得到当前时间N天前后的日期
 @param day   传入正数 n天后   传入负数 N天前
 @return return value description
 */
+ (NSString *)getTimeAfterNowWithDay:(int)day formatter:(NSString *)formatterStr
{
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    
    if(day!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay*day ];
        
    }
    else
    {
        theDate = nowDate;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:formatterStr];
    NSString *the_date_str = [formatter stringFromDate:theDate];
    return the_date_str;
}


+ (CGSize) setLabelFontFix:(float )fontSize label:(UILabel *)label{
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:fontSize]];
    CGSize maximumLabelSize = CGSizeMake(9999, 9999);//labelsize的最大值
    //关键语句
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, expectSize.width, expectSize.height);
    return expectSize;
}

//利用正则表达式验证邮箱格式


+(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}


/**
 设置固定行间距文本
 
 @param lineSpace 行间距
 @param text 文本内容
 @param label 要设置的label
 */
+(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}

/**
 *  改变图片的大小
 *
 *  @param img     需要改变的图片
 *  @param newsize 新图片的大小
 *
 *  @return 返回修改后的新图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
