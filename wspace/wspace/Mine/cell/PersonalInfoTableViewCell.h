//
//  PersonalInfoTableViewCell.h
//  wspace
//
//  Created by Hand02 on 2019/2/25.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@end

NS_ASSUME_NONNULL_END
