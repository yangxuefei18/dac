//
//  AttanceListTableViewCell.h
//  wspace
//
//  Created by Hand02 on 2019/3/4.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttanceListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@end

NS_ASSUME_NONNULL_END
