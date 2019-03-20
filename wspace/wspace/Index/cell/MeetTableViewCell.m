//
//  MeetTableViewCell.m
//  wspace
//
//  Created by Hand02 on 2019/3/13.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "MeetTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation MeetTableViewCell

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
        _smallView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, SCREENWIDTH-16*2, 70)];
        _smallView.backgroundColor = [UIColor whiteColor];
        //圆角
        [Common setViewCornerTop:_smallView left:10 right:10];
        [self.contentView addSubview:_smallView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 5, _smallView.frame.size.width,34)];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [_smallView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 35, _smallView.frame.size.width,34)];
        _timeLabel.font = [UIFont systemFontOfSize:15];
        [_smallView addSubview:_timeLabel];
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(6, 69, _smallView.frame.size.width-12, 1)];
        _line.backgroundColor = [Common colorWithHexString:LINECOLOR];
        [_smallView addSubview:_line];
        
        
    }
    return self;
}

@end
