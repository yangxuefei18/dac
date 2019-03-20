//
//  ResourcesViewController.m
//  wspace
//
//  Created by 汉德 on 2019/2/14.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "ResourcesViewController.h"
#import "CoffeeTableViewCell.h"
#import "Common.h"
#import "Masonry.h"
#import "ImageScrollViewController.h"
#import "MBProgressHUD+JDragon.h"
#import "HDAFNetWork.h"

@interface ResourcesViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *scrollDataArr;
    ImageScrollViewController *scrollVC;
}

@end

@implementation ResourcesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollDataArr = [NSMutableArray new];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-kTabBarHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 175;// 需要给cell高度估计值，可以随便给，但不能不给
    [self.view addSubview: _tableView];
    [self.tableView registerClass:[CoffeeTableViewCell class] forCellReuseIdentifier:@"CoffeeTableViewCell"];
    [self getData:NO];
    // Do any additional setup after loading the view.
}

///视图将出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

///视图将消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//
//    self.tabBarController.tabBar.hidden = YES;
//    self.hidesBottomBarWhenPushed = YES;
}

//Section个数
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}


////每个cell行高
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}

//每个section里的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}
///cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        UITableViewCell *cell = [UITableViewCell new];
        scrollVC.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        [cell addSubview:scrollVC.view];
        cell.backgroundColor = [UIColor redColor];
        return cell;
    }
//    if(indexPath.row == 1 || indexPath.row == 2|| indexPath.row == 3){
//        CoffeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoffeeTableViewCell"];
//        // 100 0 50
//        if(indexPath.row == 1){ //60 0 50
//            [cell.redView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(60);
//            }];
//            cell.imgView.hidden = YES;
//        }else if(indexPath.row == 2){//100  0 50
//            [cell.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(cell.redView.mas_top).offset(30);
//            }];
//        }else{//100  100  50
//            [cell.greenView mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.height.mas_equalTo(100);
//            }];
//        }
//        return cell;
//    }
    UITableViewCell *cell = [UITableViewCell new];
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 100, 30)];
    l.text = [NSString stringWithFormat: @"%ld",indexPath.row] ;
    [cell addSubview:l];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
//将轮播图添加进来
-(void)addScrollImages{
    [self->scrollVC removeFromParentViewController];
    {
        NSMutableDictionary *edic = scrollDataArr[0];
        [scrollDataArr addObject:edic];
        
        NSMutableDictionary *fdic = scrollDataArr[scrollDataArr.count-2];
        [scrollDataArr insertObject:fdic atIndex:0];
    }
    self->scrollVC = [ImageScrollViewController new];
    self->scrollVC.aspectRatio = 507/735.0;
    self->scrollVC.layoutDataArray = self->scrollDataArr;
    [self addChildViewController:self->scrollVC];
}

///数据
-(void)getData:(BOOL)isOk{
    
    if(!isOk)
        [MBProgressHUD showActivityMessageInWindow:@"数据加载中..."];
    
    NSString *url = [NSString stringWithFormat:@"%@Index/index",HOSTURL];
    [HDAFNetWork GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if(!isOk)
                [MBProgressHUD hideHUD];
            
            if([responseObject[@"code"] isEqualToString:@"1"]){
                if (responseObject[@"data"] != NULL) {
                    
                    //将不可变数组转换为可变数组
                    NSMutableArray *res = [NSMutableArray array];
                    res = [NSMutableArray arrayWithArray:responseObject[@"data"][0][@"ad"]];
                    self->scrollDataArr = res;
                    if(res.count !=0){
                        [self addScrollImages];
                    }
                }
            }else{
                [MBProgressHUD showTipMessageInWindow:responseObject[@"msg"] timer:2 yOffset:SCREENHEIGHT/2-300 color:nil];
            }
            
            
            [self.tableView reloadData];
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
// Return NO if you do not want the specified item to be editable.
    return YES;
}



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     } else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }



 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }



 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }


@end
