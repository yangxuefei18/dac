//
//  StaffTimeListTableViewCell.h
//  wspace
//
//  Created by Hand02 on 2019/2/27.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StaffTimeListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amTime;
@property (weak, nonatomic) IBOutlet UILabel *pmTime;

@end

NS_ASSUME_NONNULL_END
