//
//  NoRecordTableViewCell.h
//  wspace
//
//  Created by 汉德 on 2019/2/13.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;

@end

NS_ASSUME_NONNULL_END
