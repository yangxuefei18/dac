//
//  ScheduledSuccessViewController.m
//  wspace
//  预定成功
//  Created by 汉德 on 2019/2/26.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "ScheduledSuccessViewController.h"
#import "Common.h"
#import "Masonry.h"

@interface ScheduledSuccessViewController (){
    
    UIView *backView;
}

@end

@implementation ScheduledSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, MarginTopHeight, SCREENWIDTH, SCREENHEIGHT - MarginTopHeight) ];
    backView.backgroundColor = [Common colorWithHexString:@"ebebeb"];
    [self.view addSubview:backView];
    
    int mainViewHeight = SCREENWIDTH / 512 * 200;
    NSString *labelText = @"预定成功";
    NSString *labelText1 = @"";
    NSString *labelText2 = @"";
    NSString *labelText1_2 = @"";
    NSString *labelText2_2 = @"";
    NSString *labelText3 = @"";
    if([_dataDic[@"type"] isEqualToString:@"visit"]){
        mainViewHeight += 60;
        labelText1 = [NSString stringWithFormat:@"%@公司的%@将与", _dataDic[@"data"][0][@"company_name"],_dataDic[@"data"][0][@"v_name"]];
        labelText2 = [NSString stringWithFormat:@"%@来访,我们将向", _dataDic[@"data"][0][@"visit_time"]];
        labelText3 = [NSString stringWithFormat:@"%@邮箱发送访客权限", _dataDic[@"data"][0][@"v_email"]];
    }else if([_dataDic[@"type"] isEqualToString:@"pay"]){
        
    }else if([_dataDic[@"type"] isEqualToString:@"meeting"]){
        labelText1 = [NSString stringWithFormat:@"%@ %@",_dataDic[@"data"][0][@"date"],_dataDic[@"data"][0][@"time"]];
        labelText2 = [NSString stringWithFormat:@"%@",_dataDic[@"data"][0][@"room_name"]];
        if (((NSArray *)_dataDic[@"data"]).count == 2) {
            labelText1_2 = [NSString stringWithFormat:@"%@ %@",_dataDic[@"data"][1][@"date"],_dataDic[@"data"][0][@"time"]];
            labelText2_2 = [NSString stringWithFormat:@"%@",_dataDic[@"data"][1][@"room_name"]];
        }
    }
    
    UIView *mainView =[[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, mainViewHeight) ];
    mainView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:mainView];
    
    
    UIView *view1 = [[UIView alloc]init];
    [mainView addSubview:view1];
    
    UILabel *okLabel = [[UILabel alloc]init];
    okLabel.text = labelText;
    CGSize lableSize = [Common setLabelFontFix:20.0f label:okLabel];
    view1.frame = CGRectMake((mainView.frame.size.width-(lableSize.width +lableSize.height))/2 - 4, 34, lableSize.width +lableSize.height + 8,lableSize.height );
    okLabel.frame = CGRectMake(okLabel.frame.size.height + 8, 0, okLabel.frame.size.width, okLabel.frame.size.height);
    [view1 addSubview: okLabel];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 2, lableSize.height-2, lableSize.height-2)];
    imageView.image = [UIImage imageNamed:@"success"];
    [view1 addSubview:imageView];
    
    
    UILabel *label0 = [[UILabel alloc]init];
    if(![labelText1 isEqualToString:@""]){
        label0.text = labelText1 ;
        [Common setLabelFontFix:18.0f label:label0];
        [mainView addSubview: label0];
        [label0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view1.mas_bottom).offset(18);
            make.left.equalTo(mainView.mas_left).offset(0);
            make.right.equalTo(mainView.mas_right).offset(0);
        }];
    }
    
    UILabel *label1 = [[UILabel alloc]init];
    if(![labelText2 isEqualToString:@""]){
        label1.text = labelText2;
        [Common setLabelFontFix:18.0f label:label1];
        [mainView addSubview: label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label0.mas_bottom).offset(10);
            make.left.equalTo(mainView.mas_left).offset(0);
            make.right.equalTo(mainView.mas_right).offset(0);
        }];
    }
    
    UILabel *label2 = [[UILabel alloc]init];
    if(![labelText3 isEqualToString:@""]) {
        label2.text = labelText3;
        [Common setLabelFontFix:18.0f label:label2];
        label2.numberOfLines = 2;
        [Common setLineSpace:8.0f withText:labelText3 inLabel:label2];
        [mainView addSubview: label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label1.mas_bottom).offset(10);
            make.left.equalTo(mainView.mas_left).offset(MarginLR);
            make.right.equalTo(mainView.mas_right).offset(-MarginLR);
        }];
    }
    
    UILabel *label1_2 = [[UILabel alloc]init];
    if(![labelText1_2 isEqualToString:@""]) {
        label1_2.text = labelText1_2;
        [Common setLabelFontFix:18.0f label:label1_2];
        [mainView addSubview: label1_2];
        [label1_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label1.mas_bottom).offset(10);
            make.left.equalTo(mainView.mas_left).offset(MarginLR);
            make.right.equalTo(mainView.mas_right).offset(-MarginLR);
        }];
    }
    
    UILabel *label2_2 = [[UILabel alloc]init];
    if(![labelText2_2 isEqualToString:@""]) {
        label2_2.text = labelText2_2;
        [Common setLabelFontFix:18.0f label:label2_2];
        [mainView addSubview: label2_2];
        [label2_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label1_2.mas_bottom).offset(10);
            make.left.equalTo(mainView.mas_left).offset(MarginLR);
            make.right.equalTo(mainView.mas_right).offset(-MarginLR);
        }];
        
        [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(label2_2.mas_bottom).offset(20);
            make.left.equalTo(self->backView.mas_left).offset(0);
            make.right.equalTo(self->backView.mas_right).offset(0);
        }];
    }
    
    
    
}



@end
