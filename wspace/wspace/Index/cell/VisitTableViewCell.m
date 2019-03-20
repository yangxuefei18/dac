//
//  VisitTableViewCell.m
//  wspace
//
//  Created by 汉德 on 2019/2/13.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "VisitTableViewCell.h"
#import "Common.h"

@implementation VisitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _visitLabel.font = [UIFont systemFontOfSize:16.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, SCREENWIDTH-16*2, 48)];
        _backView.backgroundColor = [UIColor whiteColor];
        [Common setViewCornerBottom:_backView left:10 right:10];//圆角
        [self.contentView addSubview:_backView];
        
        _visitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _backView.frame.size.width/2, _backView.frame.size.height)];
        _visitLabel.text = @"";
        _visitLabel.textColor = [Common colorWithHexString:@"317ee7"];
        _visitLabel.textAlignment = NSTextAlignmentCenter;
        _visitLabel.font = [UIFont systemFontOfSize:16.0f];
        [_backView addSubview:_visitLabel];
        
        _visitBtn = [[UIButton alloc]initWithFrame:_visitLabel.frame];
        [_backView addSubview:_visitBtn];
        
        _rightLable = [[UILabel alloc]initWithFrame:CGRectMake(_backView.frame.size.width/2, 0, _backView.frame.size.width/2, _backView.frame.size.height)];
        _rightLable.text = @"";
        _rightLable.textColor = [Common colorWithHexString:@"317ee7"];
        _rightLable.textAlignment = NSTextAlignmentCenter;
        _rightLable.font = [UIFont systemFontOfSize:16.0f];
        [_backView addSubview:_rightLable];
        
        _rightBtn = [[UIButton alloc]initWithFrame:_rightLable.frame];
        [_backView addSubview:_rightBtn];
        
    }
    return self;
}
@end
