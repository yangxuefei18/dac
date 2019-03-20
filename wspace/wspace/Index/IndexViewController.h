//
//  IndexViewController.h
//  wspace
//
//  Created by 汉德 on 2019/2/12.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IndexViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewMarginTop;

@end

NS_ASSUME_NONNULL_END
