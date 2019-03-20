//
//  ImageScrollViewController.m
//  农商财富
//
//  Created by 汉德 on 2017/8/31.
//  Copyright © 2017年 河北农商财富. All rights reserved.
//

#import "ImageScrollViewController.h"
#import "UIImageView+WebCache.h"
#import "Common.h"

@interface ImageScrollViewController ()<UIScrollViewDelegate>
{
    NSString *moveState;//scrollview移动方向，值为left或right或keep
    NSTimer *scrollViewTimer;//banner定时滚动
}

@end

@implementation ImageScrollViewController

@synthesize imageScrollView,imagePageControl,layoutDataArray,aspectRatio;

- (void)viewDidLoad {
    [super viewDidLoad];
    imageScrollView = [UIScrollView new];
    imageScrollView.delegate = self;
    imagePageControl = [UIPageControl new];
    imageScrollView.showsVerticalScrollIndicator = FALSE;
    imageScrollView.showsHorizontalScrollIndicator = FALSE;

    [self startTimer];
    
    imageScrollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*aspectRatio);
    imageScrollView.pagingEnabled = YES;
    //设置滚动视图内容宽度
    imageScrollView.contentSize = CGSizeMake(SCREENWIDTH*(layoutDataArray.count), SCREENWIDTH*aspectRatio);
    //将第二页设置为起始显示页
    CGPoint point = imageScrollView.contentOffset;
    point.x = SCREENWIDTH;
    imageScrollView.contentOffset = point;
    
    NSInteger btnWidth = (SCREENWIDTH - 15*2 - 10) / 2;
    NSLog(@"宽：%ld",btnWidth);
    NSInteger btnHeight = btnWidth/3*1.7;
    
    //设置页码指示器，页码数比数组长度小2，ScrollView前后各多加入的图片做循环显示用
    imagePageControl.numberOfPages = layoutDataArray.count-2;
    imagePageControl.currentPageIndicatorTintColor =  [UIColor orangeColor];
    imagePageControl.pageIndicatorTintColor = [UIColor whiteColor];
    imagePageControl.backgroundColor = [UIColor redColor];
//    imagePageControl.frame = CGRectMake(0, imageScrollView.frame.size.height-btnHeight/2 - 25, SCREENWIDTH, 10);
    CGSize pageControlSize = [imagePageControl sizeForNumberOfPages:layoutDataArray.count-2];
    
    if (SCREENWIDTH == 414) {
        imagePageControl.frame = CGRectMake(imageScrollView.frame.size.width/2-pageControlSize.width/2-45, imageScrollView.frame.size.height-btnHeight/2 - 25, pageControlSize.width, 20);
    }else if (SCREENWIDTH == 375) {
        imagePageControl.frame = CGRectMake(imageScrollView.frame.size.width/2-pageControlSize.width/2-27, imageScrollView.frame.size.height-btnHeight/2 - 25, pageControlSize.width, 20);
    }else{
        imagePageControl.frame = CGRectMake(imageScrollView.frame.size.width/2-pageControlSize.width/2, imageScrollView.frame.size.height-btnHeight/2 - 25, pageControlSize.width, 20);
    }
    [self fillScrollView];
    [self.view addSubview:imageScrollView];
    [self.view addSubview:imagePageControl];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fillScrollView{
    
    CGFloat width = imageScrollView.frame.size.width;
    CGFloat height = imageScrollView.frame.size.height;
    
    for (int i=0; i<layoutDataArray.count; i++) {
        
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(width*i, 0, width, height)];
        imgView.backgroundColor = [Common colorWithHexString:@"212121"];
        UIButton *btn = [[UIButton alloc]initWithFrame:imgView.frame];
        
            btn.tag = i;
        [btn addTarget:self action:@selector(scrollBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [imgView sd_setImageWithURL:layoutDataArray[i][@"image_url"] placeholderImage:[UIImage imageNamed:@""]];
        
        [imageScrollView addSubview:imgView];
        [imageScrollView addSubview:btn];
        
    }
    
}

- (void)scrollBtnClick:(UIButton *)btn {
    NSLog(@"%ld",btn.tag);

}


#pragma mark - ScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    imagePageControl.currentPage = scrollView.contentOffset.x/SCREENWIDTH-1;

    if (scrollView.contentOffset.x == 0){
        if ([moveState isEqualToString:@"right"]) {
            //转至倒数第二页
            CGPoint point = imageScrollView.contentOffset;
            point.x =SCREENWIDTH*(layoutDataArray.count-2);
            scrollView.contentOffset = point;
            imagePageControl.currentPage = layoutDataArray.count-3;
        }
    }

    if (scrollView.contentOffset.x == SCREENWIDTH*(layoutDataArray.count-1)){
        if ([moveState isEqualToString:@"left"]) {
            //转至第二页
            CGPoint point = scrollView.contentOffset;
            point.x = SCREENWIDTH;
            scrollView.contentOffset = point;
            imagePageControl.currentPage = 0;
        }

    }

    [self startTimer];
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (targetContentOffset->x < scrollView.contentOffset.x){
        moveState = @"right";
    }else{
        moveState = @"left";
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //释放定时器
    [scrollViewTimer invalidate];
    scrollViewTimer = nil;
}

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
//    if (lastPoint.x == SCREENWIDTH*(layoutDataArray.count)){
//        lastPoint.x = 0;
//    }else{
//        lastPoint.x += SCREENWIDTH;
//    }
}

//开启banner图片自动展示定时器
- (void)startTimer {
    if (!scrollViewTimer){
        //重新开启定时器
        scrollViewTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scrollViewLoop) userInfo:nil repeats:YES];
    }
}

//banner图片循环
- (void)scrollViewLoop {
  
    CGPoint point = imageScrollView.contentOffset;
    point.x += SCREENWIDTH;
    
    [UIView animateWithDuration:.5 animations:^{
        imageScrollView.contentOffset = point;
    }];

    if (imagePageControl.currentPage == layoutDataArray.count-3){

        //转至第二页
        CGPoint point = imageScrollView.contentOffset;
        point.x = SCREENWIDTH;
        imageScrollView.contentOffset = point;
        imagePageControl.currentPage = 0;
    }else{
        imagePageControl.currentPage += 1;

    }
    
}


@end
