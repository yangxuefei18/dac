//
//  VisitTableViewCell.h
//  wspace
//
//  Created by 汉德 on 2019/2/13.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VisitTableViewCell : UITableViewCell
@property (strong, nonatomic)  UIView *backView;
@property (strong, nonatomic)  UIButton *visitBtn;
@property (strong, nonatomic)  UIButton *rightBtn;
@property (strong, nonatomic)  UILabel *visitLabel;
@property (strong, nonatomic)  UILabel *rightLable;
@end

NS_ASSUME_NONNULL_END
