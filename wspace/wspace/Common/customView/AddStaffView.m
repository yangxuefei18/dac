//
//  AddStaffView.m
//  wspace
//
//  Created by Hand02 on 2019/3/4.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "AddStaffView.h"
#import "UIView+TYAlertView.h"
#import "Common.h"
#import "HDAFNetWork.h"

@implementation AddStaffView


- (IBAction)cancleClickBtn:(id)sender {
    [self hideView];
}
- (void)drawRect:(CGRect)rect {
    //取消 确认按钮样式
    _cancleBtn.layer.borderWidth = 1;
    _cancleBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    _cancleBtn.backgroundColor = [Common colorWithHexString:@"e3e3e3"];
    _okBtn.layer.borderWidth = 1;
    _okBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    _okBtn.backgroundColor = [Common colorWithHexString:@"e3e3e3"];
    
    //view的宽高 根据手机屏幕的宽高设置
    _widthConstraint.constant = 0.9*SCREENWIDTH;
    _heightConstraint.constant = 0.6*SCREENHEIGHT;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
