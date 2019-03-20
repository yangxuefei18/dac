//
//  PersonalViewController.m
//  wspace
//
//  Created by Hand02 on 2019/2/25.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "PersonalViewController.h"
#import "Common.h"
#import "PersonalInfoTableViewCell.h"
#import "AttendanceRecordViewController.h"
#import "ManageIndexViewController.h"

@interface PersonalViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
}

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //设置顶部
    [self setViewMarginTop];
    //设置头像
    _nameLabel.text = USERNAME;
    _emailLabel.text = EMAIL;
    _companyLabel.text = COMPANYNAME;
    _avatorImageView.layer.cornerRadius = _avatorImageView.frame.size.height/2;
    _avatorImageView.clipsToBounds = YES;
    _avatorImageView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalInfoTableViewCell"];
    // Do any additional setup after loading the view.
}

//几个单元，块
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//每个单元几个row 根据是不是管理员判断ISADMIN 0 用户 1 管理员
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([ISADMIN isEqualToString: @"0"]){
        return 6;
    }else{
        return 7;
    }
}

//每个row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 10;
    }else if (indexPath.row == 4){
        return 20;
    }else{
        return 50;
    }
}

//每行的cell的属性
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0|| indexPath.row==4){
        UITableViewCell *cell = [UITableViewCell new];
        cell.backgroundColor = [Common colorWithHexString:@"f8f8f8"];
        return cell;
    }else{
        PersonalInfoTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PersonalInfoTableViewCell" forIndexPath:indexPath];
        
        if(indexPath.row==1){
            cell.titleLabel.text = @"考勤记录";
        }else if (indexPath.row==2){
            cell.titleLabel.text = @"我的消费";
        }else if (indexPath.row==3){
            cell.titleLabel.text = @"邀请好友";
            cell.bottomLineView.hidden = YES;
        }else if (indexPath.row==5){
            if([ISADMIN isEqualToString: @"0"]){
                cell.titleLabel.text = @"设置";
            }else{
                cell.titleLabel.text = @"公司管理";
            }
        }else if (indexPath.row == 6){
            cell.titleLabel.text = @"设置";
            cell.bottomLineView.hidden = YES;
        }
        return cell;
    }
}

//在IndexPath中选择行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==1){
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
        AttendanceRecordViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"AttendanceRecordViewController"];
        vc.title = @"我的考勤";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==2){
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
        AttendanceRecordViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"AttendanceRecordViewController"];
        vc.title = @"我的消费";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==3){
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
        AttendanceRecordViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"AttendanceRecordViewController"];
        vc.title = @"邀请好友";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==5){
        if([ISADMIN isEqualToString:@"0"]){
            UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
            AttendanceRecordViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"AttendanceRecordViewController"];
            vc.title = @"设置";
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
            ManageIndexViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"ManageIndexViewController"];
            vc.title = @"公司管理";
            [self.navigationController pushViewController:vc animated:YES];
        }

    }else if (indexPath.row==6){
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
        AttendanceRecordViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"AttendanceRecordViewController"];
        vc.title = @"设置";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

///改变tabelView与屏幕的距离
-(void)setViewMarginTop{
    if (IS_IPHONE_X) {
        _InfoTopConstraint.constant = -44;
        _infoViewHeightCostraint.constant = 144;
    }else{
        _InfoTopConstraint.constant = -20;
        _infoViewHeightCostraint.constant = 120;
    }
}


//页面将要出现 隐藏标题栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

//页面将要消失 显示标题栏
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
