//
//  ScheduledMeetingTableViewCell.h
//  wspace
//
//  Created by 汉德 on 2019/2/13.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScheduledMeetingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *meetingBtn;
@property (weak, nonatomic) IBOutlet UILabel *meetingLabel;

@end

NS_ASSUME_NONNULL_END
