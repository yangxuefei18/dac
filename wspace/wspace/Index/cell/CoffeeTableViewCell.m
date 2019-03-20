//
//  CoffeeTableViewCell.m
//  wspace
//
//  Created by 汉德 on 2019/2/28.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "CoffeeTableViewCell.h"
#import "Masonry.h"
#import "Common.h"

@implementation CoffeeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self setUpUICoffee];
    }
   return self;
}

- (void)setUp {
    _nameLabel.text = @"您最近没有到访的客人";
    NSLog(@"%@",_nameLabel.text);
    
   
    [self.contentView addSubview:_backView];
    self.contentView.backgroundColor = [UIColor greenColor];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 200));
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(10);
        make.bottom.mas_equalTo(-10);// 最后一个控件的bottom是关键点！！！
    }];
    NSLog(@"_backView = %@",NSStringFromCGRect(_backView.frame));
    
    NSLog(@"self.contentView = %@",NSStringFromCGRect(self.contentView.frame));

    _backView.backgroundColor  = [UIColor orangeColor];
    [_backView addSubview:_nameLabel];
    CGSize d = [Common setLabelFontFix:16.0f label:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(d.height);
        make.top.mas_equalTo(_backView.mas_top).offset(10);
        make.left.mas_equalTo(_backView.mas_left).offset(10);
        make.right.mas_equalTo(_backView.mas_right).offset(-10);
    }];
    _nameLabel.backgroundColor = [UIColor blueColor];
}

-(void)setNeedsLayout{
//    NSLog(@"123 = %@",_type);
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
//     NSLog(@"type= %@ , text = %@",_type,_nameLabel.text);
}
-(void)layoutIfNeeded{
    
//    NSLog(@"abc= %@",_type);
}



/** UI搭建 */
- (void)setUpUICoffee {
    UIView *mainView = [[UIView alloc] init];
    [self.contentView addSubview:mainView];
    //圆角
//    [Common setViewCornerTop:_backView left:10 right:10];
    mainView.layer.cornerRadius = 8;
    mainView.clipsToBounds = YES;
    mainView.layer.borderWidth = 2;
    mainView.layer.borderColor = [[Common colorWithHexString:@"000000"] CGColor ];
    mainView.backgroundColor = [UIColor orangeColor];
    
    //------- 上红色view -------//
    _redView = [[UIView alloc] init];
    [mainView addSubview:_redView];
    _redView.backgroundColor = [UIColor redColor];
    
//    @property (strong, nonatomic) UILabel *nameLabel;
//    @property (strong, nonatomic) UILabel *numberLabel;
//    @property (strong, nonatomic) UILabel *timeLabel;
//    @property (strong, nonatomic) UILabel *statusLabel;
    _nameLabel = [[UILabel alloc]init];
    
    
    //------- 中绿色view -------//
    _greenView = [[UIView alloc] init];
    [mainView addSubview:_greenView];
    _greenView.backgroundColor = [UIColor greenColor];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [Common colorWithHexString:@"000000"];
    [mainView addSubview:line];
    
    //------- 下蓝色view -------//
    UIView *blueView = [[UIView alloc] init];
    [mainView addSubview:blueView];
    blueView.backgroundColor = [UIColor blueColor];
    
    _imgView = [[UIImageView alloc]init];
    _imgView.backgroundColor = [UIColor brownColor];
    [mainView addSubview:_imgView];
    
    //------- 建立约束 -------//
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(UIEdgeInsetsMake(12, 16, 12, 16));
    }];
    
    
    
    [_redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(mainView);
        make.height.mas_equalTo(100);
    }];

    
    [_greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_redView.mas_bottom);
        make.left.right.mas_equalTo(mainView);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_greenView.mas_top).offset(1);
        make.left.equalTo(_greenView.mas_left).offset(6);
        make.right.equalTo(_greenView.mas_right).offset(-6);
        make.height.mas_equalTo(1);
    }];
    
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_greenView.mas_bottom);
        make.left.right.mas_equalTo(mainView); // bottom是关键点
                make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(mainView); // bottom是关键点
    }];
    
    
   
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_redView.mas_bottom).offset(-20);
        make.right.equalTo(mainView.mas_right).offset(-40);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    
}



/** UI搭建 */
- (void)setUpUI {
    
    
    //------- 上红色view -------//
    UIView *_redView = [[UIView alloc] init];
    [self.contentView addSubview:_redView];
    _redView.backgroundColor = [UIColor redColor];
    
    //------- label -------//
    _nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:20];
    _nameLabel.numberOfLines = 0;
    
    //------- 蓝色view -------//
    UIView *blueView = [[UIView alloc] init];
    [self.contentView addSubview:blueView];
    blueView.backgroundColor = [UIColor blueColor];
    
    //------- 绿色view -------//
    UIView *_greenView = [[UIView alloc] init];
    [self.contentView addSubview:_greenView];
    _greenView.backgroundColor = [UIColor greenColor];
    
    
    
    //------- 建立约束 -------//
    [_redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(_redView.mas_bottom);
    }];
    
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(_nameLabel.mas_bottom);
    }];
    
    [_greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blueView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView); // bottom是关键点
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.contentView); // bottom是关键点
    }];
    
}
@end
