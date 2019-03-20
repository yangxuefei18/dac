//
//  IndexViewController.m
//  wspace
//
//  Created by 汉德 on 2019/2/12.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "ImageScrollViewController.h"
#import "IndexViewController.h"
#import "Common.h"
#import "NoVisitorTableViewCell.h"
#import "VisitTableViewCell.h"
#import "NoRecordTableViewCell.h"
#import "ScheduledMeetingTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "OpendoorViewController.h"
#import "ScheduledMeetingViewController.h"
#import "RequestVisitViewController.h"
#import "AllOrdersViewController.h"
#import "IndexCoffeeTableViewCell.h"
#import "HDAFNetWork.h"
#import "MeetTableViewCell.h"
#import "MBProgressHUD+JDragon.h"
#import "MJRefresh.h"
#import <UShareUI/UShareUI.h>

@interface IndexViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    //----  ----//
    UIScrollView *scrollView;
    ///多页控件
    NSString *moveState;//scrollview移动方向，值为left或right或keep
    NSTimer *aTimer;
    NSInteger currentPage;
    int allPage;
    
    BOOL adScrollViewLoaded;
    NSMutableArray *scrollDataArr;
    ImageScrollViewController *scrollVC;
    //----  ----//
    
    ///////
    NSMutableArray *meetArr;
    NSMutableArray *coffeeArr;
    NSMutableDictionary *visitorDic;
    ///////
}

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollDataArr = [NSMutableArray new];
    currentPage = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"IndexCoffeeTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndexCoffeeTableViewCell"];
    [self.tableView registerClass:[NoVisitorTableViewCell class] forCellReuseIdentifier:@"NoVisitorTableViewCell"];
    [self.tableView registerClass:[VisitTableViewCell class] forCellReuseIdentifier:@"VisitTableViewCell"];
    [self.tableView registerClass:[NoRecordTableViewCell class] forCellReuseIdentifier:@"NoRecordTableViewCell"];
    [self.tableView registerClass:[ScheduledMeetingTableViewCell class] forCellReuseIdentifier:@"ScheduledMeetingTableViewCell"];
    [self setTableViewMarginTop];
    self.tableView.dataSource = self;
    self.view.backgroundColor = [Common colorWithHexString:ControllBGColor];
    //self.tabBarController.tabBar.clipsToBounds = YES;
    [self getData:NO];
    [self addHeader];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadData" object:nil];
    
    ///////
    meetArr = [NSMutableArray new];
    coffeeArr = [NSMutableArray new];
    visitorDic = [NSMutableDictionary new];
    [self.tableView registerClass:[MeetTableViewCell class] forCellReuseIdentifier:@"MeetTableViewCell"];
    ///////
}
- (void)reloadData{
    self->coffeeArr = [NSMutableArray new];
    self->visitorDic = [NSMutableDictionary new];
    self->meetArr = [NSMutableArray new];
    self->scrollDataArr = [NSMutableArray new];
    [self getData:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//Section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
//每个section里的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }else if(section == 1){
        return 3;
    }else if(section == 2){
        if(meetArr.count>1){
            return 4;
        }
        return 3;
    }else if(section == 3){
        return 3+1;
    }
    return 8;
}

//每个cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        //轮播图开门邀请好友
        if(indexPath.row == 0){
            
            NSInteger btnWidth = (SCREENWIDTH - 15*2 - 10) / 2;
            NSLog(@"宽：%ld",btnWidth);
            NSInteger btnHeight = btnWidth/3*1.7;
            NSLog(@"高：%ld",btnHeight);
            return (SCREENWIDTH/735*507) + (btnHeight/2) ;
        }
    }else if(indexPath.section == 1){
        //即将到访
        if(indexPath.row == 0){
            return 42;
        }else if (indexPath.row == 1 && visitorDic.count>0){
            return 70;
        }
        return 48;
    }else if(indexPath.section == 2){
        //最近预定
        
        if(indexPath.row == 0){
            return 42;
        }else if (indexPath.row == 1 && meetArr.count>0){
            return 70;
        }
        if(meetArr.count>1){
            if(indexPath.row==2){
                return 70;
            }
        }
        
        return 48;
    }else if(indexPath.section == 3){
        //Coffee
        if(indexPath.row == 0){
            return 42;
        }
        if(indexPath.row == 1){
            
            return 128;
        }
        if(indexPath.row == 2){
            
            return 170;
        }
        if(indexPath.row == 3){
            
            return 264;
        }
        return 48;
    }
    return 48;
}

///cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = [Common colorWithHexString:CellBGColor];
    
    if(indexPath.section == 0){
        //轮播图,开门，邀请好友===============================================================================//
        if(indexPath.row == 0){
            //开门，邀请好友View的宽和高，因为轮播图的pageControl的位置计算需要用到，所以先放在这里
            NSInteger btnWidth = (SCREENWIDTH - 15*2 - 10) / 2;
            NSInteger btnHeight = btnWidth/3*1.7;
            
            int imageWidth =SCREENWIDTH;
            int imageHeight =SCREENWIDTH/735*507;
            
            scrollVC.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
            [cell addSubview:scrollVC.view];
            cell.clipsToBounds = YES;
            
            //开门
            UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(15, SCREENWIDTH/735*507-btnHeight/2, btnWidth, btnHeight)];
            leftView.layer.cornerRadius = 8;
            leftView.layer.masksToBounds = YES;
            leftView.backgroundColor = [UIColor greenColor];
            [cell addSubview:leftView];
            
            int smallImageWidth = 24;
            UIImageView *codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(btnWidth/2-smallImageWidth/2, btnHeight/2 - smallImageWidth, smallImageWidth, smallImageWidth)];
            [codeImageView sd_setImageWithURL:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550059862726&di=c375d44578eccb78a9ee6fe533dfd704&imgtype=0&src=http%3A%2F%2Fimg2.ph.126.net%2Fa2y-xiTvWlLXxz6KUA2wjg%3D%3D%2F6631475684512473803.jpg"];
            [leftView addSubview:codeImageView];
            
            UILabel *openDoorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnHeight/2 + 4, btnWidth, 24)];
            openDoorLabel.text = @"开门";
            openDoorLabel.font = [UIFont systemFontOfSize:17.0f];
            openDoorLabel.textAlignment = NSTextAlignmentCenter;
            [leftView addSubview: openDoorLabel];
            
            UIButton *openDoorBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
            [openDoorBtn addTarget:self action:@selector(openDoorBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [leftView addSubview:openDoorBtn];
            
            //邀请好友
            UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(15+btnWidth+10, SCREENWIDTH/735*507-btnHeight/2, btnWidth, btnHeight)];
            rightView.layer.cornerRadius = 8;
            rightView.layer.masksToBounds = YES;
            rightView.backgroundColor = [UIColor blueColor];
            [cell addSubview:rightView];
            
            UIImageView *friendImageView = [[UIImageView alloc]initWithFrame:CGRectMake(btnWidth/2-smallImageWidth/2, btnHeight/2 - smallImageWidth, smallImageWidth, smallImageWidth)];
            [friendImageView sd_setImageWithURL:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550059862726&di=c375d44578eccb78a9ee6fe533dfd704&imgtype=0&src=http%3A%2F%2Fimg2.ph.126.net%2Fa2y-xiTvWlLXxz6KUA2wjg%3D%3D%2F6631475684512473803.jpg"];
            [rightView addSubview:friendImageView];
            
            UILabel *friendLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnHeight/2 + 4, btnWidth, 24)];
            friendLabel.text = @"邀请好友";
            friendLabel.font = [UIFont systemFontOfSize:17.0f];
            friendLabel.textAlignment = NSTextAlignmentCenter;
            [rightView addSubview: friendLabel];
            
            UIButton *friendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
            [friendBtn addTarget:self action:@selector(friendBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [rightView addSubview:friendBtn];
            return cell;
        }
        //轮播图==end===================================//
    }else if(indexPath.section == 1){
        //即将到访----------------------------------------------------------//
        if(indexPath.row == 0){
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 11, 200, 28)];
            label.text = @"即将到访";
            label.textColor = [Common colorWithHexString:TMCOLOR];
            label.font = [UIFont systemFontOfSize:15.0f];
            [cell addSubview:label];
            return cell;
        }else if(indexPath.row == 1){
            if(visitorDic.count<1){
                NoVisitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoVisitorTableViewCell"];
                cell.backgroundColor = [Common colorWithHexString:CellBGColor];
                return cell;
            }else{
                MeetTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MeetTableViewCell"];
                cell.backgroundColor = [Common colorWithHexString:CellBGColor];
                cell.nameLabel.text = visitorDic[@"v_name"];
                cell.timeLabel.text = visitorDic[@"visit_time"];
                return cell;
            }
            
            //            NoVisitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoVisitorTableViewCell"];
            //            cell.backgroundColor = [Common colorWithHexString:CellBGColor];
            //            return cell;
        }else if(indexPath.row == 2){
            VisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VisitTableViewCell"];
            cell.backgroundColor = [Common colorWithHexString:CellBGColor];
            cell.visitLabel.text = @"全部访问";
            cell.rightLable.text =@"申请访问";
            [cell.visitBtn addTarget:self action:@selector(allVisitBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.rightBtn addTarget:self action:@selector(visitBtnClick) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        //即将到访--end------------------------------------------------------------------------------//
    }else if(indexPath.section == 2){
        //最近预定======================================================================================//
        if(indexPath.row == 0){
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 11, 200, 28)];
            label.text = @"最近预定";
            label.textColor = [Common colorWithHexString:TMCOLOR];
            label.font = [UIFont systemFontOfSize:15.0f];
            [cell addSubview:label];
            return cell;
        }else if(indexPath.row == 1){
            
            if(meetArr.count<1){
                NoVisitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoVisitorTableViewCell"];
                cell.backgroundColor = [Common colorWithHexString:CellBGColor];
                cell.noVisitorLabel.text = @"您没有预定记录";
                return cell;
            }else{
                MeetTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MeetTableViewCell"];
                cell.backgroundColor = [Common colorWithHexString:CellBGColor];
                cell.nameLabel.text = meetArr[0][@"area_name"];
                if(meetArr.count>1){
                    cell.line.hidden =YES;
                }else{
                    cell.line.hidden = NO;
                }
                NSString *time = [NSString stringWithFormat:@"%@ %@",meetArr[0][@"date"],meetArr[0][@"time"] ];
                cell.timeLabel.text = time;
                return cell;
            }
            
        }else if(indexPath.row == 2){
            if(meetArr.count>1){
                UITableViewCell *cell = [UITableViewCell new];
                cell.backgroundColor = [Common colorWithHexString:CellBGColor];
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(16, 0, SCREENWIDTH-16*2, 70)];
                view.backgroundColor = [UIColor whiteColor];
                [cell addSubview:view];
                
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 5, view.frame.size.width,34)];
                nameLabel.font = [UIFont systemFontOfSize:15];
                [view addSubview:nameLabel];
                nameLabel.text = meetArr[1][@"area_name"];
                
                NSString *time = [NSString stringWithFormat:@"%@ %@",meetArr[1][@"date"],meetArr[1][@"time"] ];
                UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 35, view.frame.size.width,34)];
                timeLabel.font = [UIFont systemFontOfSize:15];
                timeLabel.text = time;
                [view addSubview:timeLabel];
                
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(6, 69, view.frame.size.width-12, 1)];
                line.backgroundColor = [Common colorWithHexString:LINECOLOR];
                [view addSubview:line];
                return cell;
                
            }else{
                VisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VisitTableViewCell"];
                cell.backgroundColor = [Common colorWithHexString:CellBGColor];
                cell.visitLabel.text = @"全部预定";
                cell.rightLable.text =@"预定会议";
                [cell.visitBtn addTarget:self action:@selector(allMeetingBtnBClick) forControlEvents:UIControlEventTouchUpInside];
                [cell.rightBtn addTarget:self action:@selector(meetingBtnBClick) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            
        }else if(indexPath.row == 3){
            VisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VisitTableViewCell"];
            cell.backgroundColor = [Common colorWithHexString:CellBGColor];
            cell.visitLabel.text = @"全部预定";
            cell.rightLable.text =@"预定会议";
            [cell.visitBtn addTarget:self action:@selector(allMeetingBtnBClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.rightBtn addTarget:self action:@selector(meetingBtnBClick) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        return cell;
        //最近预定--end====================================//
    }else if(indexPath.section == 3){
        //================== Coffee    ==================//
        if(indexPath.row == 0){
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 11, 200, 28)];
            label.text = @"Coffee";
            label.textColor = [Common colorWithHexString:TMCOLOR];
            label.font = [UIFont systemFontOfSize:15.0f];
            [cell addSubview:label];
            return cell;
        }
        IndexCoffeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndexCoffeeTableViewCell"];
        
        cell.backgroundColor = [Common colorWithHexString:CellBGColor];
        if(indexPath.row == 1){
            cell.type = 0;// 0 无
            //            cell.backgroundColor = [UIColor blueColor];
            return cell;
        }else if(indexPath.row == 2){
            cell.type = 2;// 2 一个订单
            //            cell.backgroundColor = [UIColor greenColor];
            return cell;
        }else if(indexPath.row == 3){
            cell.type = 1;// 1 两个订单
            //            cell.backgroundColor = [UIColor redColor];
            return cell;
        }
        return [UITableViewCell new];
        //================== Coffee end ==================//
    }
    return cell;
}

///开门按钮
-(void)openDoorBtnClick{
    NSLog(@"开门");
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Index" bundle:nil];
    OpendoorViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"OpendoorViewController"];
    vc.title = @"开门";
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

///邀请好友按钮
-(void)friendBtnClick{
    NSLog(@"邀请好友");
    [self share_ui];
}

///全部访问
-(void)allVisitBtnClick{
    NSLog(@"全部访问");
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Index" bundle:nil];
    AllOrdersViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"AllOrdersViewController"];
    vc.title = @"全部访问";
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)share_ui{
    [UMSocialUIManager setPreDefinePlatforms:@[@(16),@(17),@(1)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareTextToPlatformType:platformType];
    }];
}


- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    UMSocialManager *f = [UMSocialManager defaultManager];
    if([f isInstall:platformType]){
        NSLog(@"已安装");
    }else{
        NSLog(@"未安装");
    }
//    return;
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = @"社会化组件UShare将各大社交平台接入您的应用，快速武装App。";
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}


///申请访问按钮
-(void)visitBtnClick{
    NSLog(@"申请访问");
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Index" bundle:nil];
    RequestVisitViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"RequestVisitViewController"];
    vc.title = @"申请访问";
    
    [self.navigationController pushViewController:vc animated:YES];
}

///全部预定会议室
-(void)allMeetingBtnBClick{
    NSLog(@"全部预定会议室");
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Index" bundle:nil];
    AllOrdersViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"AllOrdersViewController"];
    vc.title = @"全部预定";
    [self.navigationController pushViewController:vc animated:YES];
}

///预定会议按钮
-(void)meetingBtnBClick{
    NSLog(@"预定会议");
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Index" bundle:nil];
    ScheduledMeetingViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"ScheduledMeetingViewController"];
    vc.title = @"预定会议";
    
    [self.navigationController pushViewController:vc animated:YES];
}

///改变tabelView与屏幕的距离
-(void)setTableViewMarginTop{
    if (IS_IPHONE_X) {
        _tableViewMarginTop.constant = -44;
    }else{
        _tableViewMarginTop.constant = -20;
    }
}


//轮播图相关一些方法end------------------------------------------------------------------------//
////
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
                    self->coffeeArr = responseObject[@"data"][0][@"coffee"];
                    self->visitorDic = responseObject[@"data"][0][@"visit"];
                    self->meetArr = responseObject[@"data"][0][@"meet"];
                    
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

//  下拉刷新
- (void)addHeader {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->coffeeArr = [NSMutableArray new];
        self->visitorDic = [NSMutableDictionary new];
        self->meetArr = [NSMutableArray new];
        self->scrollDataArr = [NSMutableArray new];
        [self getData:NO];
        [self.tableView.mj_header endRefreshing];
    }];
    // Set title
    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    // Set font
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // Set textColor
    header.stateLabel.textColor = [UIColor redColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    self.tableView.mj_header = header;
}
@end
