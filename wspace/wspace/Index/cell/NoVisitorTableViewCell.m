//
//  NoVisitorTableViewCell.m
//  wspace
//
//  Created by 汉德 on 2019/2/12.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "NoVisitorTableViewCell.h"
#import "Common.h"

@implementation NoVisitorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, SCREENWIDTH-16*2, 48)];
        _backView.backgroundColor = [UIColor whiteColor];
        //圆角
        [Common setViewCornerTop:_backView left:10 right:10];
        [self.contentView addSubview:_backView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(6, 47, _backView.frame.size.width-12, 1)];
        line.backgroundColor = [Common colorWithHexString:LINECOLOR];
        [_backView addSubview:line];
        
        _noVisitorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _backView.frame.size.width, _backView.frame.size.height-1)];
        _noVisitorLabel.text = @"您最近没有到访的客人";
        _noVisitorLabel.textAlignment = NSTextAlignmentCenter;
        _noVisitorLabel.font = [UIFont systemFontOfSize:16.0f];
        [_backView addSubview:_noVisitorLabel];
    }
   return self;
}

@end
