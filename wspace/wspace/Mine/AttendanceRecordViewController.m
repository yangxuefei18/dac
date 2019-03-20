//
//  AttendanceRecordViewController.m
//  wspace
//
//  Created by Hand02 on 2019/2/25.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "AttendanceRecordViewController.h"
#import "PersonalInfoTableViewCell.h"
#import "Common.h"
#import "AppDelegate.h"

@interface AttendanceRecordViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@end

@implementation AttendanceRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalInfoTableViewCell"];
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
//几个单元，块
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//每个单元几个row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
///cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonalInfoTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PersonalInfoTableViewCell" forIndexPath:indexPath];
    
    if(indexPath.row==0){
        cell.titleLabel.text = @"退出登录";
    }
    return cell;
}
//在IndexPath中选择行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0)
        [((AppDelegate *)[UIApplication sharedApplication].delegate) enterLoginView];
    
}
@end
