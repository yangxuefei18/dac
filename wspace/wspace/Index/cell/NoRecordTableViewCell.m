//
//  NoRecordTableViewCell.m
//  wspace
//
//  Created by 汉德 on 2019/2/13.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "NoRecordTableViewCell.h"

@implementation NoRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    //得到view的遮罩路径
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
//    //创建 layer
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _backView.bounds;
//    //赋值
//    maskLayer.path = maskPath.CGPath;
//    _backView.layer.mask = maskLayer;
    
    _noRecordLabel.font = [UIFont systemFontOfSize:16.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
