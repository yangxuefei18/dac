//
//  ChooseSeatsViewController.m
//  wspace
//
//  Created by 汉德 on 2019/2/14.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "ChooseSeatsViewController.h"
#import "Common.h"
#import "UIImageView+WebCache.h"

@interface ChooseSeatsViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    UIScrollView *scrollView;
    UIImageView *imageView;
}

@end

@implementation ChooseSeatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScrollView];
}

-(void)setScrollView{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, SCREENHEIGHT-200)];
    scrollView.backgroundColor = [UIColor redColor];
//    scrollView.contentSize = CGSizeMake(SCREENWIDTH*2,2*( SCREENHEIGHT-200));
    //设置最大最小缩放倍数
    scrollView.maximumZoomScale = 3.0;
    scrollView.minimumZoomScale = 1.0;
    //设置代理
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    ///iamgeView
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-200)];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor greenColor];
    ///座位图
    UIImage *image = [UIImage imageNamed:@"zuowei"];
    imageView.image = image;
    [scrollView addSubview:imageView];
    
    ///修改imageView大小
    CGFloat imageViewHeight = SCREENWIDTH / image.size.width * image.size.height;
    imageView.frame = CGRectMake(0, 0, SCREENWIDTH, imageViewHeight);
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 8, 8)];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(btnClicks:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btn];
    UIButton *dbtn = [[UIButton alloc]initWithFrame:CGRectMake(300, 200, 8, 8)];
    dbtn.backgroundColor = [UIColor yellowColor];
    [dbtn addTarget:self action:@selector(btnClicks:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:dbtn];
    
}

///
-(void)btnClicks:(UIButton *)btn{
    NSLog(@"%f",btn.frame.origin.x);
}

///当滚动视图中即将发生缩放时，要求代理缩放视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
