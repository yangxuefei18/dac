//
//  OpendoorViewController.m
//  wspace
//
//  Created by 汉德 on 2019/2/19.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "OpendoorViewController.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import <CoreImage/CoreImage.h>
#import "DrawCyclesView.h"

@interface OpendoorViewController (){
    UIImageView *imageView;
    NSTimer *aTimer;
}

@end

@implementation OpendoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
   
}

-(void)initView{
    self.view.backgroundColor = [Common colorWithHexString:@"f0f0f0"];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(16, 115, SCREENWIDTH - 32, (SCREENWIDTH - 32)/383*447)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view  addSubview:whiteView];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 18, whiteView.frame.size.width-32, whiteView.frame.size.width-32)];
    imageView.image = [self createNewImageWithBg:[self getCodeImage] icon:[UIImage imageNamed:@"lllogo"]];//[self getCodeImage];
    [whiteView addSubview:imageView];
    [self startScroll];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height+8, whiteView.frame.size.width, 24)];
    lable.text = @"扫一扫上面的二维码图案";
    lable.font = [UIFont systemFontOfSize:12.0f];
    lable.textColor = [Common colorWithHexString:TMCOLOR];
    lable.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:lable];
    
}

/// 启动定时器，定时更新二维码
-(void)startScroll{
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    aTimer = timer;
    
}

///更换图片
-(void)changeImage{
    imageView.image = [self createNewImageWithBg:[self getCodeImage] icon:[UIImage imageNamed:@"lllogo"]];
}


/// 获取二维码图片
- (UIImage *)getCodeImage {
    
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复滤镜的默认属性
    [filter setDefaults];
    
    // 3.二维码信息
    NSString *str = [self getCodeData]; // 展示一串文字
//        NSString *str = @"http://www.baidu.com"; // 直接打开网页
    
    // 4.将字符串转成二进制数据
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 5.通过KVC设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 6.获取滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 7.将CIImage转成UIImage
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    
    // 8.二维码中心加小头像
//    UIImage *sImage = [UIImage imageNamed:@"gglogo"];
//    sImage = [self imageWithBorderWidth:20 borderColor:[UIColor redColor] image:sImage];
//    image = [self createNewImageWithBg:image icon: sImage];
    
    
    
    // 9.展示二维码
    return image;
}


/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

///  二维码中心加小图 生成一张新的图片
///
///  @param bgImage 图片的背景
///  @param icon    图片的图标
- (UIImage *)createNewImageWithBg:(UIImage *)bgImage icon:(UIImage *)icon{
    
    
    // 1.开启图片上下文
    UIGraphicsBeginImageContext(bgImage.size);
    
    // 2.绘制背景
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    // 3.绘制图标
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat iconW = 46;
    CGFloat iconH = 46;
    CGFloat iconX = (bgImage.size.width - iconW) * 0.5;
    CGFloat iconY = (bgImage.size.height - iconH) * 0.5;
//    CGContextDrawImage(context, CGRectMake(iconX+1, iconY+1, iconW-2, iconH-2), icon.CGImage);
    [icon drawInRect:CGRectMake(iconX+1, iconY+1, iconW-2, iconH-2)];
    
    // 4.在头像上绘制边框
    /*画圆角矩形*/
    CGContextSetLineWidth(context, 3.0);//线的宽度
    UIColor *aColor = [UIColor whiteColor];
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
    aColor = [UIColor colorWithRed:1/123 green:1/23 blue:1/233 alpha:0];//自定义透明颜色
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    float fx = iconX+iconW;
    float fy = iconY+iconH;
    CGContextMoveToPoint(context, fx, fy-iconW);  // 开始坐标右边开始 0
    CGContextAddArcToPoint(context, fx, fy, fx-iconW, fy, 6);  // 右下角角度  1 2
    CGContextAddArcToPoint(context, fx-iconW, fy, fx-iconW, fy-iconW, 6); // 左下角角度 3 4
    CGContextAddArcToPoint(context, fx-iconW, fy-iconW, fx, fy-iconW, 6); // 左上角 5 6
    CGContextAddArcToPoint(context, fx, fy-iconW, fx, fy-5, 6); // 右上角 7 0
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径

    
    // 5.取出绘制好的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    // 7.返回生成好得图片
    return newImage;
}

-(NSString *)getCodeData{
    NSString *res = @"";
    NSInteger recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    res = [NSString stringWithFormat:@"%@|%ld%@",@"uid",recordTime,@"Wspace" ];
    NSLog(@"%@",res);
    res = [self base64EncodeString:res];
    NSLog(@"%@",res);
    return res;
}

//Base64编码
-(NSString *)base64EncodeString:(NSString *)string{
    //1.先把字符串转换为二进制数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //2.对二进制数据进行base64编码，返回编码后的字符串
    //这是苹果已经给我们提供的方法
    NSString *str = [data base64EncodedStringWithOptions:0];
    return str;
}
-(void)viewWillDisappear:(BOOL)animated{
    [aTimer invalidate];
    aTimer = nil;
}
//- (UIImage *)imageWithBorderWidth:(CGFloat)borderW borderColor:(UIColor *)color image:(UIImage *)image{
//
//    //3.开启图片上下文.
//    CGSize size = CGSizeMake(image.size.width + 2 * borderW, image.size.height + 2 * borderW);
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    //4.先描述一个大圆,设为填充
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
//    //设置边框的颜色
//    [color set];
//    [path fill];
//    //5.再添加一个小圆,把小圆设裁剪区域
//
//    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderW, borderW, image.size.width, image.size.height)];
//    [path addClip];
//
//    //6.把图片给绘制上下文.
//    [image drawInRect:CGRectMake(borderW, borderW, image.size.width, image.size.height)];
//    //7.生成一张新的图片
//
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    //8.关闭上下文.
//    UIGraphicsEndImageContext();
//
//    return newImage;
//
//}
@end
