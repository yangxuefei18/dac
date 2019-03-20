//
//  AttenceView.m
//  wspace
//
//  Created by Hand02 on 2019/3/1.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "AttenceView.h"
#import "UIView+TYAlertView.h"
#import "Common.h"
#import "HDAFNetWork.h"
#import "UIView+TYAlertView.h"
#import "MBProgressHUD+JDragon.h"
#import "HDAFNetWork.h"
#import "LGAlertView.h"

@implementation AttenceView{
}

- (IBAction)cancleBtnClick:(id)sender {
    [self hideView];
}
- (void)drawRect:(CGRect)rect {
    _workTimeView.layer.cornerRadius = 2;
    _widthConstraint.constant = 0.9*SCREENWIDTH;
    _heightConstraint.constant = 0.6*SCREENHEIGHT;
    _cancleBtn.layer.borderWidth = 1;
    _cancleBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    _cancleBtn.backgroundColor = [Common colorWithHexString:@"e3e3e3"];
    _okBtn.layer.borderWidth = 1;
    _okBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    _okBtn.backgroundColor = [Common colorWithHexString:@"e3e3e3"];
}




@end
