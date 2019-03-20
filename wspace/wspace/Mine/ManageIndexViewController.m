//
//  ManageIndexViewController.m
//  wspace
//
//  Created by Hand02 on 2019/2/26.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "ManageIndexViewController.h"
#import "ManageList1TableViewCell.h"
#import "StaffListTableViewCell.h"
#import "StaffTimeListTableViewCell.h"
#import "LGAlertView.h" //弹框第三方文件
#import "Common.h"
#import "AttenceView.h"
#import "AddStaffView.h"
#import "UIView+TYAlertView.h"
#import "AttandanceListViewController.h"
#import "MBProgressHUD+JDragon.h"
#import "HDAFNetWork.h"

@interface ManageIndexViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, LGAlertViewDelegate>{
    NSInteger peopleNum;
    NSIndexPath *editingIndexPath;
    AddStaffView *add;
    AttenceView *att;
    double workWidth;
    NSArray *weekArr;
    UIImageView *imgView;
    NSMutableDictionary *selectedWeekDic;
    NSMutableArray *selectArr;
    NSMutableArray *detailArr;//人员当天考勤数据
    NSMutableArray *staffArr;//员工数据
    NSMutableDictionary *attDic;//考勤数据
    UIDatePicker *datePicker;
    UIDatePicker *datePicker1;
}

@property (strong, nonatomic) LGAlertView *securityAlertView;
//创建对象
@property (nonatomic, strong) UIDatePicker *dateP;

@end

@implementation ManageIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    staffArr = [NSMutableArray new];
    attDic = [NSMutableDictionary new];
    detailArr = [NSMutableArray new];
    datePicker = [[UIDatePicker alloc] init];;
    datePicker1 = [[UIDatePicker alloc] init];
    //设置考勤弹窗属性
    selectedWeekDic = [NSMutableDictionary new];
    weekArr = [NSArray arrayWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"ManageList1TableViewCell" bundle:nil] forCellReuseIdentifier:@"ManageList1TableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StaffListTableViewCell" bundle:nil] forCellReuseIdentifier:@"StaffListTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StaffTimeListTableViewCell" bundle:nil] forCellReuseIdentifier:@"StaffTimeListTableViewCell"];
    
    [self getAttandenceDataFromServer];
    // Do any additional setup after loading the view.
}

// 获取页面数据 员工信息 员工考勤信息 考勤时间
- (void)getAttandenceDataFromServer{
    
    [MBProgressHUD showActivityMessageInWindow:@"数据加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@Admin/attandenceData",HOSTURL];
    [HDAFNetWork GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
             [MBProgressHUD hideHUD];
            if([responseObject[@"code"] isEqualToString:@"1"]){
                if (responseObject[@"data"] != NULL) {
                    self->staffArr = responseObject[@"data"][0][@"staffName"];
                    self->detailArr = responseObject[@"data"][0][@"detail"];
                    self->attDic = responseObject[@"data"][0][@"attandenceData"];
                }
            }else{
                 [MBProgressHUD showTipMessageInWindow:responseObject[@"msg"] timer:2 yOffset:SCREENHEIGHT/2-300 color:nil];
            }
            
            
            [self.tableView reloadData];
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}


//几个单元，块
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
    
}
//每个单元几个row 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        if(attDic.count==0){
            return 2;
        }
        return 13;
    }else if(section == 1){
        return staffArr.count+2;
    }else{
        return 0;
    }
    
    
}
//每个row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            return 50;
        }else{
            if(attDic.count==0){
                return 150;
            }else{
                return 30;
            }
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            return  15;
        }else if (indexPath.row == 1){
            return 50;
        }else{
            return 60;
        }
    }else{
        return 0;
    }
    
}


//每行的cell的属性
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        //设置cell
        if(indexPath.row == 0){
            ManageList1TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ManageList1TableViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"考勤";
            [cell.operateBtn setTitle:@"设置" forState:0];
            //添加点击事件
            cell.operateBtn.tag = 0;
            [cell.operateBtn addTarget:self action:@selector(operateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else{
            if(attDic.count == 0){
                //没有设置考勤
                UITableViewCell *cell = [UITableViewCell new];
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,150)];
                UILabel *label = [UILabel new];
                label.frame = view.frame;
                [label setFont:[UIFont systemFontOfSize:17]];
                [label setTextColor:[Common colorWithHexString:MAINFONTCOLOR]];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = @"还未设置考勤时间";
                [view addSubview:label];
                [cell addSubview:view];
                return  cell;
            }else{
                //设置了考勤 12 查看更多 1 日期
                if(indexPath.row ==12 || indexPath.row ==1 ){
                    UITableViewCell *cell = [UITableViewCell new];
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,30)];
                    UILabel *label = [UILabel new];
                    label.frame = view.frame;
                    [view addSubview:label];
                    [cell addSubview:view];
                    [label setFont:[UIFont systemFontOfSize:17]];
                    [label setTextColor:[Common colorWithHexString:MAINFONTCOLOR]];
                    label.textAlignment = NSTextAlignmentCenter;
                    if(indexPath.row ==1){
                        NSDate *date=[NSDate date];
                        NSDateFormatter *format1=[[NSDateFormatter alloc] init];
                        [format1 setDateFormat:@"yyyy-MM-dd"];
                        NSString *dateStr;
                        dateStr=[format1 stringFromDate:date];
                        label.text = dateStr;
                    }else{
                        label.text = @"查看更多";
                        UIButton *btn = [[UIButton alloc] init];
                        btn.frame = label.frame;
                        //添加点击事件
                        [btn addTarget:self action:@selector(checkMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:btn];
                        [self.view bringSubviewToFront:btn];
                    }
                    return  cell;
                }
                if(detailArr.count > 0 && indexPath.row - 2 < detailArr.count ){
                    StaffTimeListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"StaffTimeListTableViewCell" forIndexPath:indexPath];
                    
                    if([detailArr[indexPath.row-2][@"name"] isKindOfClass:[NSString class]]){
                        cell.nameLabel.text =detailArr[indexPath.row-2][@"name"];
                    }else{
                        cell.nameLabel.text =@"未知";
                    }
                    cell.amTime.text = detailArr[indexPath.row-2][@"onwork_time"];
                    cell.pmTime.text = detailArr[indexPath.row-2][@"offwork_time"];
                    [cell.nameLabel setTextColor:[Common colorWithHexString:MAINFONTCOLOR]];
                    [cell.amTime setTextColor:[Common colorWithHexString:MAINFONTCOLOR]];
                    [cell.pmTime setTextColor:[Common colorWithHexString:MAINFONTCOLOR]];
                    return cell;
                }else{
                    return [UITableViewCell new];
                }
            }
            
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            UITableViewCell *cell = [UITableViewCell new];
            cell.backgroundColor = [Common colorWithHexString:@"f8f8f8"];
            return cell;
        }else if(indexPath.row == 1){
            ManageList1TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ManageList1TableViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"员工";
            cell.operateBtn.tag = 1;
            [cell.operateBtn setTitle:@"新增" forState:0];
            [cell.operateBtn addTarget:self action:@selector(operateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else{
            if(staffArr.count>0){
                StaffListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"StaffListTableViewCell" forIndexPath:indexPath];
                if([staffArr[indexPath.row-2][@"permission"] integerValue] == 2){
                    cell.staffLabel.text = [NSString stringWithFormat:@"%@(管理员)",staffArr[indexPath.row-2][@"name"]] ;
                }else{
                    cell.staffLabel.text = staffArr[indexPath.row-2][@"name"];
                }
                [cell.staffLabel setTextColor:[Common colorWithHexString:MAINFONTCOLOR]];
                return cell;
            }else{
                return [UITableViewCell new];
            }
            
        }
    }else{
        return [UITableViewCell new];
    }
}



//点击 查看更多按钮
-(void)checkMoreBtnClick{
    NSLog(@"%@",@"点击了查看更多");
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
    AttandanceListViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"AttandanceListViewController"];
    vc.title = @"考勤记录";
    [self.navigationController pushViewController:vc animated:YES];
}



//点击 设置考勤/新增员工 按钮 0为设置 1为新增
-(void)operateBtnClick:(UIButton *)btn{
    if(btn.tag == 0){//设置考勤
        NSLog(@"%@",@"点击了设置考勤");
        att = [AttenceView createViewFromNib];
        att.toWorkTextField.delegate = self;
        att.offWorkTextField.delegate = self;
        NSString *weekStr = @"";//接口拿到的考勤日期
        if(attDic.count>0){
            att.toWorkTextField.text = attDic[@"onduty_time"];
            att.offWorkTextField.text = attDic[@"offduty_time"];
            weekStr = attDic[@"week"] ;
        }
        
        
        [att.okBtn addTarget:self action:@selector(attOKBtnClick) forControlEvents:UIControlEventTouchUpInside];
        workWidth = (0.9*SCREENWIDTH-50)/7;//每个按钮的宽高
        for(int i=0;i<7;i++){
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10+(workWidth+5)*i, 20, workWidth, workWidth)];
            //1234
            btn.backgroundColor = [weekStr containsString:[NSString stringWithFormat:@"%d",i] ]?[UIColor blueColor]:[UIColor grayColor];
            btn.layer.cornerRadius = 2;
            btn.selected = [weekStr containsString:[NSString stringWithFormat:@"%d",i] ]?YES:NO;
            btn.tag = i;
            //如果接口内已经设置为工作日存value  0为未选择的日期   selectedWeekDic：存放提交时选择的工作日
            [selectedWeekDic setValue:[weekStr containsString:[NSString stringWithFormat:@"%d",i] ] ?[NSString stringWithFormat:@"%d",i ]:@"0" forKey: [NSString stringWithFormat:@"%d",i ]];
            //添加点击事件
            [btn addTarget:self action:@selector(weekBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, workWidth, workWidth/2)];
            label.textAlignment = 1;//居中1 居左0 居右2
            label.textColor = [UIColor whiteColor];
            label.text = weekArr[i];
            label.font = [UIFont systemFontOfSize:14];
            [btn addSubview:label];
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake((workWidth-workWidth/3)/2, workWidth/2+2, workWidth/3, workWidth/3)];
            [imgView setImage:[UIImage imageNamed:@"ok"] ];
            imgView.hidden = [weekStr containsString:[NSString stringWithFormat:@"%d",i] ]?NO:YES;
            [btn addSubview:imgView];
            [att.btnView addSubview:btn];
        }
        
        //初始化表盘
        [self setupDateKeyPan];
        [att showInWindow];
        
    }else{//添加员工
        add = [AddStaffView createViewFromNib];
        //ok按钮 添加点击事件
        [add.okBtn addTarget:self action:@selector(addOKBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [add showInWindow];
    }
}

//设置/更新考勤 点击ok按钮 提交数据
-(void)attOKBtnClick{
    
    NSString *selectStr=@"";
    for(NSString *str in [selectedWeekDic allValues]){
        if(![str isEqualToString:@"0"]){
            if([selectStr isEqualToString:@""]){
                selectStr = str;
            }else{
                selectStr = [NSString stringWithFormat:@"%@,%@",selectStr,str ];
            }
        }
    }
    
    if([selectStr isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"请选择考勤时间！" timer:1 yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    
    if([att.toWorkTextField.text isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"上班时间不能为空！" timer:1 yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if([att.offWorkTextField.text isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"下班时间不能为空！" timer:1 yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@Admin/setAttandence",HOSTURL];
    NSMutableDictionary *paramsDic = [NSMutableDictionary new];
    [paramsDic setValue:att.toWorkTextField.text forKey:@"ontime"];
    [paramsDic setValue:att.offWorkTextField.text forKey:@"offtime"];
    [paramsDic setValue:selectStr forKey:@"week"];
    if(attDic.count>0){
         [paramsDic setValue:attDic[@"id"] forKey:@"aid"];
    }
   
    [HDAFNetWork GET:url params:paramsDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] isEqualToString:@"1"]) {
                [MBProgressHUD showTipMessageInWindow:@"更新成功！" timer:1  yOffset:SCREENHEIGHT/2-100 color:nil];
                //弹框提示1秒后调用接口刷新数据
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1.0* NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                    
                    [self getAttandenceDataFromServer];
                    
                });
            }
            [self.tableView reloadData];
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    [att hideView];
    
}


//点击设置考勤中的 选择星期
-(void)weekBtnClick:(UIButton *)btn{
    //遍历图片 将图片放在每个按钮的下方 选中不隐藏
    for (UIView *image in btn.subviews) {
        if(image.frame.origin.y != 0 ){
            if(image.hidden)
                image.hidden = NO;
            else
                image.hidden = YES;
        }
    }
    NSLog(@"我点击了%ld",btn.tag);
    if(btn.selected){//已选中，改为未选中
        btn.backgroundColor = [UIColor grayColor];
        btn.selected = NO;
        [selectedWeekDic setValue:@"0" forKey:[NSString stringWithFormat:@"%ld",btn.tag ]];
    }else{//未选中，改为选中
        btn.backgroundColor = [UIColor blueColor];
        btn.selected = YES;
        //给选中的按钮赋值 第1个按钮（下标为0）的值为1
        [selectedWeekDic setValue:[NSString stringWithFormat:@"%ld",btn.tag] forKey:[NSString stringWithFormat:@"%ld",btn.tag ]];
    }
}



//新增员工 ok按钮
-(void)addOKBtnClick{
    
    if([add.nameTextField.text isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"姓名不能为空！" timer:1 yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if([add.telTextField.text isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"电话不能为空！" timer:1 yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if([add.emailTextField.text isEqualToString:@""]){
        [MBProgressHUD showTipMessageInWindow:@"邮箱不能为空！" timer:1 yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if(![Common isValidateEmail:add.emailTextField.text]){
        [MBProgressHUD showTipMessageInWindow:@"邮箱格式错误！" yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    if(![Common checkPhoneNum:add.telTextField.text]){
        [MBProgressHUD showTipMessageInWindow:@"手机号格式错误！" yOffset:SCREENHEIGHT/2-300 color:nil];
        return;
    }
    NSLog(@"%@%@%@",add.nameTextField.text,add.telTextField.text,add.emailTextField.text);
    
    NSString *url = [NSString stringWithFormat:@"%@Admin/addStaff",HOSTURL];
    NSMutableDictionary *paramsDic = [NSMutableDictionary new];
    [paramsDic setValue:add.nameTextField.text forKey:@"name"];
    [paramsDic setValue:add.telTextField.text forKey:@"contact_num"];
    [paramsDic setValue:add.emailTextField.text forKey:@"email"];
   
    
    [HDAFNetWork GET:url params:paramsDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] isEqualToString:@"1"]) {
                [MBProgressHUD showTipMessageInWindow:@"添加成功！" timer:1  yOffset:SCREENHEIGHT/2-100 color:nil];
                //弹框提示1秒后调用接口刷新数据
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1.0* NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                    
                    [self getAttandenceDataFromServer];
                    
                });
            }
            [self.tableView reloadData];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    [att hideView];
    
    
}



/***************设置键盘为日期模式*******************/
- (void)setupDateKeyPan {
    
   
    //设置地区: zh-中国
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    datePicker1.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    
    //设置日期模式(Displays month, day, and year depending on the locale setting)
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker1.datePickerMode = UIDatePickerModeTime;
    
    //监听DataPicker的滚动
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [datePicker1 addTarget:self action:@selector(dateChange1:) forControlEvents:UIControlEventValueChanged];
    
    self.dateP = datePicker;
    
    //设置时间输入框的键盘框样式为时间选择器
    att.toWorkTextField.inputView = datePicker;
    att.offWorkTextField.inputView = datePicker1;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == att.toWorkTextField){
        [self dateChange:datePicker];
    }else if(textField == att.offWorkTextField){
        [self dateChange1:datePicker1];
    }
    
}

//点击当前视图, 结束编辑状态
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [att.toWorkTextField resignFirstResponder];
    [att.offWorkTextField resignFirstResponder];
}
//点击当前视图, 结束编辑状态
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(![att.toWorkTextField isExclusiveTouch]){
        [att.toWorkTextField resignFirstResponder];
    }
    if(![att.offWorkTextField isExclusiveTouch]){
        [att.offWorkTextField resignFirstResponder];
    }
}


- (void)dateChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"HH:mm";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    att.toWorkTextField.text = dateStr;
}
- (void)dateChange1:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"HH:mm";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    att.offWorkTextField.text = dateStr;
}

//禁止用户输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
/***************设置键盘为日期模式*******************/

/**********************左滑删除***********************/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //第二组可以左滑删除
    if(staffArr.count==0){
        return NO;
    }
    
    NSLog(@"%@",indexPath);
    if (indexPath.section == 1 && indexPath.row>=2) {
        NSInteger userId = [self->staffArr[indexPath.row-2][@"user_id"] integerValue];
        if(userId!=[UID integerValue] ){
             return YES;
        }
    }
    return NO;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//点击删除出现弹窗 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger userId = [self->staffArr[indexPath.row-2][@"user_id"] integerValue];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 1  && indexPath.row>1 && userId!=UID) {
            NSLog(@"%ld",indexPath.row);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了取消");
            }];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了确定");
                
                NSString *url = [NSString stringWithFormat:@"%@Admin/delStaff",HOSTURL];
                NSMutableDictionary *paramsDic = [NSMutableDictionary new];
                
                NSLog(@"%ld",userId);
                [paramsDic setObject:[NSString stringWithFormat:@"%ld",userId] forKey:@"user_id"];
                
                [HDAFNetWork GET:url params:paramsDic success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        if ([responseObject[@"code"] isEqualToString:@"1"]) {
                            [MBProgressHUD showTipMessageInWindow:@"删除成功！" timer:1  yOffset:SCREENHEIGHT/2-100 color:nil];
                            //弹框提示1秒后调用接口刷新数据
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1.0* NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                                
                                [self getAttandenceDataFromServer];
                                
                            });
                        }
                        [self.tableView reloadData];
                        
                    }
                } fail:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
            }];
            [alertController addAction:action];
            [alertController addAction:action1];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}



- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (self->editingIndexPath){
        [self configSwipeButtons];
    }
}

- (void)configSwipeButtons{
    // 获取选项按钮的reference
    if (@available(iOS 11.0, *)){
        
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        for (UIView *subview in self.tableView.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subview.subviews count] >= 1)
            {
                // 和iOS 10的按钮顺序相反
                
//                subview.backgroundColor = [UIColor redColor];
                UIButton *deleteButton = subview.subviews[0];
                [self configDeleteButton:deleteButton];
            }
        }
    }else{
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        StaffListTableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:self->editingIndexPath];
        for (UIView *subview in tableCell.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
            {
                UIView *confirmView = (UIView *)[subview.subviews firstObject];
                
                //改背景颜色
                
//                confirmView.backgroundColor = [UIColor redColor];
                
                for (UIView *sub in confirmView.subviews)
                {
                    //添加图片
                    if ([sub isKindOfClass:NSClassFromString(@"UIView")]) {
                        
                        UIView *deleteView = sub;
                        UIImageView *imageView = [[UIImageView alloc] init];
                        imageView.image = [UIImage imageNamed:@"address_cell_delete"];
                        [deleteView addSubview:imageView];
                        
                        //                        [imageView mas_makeConstraints:^ (MASConstraintMaker *make) {
                        //                            make.centerX.equalTo(deleteView);
                        //                            make.centerY.equalTo(deleteView);
                        //                        }];
                    }
                }
                break;
            }
        }
    }
}
- (void)configDeleteButton:(UIButton*)deleteButton{
    if (deleteButton) {
//        [deleteButton setBackgroundImage:[UIImage imageNamed:@"AppIcon"] forState:0];
        [deleteButton setImage:[UIImage imageNamed:@"AppIcon"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventAllTouchEvents];
    }
}


//按钮的点击操作
- (void)deleteAction:(UIButton *)sender{
    [self.view setNeedsLayout];
}


- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    self->editingIndexPath = indexPath;
    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self->editingIndexPath = nil;
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @" ";
}

/**********************左滑删除***********************/


@end
