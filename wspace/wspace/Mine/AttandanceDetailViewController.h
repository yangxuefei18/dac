//
//  AttandanceDetailViewController.h
//  wspace
//
//  Created by Hand02 on 2019/3/4.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttandanceDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSString *time;

@end

NS_ASSUME_NONNULL_END
