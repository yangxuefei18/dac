//
//  PersonalViewController.h
//  wspace
//
//  Created by Hand02 on 2019/2/25.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *InfoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeightCostraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
