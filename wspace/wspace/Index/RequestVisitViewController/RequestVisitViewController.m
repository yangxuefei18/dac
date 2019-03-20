//
//  RequestVisitViewController.m
//  wspace
//
//  Created by 汉德 on 2019/2/26.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "RequestVisitViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "MBProgressHUD+JDragon.h"
#import "IQKeyboardManager.h"
#import "ScheduledSuccessViewController.h"
#import "HDAFNetWork.h"

@interface RequestVisitViewController ()<UITextFieldDelegate>{
    NSMutableDictionary *subDic;
    
    UITextField *textField;
}

@property (nonatomic, strong) UIDatePicker *datePicker;
@end
@implementation RequestVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    subDic = [NSMutableDictionary new];
    [self initView];
}
-(void)initView{
    UIView *backView;
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, MarginTopHeight, SCREENWIDTH, SCREENHEIGHT-MarginTopHeight)];
    [self.view addSubview:backView];
    
    UILabel *nameLabel;
    UILabel *nameLabel2;
    NSString *titleText;
    int marginTop = 30,marginLeftAndRight = 18,lableHeight = 34,lableWidth = 100;
    for (int i =0; i < 4; i++) {
        titleText = i == 0 ? @"访客姓名*":(i == 1? @"访客单位":(i == 2? @"访客邮箱*":@"访问时间"));
        //lable
        nameLabel = [UILabel new];
        nameLabel.text = titleText;
        [Common setLabelFontFix:16.0f label:nameLabel];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [backView addSubview:nameLabel];
        nameLabel.backgroundColor = [UIColor redColor];
        
        lableWidth = i == 0? nameLabel.frame.size.width+6:lableWidth;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i == 0){
                make.top.equalTo(backView.mas_top).offset(20);
                make.width.mas_equalTo(lableWidth);
            }else{
                make.top.equalTo(nameLabel2.mas_bottom).offset(marginTop);
                make.width.mas_equalTo(lableWidth);
            }
            make.left.equalTo(backView.mas_left).offset(marginLeftAndRight);
            make.height.mas_equalTo(lableHeight);
        }];
        [backView addSubview:nameLabel];
        nameLabel2 = nameLabel;
        
        //input
        textField = [UITextField new];
        
        [backView addSubview:textField];
//        textField.backgroundColor = [UIColor greenColor];
        textField.placeholder = i == 2? @"我们将向该邮箱发送访问权限":(i == 3? @"访问权限仅在访问当天有效":@"");
        textField.tag = i;
        textField.layer.cornerRadius = 2;
        textField.clipsToBounds = YES;
        textField.layer.borderWidth = 0.5;
        textField.layer.borderColor = [[Common colorWithHexString:@"d8d8d8"] CGColor ];
        
        textField.delegate = self;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(nameLabel.mas_top).offset(0);
            make.left.equalTo(nameLabel.mas_right).offset(marginLeftAndRight);
            make.right.equalTo(backView.mas_right).offset(-marginLeftAndRight);
            make.height.equalTo(nameLabel.mas_height);
        }];
        
        if(i == 3)
            [self setupDateKeyPan];
    }
    
    UIButton *subBtn = [[UIButton alloc]init];
    [subBtn setTitle:@"提交申请" forState:0];
    [subBtn addTarget:self action:@selector(submissionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:subBtn];
    subBtn.backgroundColor = [UIColor redColor];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView.mas_bottom).offset(-60);
        make.left.equalTo(backView.mas_left).offset(150);
        make.right.equalTo(backView.mas_right).offset(-150);
        make.height.mas_equalTo(44);
    
    }];
    

}
//内容改变
- (void)textFieldDidChange:(UITextField *)textField {
    if(textField.tag == 0){
        [subDic setValue:textField.text forKey:@"user_name"];
    }else if(textField.tag == 1){
        [subDic setValue:textField.text forKey:@"company"];
    }else if(textField.tag == 2){
        [subDic setValue:textField.text forKey:@"email"];
    }
    NSLog(@"%@",subDic);
}

///
/**
 * 提交
 *
 */
-(void)submissionBtnClick{
    if(subDic[@"user_name"] == nil || [subDic[@"user_name"] isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"请输入访客姓名"];return;
    }
    if(subDic[@"company"] == nil || [subDic[@"company"] isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"请输入访客单位"];return;
    }
    if(subDic[@"email"] == nil || [subDic[@"email"] isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"请输入访客邮箱"];return;
    }
    if(subDic[@"date"] == nil || [subDic[@"date"] isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"请选择访问时间"];return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@Work/setAccess",HOSTURL ];
    [HDAFNetWork POST:url params:subDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] isEqualToString:@"1"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Index" bundle:nil];
                ScheduledSuccessViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"ScheduledSuccessViewController"];
                vc.title = @"预定成功";
                [responseObject setValue:@"visit" forKey:@"type"];
                
                vc.dataDic =  [NSMutableDictionary new];
                vc.dataDic = responseObject;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


- (void)setupDateKeyPan {
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    //设置地区: zh-中国
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    
    //设置日期模式(Displays month, day, and year depending on the locale setting)
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    //监听DataPicker的滚动
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    self.datePicker = datePicker;
    
    //设置时间输入框的键盘框样式为时间选择器
    textField.inputView = datePicker;
}

//点击当前视图, 结束编辑状态
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [textField resignFirstResponder];
}
//点击当前视图, 结束编辑状态
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(![textField isExclusiveTouch]){
        [textField resignFirstResponder];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    if(textField.tag == 3){
        [self dateChange:_datePicker];
    }
}

- (void)dateChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [formatter stringFromDate:datePicker.date];
    textField.text = dateStr;
    [subDic setValue:[NSString stringWithFormat:@"%@:00", dateStr] forKey:@"date"];
}


//禁止用户输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}@end
