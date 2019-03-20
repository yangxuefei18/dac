//
//  MeetTableViewCell.h
//  wspace
//
//  Created by Hand02 on 2019/3/13.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeetTableViewCell : UITableViewCell

@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UIView *smallView;
@property (strong, nonatomic)  UIView *line;

@end

NS_ASSUME_NONNULL_END
