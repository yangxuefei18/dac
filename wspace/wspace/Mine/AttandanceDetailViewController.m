//
//  AttandanceDetailViewController.m
//  wspace
//
//  Created by Hand02 on 2019/3/4.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "AttandanceDetailViewController.h"
#import "StaffTimeListTableViewCell.h"
#import "Common.h"
#import "AttenceView.h"
#import "AddStaffView.h"
#import "UIView+TYAlertView.h"
#import "MBProgressHUD+JDragon.h"
#import "HDAFNetWork.h"

@interface AttandanceDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *attList;
    int page;
    int size;
}

@end

@implementation AttandanceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    page = 0;
    size = 10;
    
    attList = [NSMutableArray new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StaffTimeListTableViewCell" bundle:nil] forCellReuseIdentifier:@"StaffTimeListTableViewCell"];
    [self getListDataFromServer];
    // Do any additional setup after loading the view.
}

// 获取页面数据 员工打卡详情数据
- (void)getListDataFromServer{
    [MBProgressHUD showActivityMessageInWindow:@"数据加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@Admin/recordDetail",HOSTURL];
    NSMutableDictionary *paramsDic = [NSMutableDictionary new];
    [paramsDic setObject:[NSString stringWithFormat:@"%d",size] forKey:@"size"];
    [paramsDic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
     [paramsDic setObject:_time forKey:@"date"];
    [HDAFNetWork GET:url params:paramsDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (responseObject[@"data"] != NULL) {
                self->attList = responseObject[@"data"];
            }
            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



//几个单元，块
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}
//每个单元几个row 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return attList.count;
}

//每个row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

//每行的cell的属性
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StaffTimeListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"StaffTimeListTableViewCell" forIndexPath:indexPath];
    if([attList[indexPath.row][@"name"] isKindOfClass:[NSString class]]){
        cell.nameLabel.text = attList[indexPath.row][@"name"];
    }else{
        cell.nameLabel.text = @"未知";
    }
    
    cell.amTime.text = attList[indexPath.row][@"onwork_time"];
    cell.pmTime.text = attList[indexPath.row][@"offwork_time"];
    return cell;
}

//在IndexPath中选择行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
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
