//
//  IndexCoffeeTableView_m
//  wspace
//
//  Created by 汉德 on 2019/2/28.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "IndexCoffeeTableViewCell.h"
#import "Common.h"

@implementation IndexCoffeeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (void)drawRect:(CGRect)rect {
    _allView.hidden = YES;
    _allView2.hidden = YES;
    _allView3.hidden = YES;
    if(_type  == 1){// 1 两个订单
        _allView.hidden = NO;
    }else if(_type  == 2){// 2 一个订单
        _allView2.hidden = NO;
    }else if(_type  == 0){// 0 无
        _allView3.hidden = NO;
    }
    
    _allView.layer.cornerRadius = 10;
    _allView.clipsToBounds = YES;
    
    _allView2.layer.cornerRadius = 10;
    _allView2.clipsToBounds = YES;
    
    _allView3.layer.cornerRadius = 10;
    _allView3.clipsToBounds = YES;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
