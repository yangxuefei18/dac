//
//  ImageScrollViewController.h
//  农商财富
//
//  Created by 汉德 on 2017/8/31.
//  Copyright © 2017年 河北农商财富. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollViewController : UIViewController

@property (strong, nonatomic) UIScrollView *imageScrollView;
@property (strong, nonatomic) UIPageControl *imagePageControl;
@property (strong, nonatomic) NSArray *layoutDataArray;
@property (assign, nonatomic) CGFloat aspectRatio;

@end
