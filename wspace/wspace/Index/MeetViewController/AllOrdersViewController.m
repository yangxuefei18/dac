//
//  AllOrdersViewController.m
//  wspace
//
//  Created by Hand02 on 2019/2/26.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "AllOrdersViewController.h"
#import "Common.h"
#import "AllOrdersTableViewCell.h"
#import "UIView+TYAlertView.h"
#import "HDAFNetWork.h"
#import "MBProgressHUD+JDragon.h"

@interface AllOrdersViewController ()<UITableViewDelegate,UITableViewDataSource>{
    Boolean cancle;
    NSMutableArray *dataList;
}

@end

@implementation AllOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cancle = YES;
    dataList = [NSMutableArray new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AllOrdersTableViewCell" bundle:nil] forCellReuseIdentifier:@"AllOrdersTableViewCell"];
    [self getList];
}
-(void)getList{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary new];
    NSString *url = [NSString stringWithFormat:@"%@Work/orderData",HOSTURL] ;
    [HDAFNetWork GET:url params:paramsDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] isEqualToString:@"1"]) {
                [self->dataList addObjectsFromArray:responseObject[@"data"]];
            }
            [_tableView reloadData];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
//点击取消按钮 弹出弹窗
-(void)cancleBtnClick:(UIButton *)btn{
    //三方的弹框
//    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"提示" message:[NSString stringWithFormat:@"会议室取消后不可恢复，是否确认取消？"]];
//    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
//
//    }]];
//    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
////        NSFileManager *fileManager = [NSFileManager defaultManager];
////        NSString *path=listArray[btn.tag][@"localPath"];
////        if ([fileManager removeItemAtPath:path error:nil]){
////            if ([db deleteDownloadFile:listArray[btn.tag][@"id"]]){
////                page = 0;
////                [listArray removeAllObjects];
////                [self getListData];
////            }
////        }
//    }]];
    
    //ios 自带弹框 适用于ios9以上
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"会议室取消后不可恢复，是否确认取消" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnullaction) {
        NSLog(@"点击了按钮1，进入按钮1的事件");
        [self cancelBtnFunction:btn];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)cancelBtnFunction:(UIButton *)cancelBtn{
    
    NSMutableDictionary *orderDic = [NSMutableDictionary dictionary];
    orderDic = [NSMutableDictionary dictionaryWithDictionary:dataList[cancelBtn.tag]];
    
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary new];
    [paramsDic setValue:[NSString stringWithFormat:@"%@",orderDic[@"id"] ] forKey:@"rr_id"];
    NSString *url = [NSString stringWithFormat:@"%@Work/cancelReservedRoom",HOSTURL] ;
    [HDAFNetWork GET:url params:paramsDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] isEqualToString:@"1"]) {
                [orderDic setValue:[NSString stringWithFormat:@"%d",2] forKey:@"status"];
                [self->dataList replaceObjectAtIndex:cancelBtn.tag withObject:orderDic];
                [MBProgressHUD showTipMessageInWindow:responseObject[@"msg"] yOffset:SCREENHEIGHT/2-100 color:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];

            }
            [self->_tableView reloadData];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


//几个单元，块
- (NSInteger)numberOfSectionsIntableView:(UITableView *)tableView {
    return 1;
    
}
//每个单元几个row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataList.count;
    
    
}
//每个row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
    
}




//每行的cell的属性
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //判断给的数据个数大于0！！！
    if (dataList.count > 0 && indexPath.row <= dataList.count) {
        NSMutableDictionary *orderInfo = [NSMutableDictionary new];
        orderInfo = dataList[indexPath.row];
            AllOrdersTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"AllOrdersTableViewCell" forIndexPath:indexPath];
        NSInteger oStatus = [orderInfo[@"status"] integerValue] ;
        cell.stateLabel.text = oStatus == 1?  @"已使用": (oStatus == 2? @"已取消":@"未使用") ;
            if(oStatus != 0){
                cell.cancleBtn.hidden = YES;
            }else{
                cell.cancleBtn.hidden = NO;
                //添加点击事件
                cell.cancleBtn.tag = indexPath.row;//[orderInfo[@"id"] integerValue] ;//按钮的参数
                [cell.cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.roomLabel.text = orderInfo[@"area_name"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@ hours", orderInfo[@"hour"]];//预定时间
            cell.inTimeLabel.text = [NSString stringWithFormat:@"%@ %@", orderInfo[@"date"],orderInfo[@"time"]];//预定时间段
            return cell;
//        }else{
//            AllOrdersTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"AllOrdersTableViewCell" forIndexPath:indexPath];
//            cell.stateLabel.text = @"待使用";
//            if(!cancle){
//                cell.cancleBtn.hidden = YES;
//            }else{
//                cell.cancleBtn.hidden = NO;
//                //添加点击事件
//                cell.cancleBtn.tag = 1;//按钮的参数
//                [cell.cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            }
//            cell.roomLabel.text =@"roo1";
//            cell.timeLabel.text = @"2 hours";//预定时间
//            cell.inTimeLabel.text = @"2019-2-1 23:00-1:00";//预定时间段
//            return cell;
//        }
    }
    return [UITableViewCell new];
    
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
