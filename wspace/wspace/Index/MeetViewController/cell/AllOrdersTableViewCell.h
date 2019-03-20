//
//  AllOrdersTableViewCell.h
//  wspace
//
//  Created by Hand02 on 2019/2/26.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllOrdersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *inTimeLabel;

@end

NS_ASSUME_NONNULL_END
