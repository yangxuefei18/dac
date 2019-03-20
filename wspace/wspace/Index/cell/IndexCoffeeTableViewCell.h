//
//  IndexCoffeeTableViewCell.h
//  wspace
//
//  Created by 汉德 on 2019/2/28.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IndexCoffeeTableViewCell : UITableViewCell
@property (assign, nonatomic) NSInteger type;// 1 两个订单 2 一个订单 0 无

@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet UIView *allView2;
@property (weak, nonatomic) IBOutlet UIView *allView3;

@property (weak, nonatomic) IBOutlet UILabel *nameAndNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameAndNumberLabel2;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel2;
@property (weak, nonatomic) IBOutlet UIButton *allOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightnBtn;

@property (weak, nonatomic) IBOutlet UILabel *nAnLabel;
@property (weak, nonatomic) IBOutlet UILabel *tLable;
@property (weak, nonatomic) IBOutlet UILabel *staLabel;
@property (weak, nonatomic) IBOutlet UIButton *allOrderBtn2;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn2;

@property (weak, nonatomic) IBOutlet UIButton *allOrderBtn3;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn3;

@end

NS_ASSUME_NONNULL_END
