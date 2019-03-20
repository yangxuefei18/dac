//
//  AttenceView.h
//  wspace
//
//  Created by Hand02 on 2019/3/1.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttenceView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UITextField *toWorkTextField;
@property (weak, nonatomic) IBOutlet UITextField *offWorkTextField;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIView *workTimeView;



@end

NS_ASSUME_NONNULL_END
