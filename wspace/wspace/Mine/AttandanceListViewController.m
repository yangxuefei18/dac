//
//  AttandanceListViewController.m
//  wspace
//
//  Created by Hand02 on 2019/3/4.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "AttandanceListViewController.h"
#import "AttanceListTableViewCell.h"
#import "AttandanceDetailViewController.h"
#import "Common.h"
#import "AttenceView.h"
#import "AddStaffView.h"
#import "UIView+TYAlertView.h"
#import "MBProgressHUD+JDragon.h"
#import "HDAFNetWork.h"

@interface AttandanceListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *attList;
    int page;
    int size;
    NSArray *weekArr;
}

@end

@implementation AttandanceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    attList = [NSMutableArray new];
    page = 0;
    size = 10;
    weekArr = [NSArray arrayWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AttanceListTableViewCell" bundle:nil] forCellReuseIdentifier:@"AttanceListTableViewCell"];
    [self getListDataFromServer];
}

// 获取页面数据 员工打卡列表数据
- (void)getListDataFromServer{
    [MBProgressHUD showActivityMessageInWindow:@"数据加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@Admin/recordList",HOSTURL];
    NSMutableDictionary *paramsDic = [NSMutableDictionary new];
    [paramsDic setObject:[NSString stringWithFormat:@"%d",size] forKey:@"size"];
    [paramsDic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    
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
    return 50;
    
}




//每行的cell的属性
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger day = [attList[indexPath.row][@"week"] integerValue] ;
    NSString  *week = weekArr[day];
    NSLog(@"%@",week);
    AttanceListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"AttanceListTableViewCell" forIndexPath:indexPath];
    cell.timeLabel.text = attList[indexPath.row][@"change_time"];
    cell.weekLabel.text = week;
    return cell;
}

//在IndexPath中选择行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
        AttandanceDetailViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"AttandanceDetailViewController"];
        vc.title = attList[indexPath.row][@"change_time"];
        vc.time = attList[indexPath.row][@"change_time"];
       [self.navigationController pushViewController:vc animated:YES];
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
