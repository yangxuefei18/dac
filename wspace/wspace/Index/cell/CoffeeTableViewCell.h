//
//  CoffeeTableViewCell.h
//  wspace
//
//  Created by 汉德 on 2019/2/28.
//  Copyright © 2019 wspace. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoffeeTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *statusLabel;

@property (strong, nonatomic) UILabel *nameLabel2;
@property (strong, nonatomic) UILabel *numberLabel2;
@property (strong, nonatomic) UILabel *timeLabel2;
@property (strong, nonatomic) UILabel *statusLabel2;


@property (strong,nonatomic) NSString *type;
@property (strong, nonatomic) UIView *greenView;
@property (strong, nonatomic) UIView *redView;
@property (strong, nonatomic) UIImageView *imgView;
@end

NS_ASSUME_NONNULL_END
