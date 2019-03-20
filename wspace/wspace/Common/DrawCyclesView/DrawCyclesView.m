//
//  DrawCyclesView.m
//  wspace
//
//  Created by 汉德 on 2019/2/20.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "DrawCyclesView.h"

#define kBorderWith 4

#define PI 3.14159265358979323846
@implementation DrawCyclesView

- (void)drawRect:(CGRect)rect {
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*写文字*/
    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
    UIFont  *font = [UIFont boldSystemFontOfSize:15.0];//设置
   
   
    //画大圆并填充颜
    UIColor*aColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];//白色
    CGContextSetLineWidth(context, 3.0);//线的宽度
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    /*画圆角矩形*/
    float fw = 180;
    float fh = 280;
    
    CGContextMoveToPoint(context, 180, 260);  // 开始坐标右边开始  p0
    //                              p0 --> p1 向下画 20
    
    CGContextAddArcToPoint(context, 180, 280, 160, 280, 4);  // 右下角 p1 --> p2  向左画 20
    //                              p2 --> p3 向左画 40
    
    CGContextAddArcToPoint(context, 120, 280, 120, 260, 4); // 左下角 p3 --> p4  向上画 20
    //                              p4 --> p5 向上画 10
    
    CGContextAddArcToPoint(context, 120, 250, 160, 250, 4); // 左上角 p5 --> p6  向右画 40
    //                              p6 --> p7 向右画 20
    
    CGContextAddArcToPoint(context, 180, 250, 180, 260, 4); // 右上角 p7 --> p8  向下画 10
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    
    /*图片*/
    UIImage *image = [UIImage imageNamed:@"gglogo"];
    [image drawInRect:CGRectMake(60, 340, 20, 20)];//在坐标中画出图片
//        [image drawAtPoint:CGPointMake(100, 340)];//保持图片大小在point点开始画图片，可以把注释去掉看看
    CGContextDrawImage(context, CGRectMake(100, 340, 20, 20), image.CGImage);//使用这个使图片上下颠倒了，参考http://blog.csdn.net/koupoo/article/details/8670024
    
//        CGContextDrawTiledImage(context, CGRectMake(0, 0, 20, 20), image.CGImage);//平铺图
    
}


@end
