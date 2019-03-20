//
//  ScheduledMeetingViewController.m
//  wspace
//  预定会议main
//  Created by 汉德 on 2019/2/19.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "ScheduledMeetingViewController.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+JDragon.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "HDAFNetWork.h"
#import "UIView+DCAnimationKit.h"
#import "ScheduledSuccessViewController.h"
#import "HDAFNetWork.h"
static UIButton *lastBtn;
static UIButton *dayBtn;
@interface ScheduledMeetingViewController ()<UIScrollViewDelegate>{
  
    NSString *surplusLableText;
    UIView *backView;
    ///后四天/前四天
    UILabel *nextFourDaysLabel;
    ///日期scrollView
    UIScrollView *scrollView;
    ///scrollView的宽
    int scrollViewW;
    ///日期选择视图的高度
    int dateSelectionViewH;
    int dateSelectionViewW;
    UIImageView *rightImageView;
    UIImageView *leftImageView;
    ///
    CGRect mainViewRect;
    int showDays;
    float timeScrollViewW;
    //底部已选View
    UIView *selectedView;
    int selectedItemX;
    UIScrollView *timeScrollView;
    NSMutableArray *roomList;
    
    //存放准备提交的数据
    NSMutableDictionary *selectedData;
    //时刻表
    NSMutableArray *scrollDataArr;
    //存放选择的会议室

    //选择的会议室信息
    NSMutableDictionary *clickRoomData;
    //存放选择的时间段
    NSMutableArray *timeViewArr;
    //临时存放当前房间下的时间段
    NSMutableArray *tempTimeArr;
    //年月日
    NSMutableArray *dayArr;
    
}

@end
//预定会议///
@implementation ScheduledMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dayArr = [NSMutableArray new];
    clickRoomData = [NSMutableDictionary new];
    [clickRoomData setValue:[NSString stringWithFormat:@"%d",0] forKey:@"roomId"];
    roomList = [NSMutableArray new];
    timeViewArr = [NSMutableArray new];
    scrollDataArr = [NSMutableArray new];
    selectedData = [NSMutableDictionary new];
    tempTimeArr = [NSMutableArray new];
    showDays = 12;
    [self initView];
    [self getList];
}

-(void)initView{
    int marginTopHeight = MarginTopHeight;
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, marginTopHeight, SCREENWIDTH, SCREENHEIGHT-64)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(MarginLR, 14, 300, 35)];
    topLable.text = @"本月余量";
    topLable.font = [UIFont systemFontOfSize:15.0f];
    [topLable sizeToFit];
    [backView addSubview:topLable];
    
    UILabel *surplusLable = [[UILabel alloc]initWithFrame:CGRectMake(MarginLR+topLable.frame.size.width, 14, 100, 35)];
    surplusLableText = @"1";
    surplusLable.text = [NSString stringWithFormat:@"%@小时", surplusLableText];
    surplusLable.font = [UIFont systemFontOfSize:15.0f];
    surplusLable.textColor = [UIColor redColor];
    [surplusLable sizeToFit];
    [backView addSubview:surplusLable];
    
    
    dateSelectionViewW = SCREENWIDTH-MarginLR*2.0;
    dateSelectionViewH = dateSelectionViewW/694.0*77.0;
    
    UIView *dateSelectionView = [[UIView alloc]initWithFrame:CGRectMake(MarginLR, topLable.frame.origin.y+topLable.frame.size.height+20, dateSelectionViewW, dateSelectionViewH)];
    [backView addSubview:dateSelectionView];
    
    
    int LRBtnW = dateSelectionViewW/5-(dateSelectionViewW/5)/2;
    scrollViewW = dateSelectionViewW/5*4;
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(LRBtnW, 0, scrollViewW, dateSelectionViewH)];
    scrollView.tag = 1;
    scrollView.delegate = self;
    //横竖两种滚轮都不显示
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    //需要分页
    scrollView.pagingEnabled = YES;
    //设置ScrollView内容
    [self setScrollView:[UIButton new]];
    
    int c = showDays % 4;
    c = showDays / 4 + (c != 0? 1:0);
    
    scrollView.contentSize = CGSizeMake(scrollViewW * c, 0);
    [dateSelectionView addSubview: scrollView];
    [ scrollView shake:NULL];//动画
    ///后四天
    UIView *nextFourDaysView = [[UIView alloc]initWithFrame:CGRectMake(dateSelectionViewW-LRBtnW, 0, LRBtnW, dateSelectionViewH)];
    [dateSelectionView addSubview:nextFourDaysView];
    rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(nextFourDaysView.frame.size.width/2, 0, nextFourDaysView.frame.size.width/2, nextFourDaysView.frame.size.height)];
    rightImageView.image = [UIImage imageNamed:showDays > 4? @"cell_right":@"cell_right_no"];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [nextFourDaysView addSubview:rightImageView];
    UIButton *nextFourDaysBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, nextFourDaysView.frame.size.width, nextFourDaysView.frame.size.height)];
    [nextFourDaysBtn addTarget:self action:@selector(nextFourDaysBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextFourDaysView addSubview:nextFourDaysBtn];
    
    ///前四天
    UIView *beforeFourDaysView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LRBtnW, dateSelectionViewH)];
    [dateSelectionView addSubview:beforeFourDaysView];
    leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, beforeFourDaysView.frame.size.width/2, beforeFourDaysView.frame.size.height)];
    leftImageView.image = [UIImage imageNamed:@"cell_left_no"];
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [beforeFourDaysView addSubview:leftImageView];
    UIButton *beforeFourDaysBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, beforeFourDaysView.frame.size.width, beforeFourDaysView.frame.size.height)];
    beforeFourDaysBtn.tag = 1;
    [beforeFourDaysBtn addTarget:self action:@selector(nextFourDaysBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [beforeFourDaysView addSubview:beforeFourDaysBtn];
    
    //中间方框
    mainViewRect = CGRectMake(dateSelectionView.frame.origin.x, dateSelectionView.frame.origin.y+dateSelectionView.frame.size.height+2, dateSelectionView.frame.size.width,  backView.frame.size.height/804*460 );
    
    //底部已选View
    selectedView = [[UIView alloc]initWithFrame:CGRectMake(MarginLR, mainViewRect.origin.y+mainViewRect.size.height +12, SCREENWIDTH-MarginLR*2, 90)];
    [backView addSubview:selectedView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, 50, 20)];
    titleLabel.text = @"已选：";
    [titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
    //关键语句
    CGSize expectSize = [titleLabel sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    titleLabel.frame = CGRectMake(0, 3, expectSize.width, expectSize.height);
    selectedItemX = titleLabel.frame.size.width + 12;
    [selectedView addSubview:titleLabel];
    
    ///提交按钮
    UIButton *subBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREENWIDTH-80)/2, selectedView.frame.origin.y+selectedView.frame.size.height + 12, 80, 44)];
    subBtn.backgroundColor = [UIColor redColor];
    [subBtn setTitle:@"提交" forState:0];
    [subBtn addTarget:self action:@selector(submissionData) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:subBtn];
}

///1.渲染日期ScrollView
-(void)setScrollView:(UIButton *) btn{
    UIView *item;
    UILabel *dateLabel;
    UILabel *weekLabel;
    UIButton *dateBtn;
    
    for (int i = 0;i < showDays; i++) {
        NSString *dateLabelText =[Common getTimeAfterNowWithDay:i formatter:@"yyyy-MM-dd"];
        [dayArr addObject:dateLabelText];
        item = [[UIView alloc]initWithFrame:CGRectMake(scrollViewW/4 * i, 0, scrollViewW/4, dateSelectionViewH)];
        item.backgroundColor = [Common colorWithHexString:@"f8f8f8"];
        [scrollView addSubview:item];
        double dataLabelW = item.frame.size.width;
        double dataLabelH = item.frame.size.height/2.0;
        ///按钮
        dateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, dataLabelW, dateSelectionViewH)];
        dateBtn.tag = i;
        dateBtn.layer.cornerRadius = 2;
        dateBtn.clipsToBounds = YES;
        dateBtn.layer.borderWidth = 0.5;
        [dateBtn addTarget:self action:@selector(clickDays:) forControlEvents:UIControlEventTouchUpInside];
        [item addSubview:dateBtn];
        if(i == 0){//选中
            dateBtn.layer.borderColor = [[Common colorWithHexString:@"000000"] CGColor ];
            [dateBtn setBackgroundColor:[UIColor whiteColor]];
            dayBtn =dateBtn;
            [selectedData setValue:dateLabelText forKey:@"day"];
            ///Today
            dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, dataLabelW, dataLabelH*2)];
            dateLabel.text = @"Today";
            dateLabel.textAlignment = NSTextAlignmentCenter;
            dateLabel.font = [UIFont systemFontOfSize:15.0f];
            [item addSubview:dateLabel];
            [selectedData setValue:dateLabelText forKey:@"day"];
        }else{//未选中
            dateBtn.layer.borderColor = [[Common colorWithHexString:@"d8d8d8"] CGColor ];
            [dateBtn setBackgroundColor:[Common colorWithHexString:@"f8f8f8"]];
            ///月日
            dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, dataLabelW, dataLabelH+2)];
            NSArray  *array = [dateLabelText componentsSeparatedByString:@"-"];
            dateLabel.text = [NSString stringWithFormat:@"%@.%@",array[1],array[2]];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            dateLabel.font = [UIFont systemFontOfSize:12.0f];
            [item addSubview:dateLabel];
            ///周几
            weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, dataLabelH, dataLabelW, dataLabelH-2)];
            weekLabel.text =[[Common getTimeAfterNowWithDay:i formatter:@"EEEE"] substringToIndex:3];// [Common getWeekDayFordate:a nextDays:i];
            weekLabel.textAlignment = NSTextAlignmentCenter;
            weekLabel.font = [UIFont systemFontOfSize:12.0f];
            [item addSubview:weekLabel];
        }
    }
}

///2.渲染中间区域会议室，时间scrollView
-(int)setMainView:(CGRect)rect{
    UIView *mainView = [[UIView alloc]initWithFrame:rect];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.layer.cornerRadius = 4;
    mainView.clipsToBounds = YES;
    mainView.layer.borderWidth = 0.5;
    mainView.layer.borderColor = [[Common colorWithHexString:@"d8d8d8"] CGColor ];
    [backView addSubview:mainView];
    
    //设置会议室按钮
    int nextMeetingRoomBtnY = [self setMeetingRoomBtn:mainView];
    //设置时间选择ScrollView
    [self setTimeScrollView:nextMeetingRoomBtnY supView:mainView];
    
    return rect.origin.y+rect.size.height;
    
}

///2.1在 mainView 上渲染 会议室 按钮
-(int)setMeetingRoomBtn:(UIView *)mainView{
    for (UIView *tempView in mainView.subviews) {
        [tempView removeFromSuperview];
    }
    int roomLabelW = 120;int roomLabelH = 20;int roomLabelY = 16;
    int roomLabelLX = ((mainView.frame.size.width/2)-roomLabelW)/2;
    int roomLabelRX = (mainView.frame.size.width/2)+((mainView.frame.size.width/2)-roomLabelW)/2;

    for (int i = 0; i<roomList.count; i++) {
        UIButton *roomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [roomBtn setTitle:[NSString stringWithFormat:@"%@", roomList[i][@"area_name"] ] forState:0];
        roomBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        roomBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        [roomBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        roomBtn.tag = [roomList[i][@"area_id"] intValue];
        [roomBtn addTarget:self action:@selector(selectMeetingRoom:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:roomBtn];
        if(i % 2 == 0 ){//左按钮
            roomBtn.frame =CGRectMake(roomLabelLX+8, roomLabelY, roomLabelW, roomLabelH);
            roomLabelY = i == roomList.count-1? roomLabelY+roomLabelH+12 : roomLabelY;//最后行
        }else{//右按钮
            roomBtn.frame = CGRectMake(roomLabelRX-8, roomLabelY, roomLabelW, roomLabelH);
            roomLabelY += roomLabelH+12;//换行
        }
        if(i==0){
            [roomBtn setTitleColor:[Common colorWithHexString:@"317ee7"] forState:UIControlStateNormal];
            [clickRoomData setValue:[NSString stringWithFormat:@"%ld",roomBtn.tag ] forKey:@"roomId"];
            [clickRoomData setValue:roomList[i][@"area_name"] forKey:@"roomName"];
            
            lastBtn = roomBtn;
        }
        
    }
    return roomLabelY;
}

///2.2渲染时间选择scrollView
-(void)setTimeScrollView:(int)nextMeetingRoomBtnY supView:(UIView *)mainView{
    timeScrollViewW = mainView.frame.size.width/430*222;
    timeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake((mainView.frame.size.width - timeScrollViewW)/2, nextMeetingRoomBtnY+8, timeScrollViewW, mainView.frame.size.height/423*240 )];//timeScrollViewW/222.0*245)];
    timeScrollView.tag = 2;
    timeScrollView.layer.cornerRadius = 2;
    timeScrollView.clipsToBounds = YES;
    timeScrollView.layer.borderWidth = 0.5;
    timeScrollView.layer.borderColor = [[Common colorWithHexString:@"d8d8d8"] CGColor ];
    //横竖两种滚轮都不显示
    timeScrollView.showsVerticalScrollIndicator = NO;
    timeScrollView.showsHorizontalScrollIndicator = NO;
    //需要分页
    timeScrollView.pagingEnabled = NO;
    timeScrollView.delegate = self;
    
    //渲染cell
    [self setTimeScrollViewData:timeScrollViewW];
    
    [mainView addSubview:timeScrollView];
    [ timeScrollView bounceIntoView:mainView direction: DCAnimationDirectionTop];//动画
}

///2.2.1 渲染时间选择scrollView的数据
-(void)setTimeScrollViewData:(int)timeBtnW{
    [timeScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger times = scrollDataArr.count;int timeBtnH = 32;
    UILabel *timeLable;
    UILabel *statusLable;
    UIButton *timeBtn;
    for (int i = 0; i<times; i++) {
        ///
        timeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*timeBtnH, timeBtnW, timeBtnH)];
        timeBtn.tag = i;
        timeBtn.clipsToBounds = YES;
        timeBtn.layer.borderWidth = 0.5;
        timeBtn.layer.borderColor = [[Common colorWithHexString:@"d8d8d8"] CGColor ];
        timeBtn.backgroundColor = [[NSString stringWithFormat:@"%@",scrollDataArr[i][@"status"]] isEqualToString:@"free"] ? [Common colorWithHexString:@"73ddce"] : [Common colorWithHexString:@"fe7353"];
        [timeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        
        //--- 如果是已选的，按钮改为已选状态 b ---//
        if (timeViewArr.count == 1 && [timeViewArr[0][@"room_id"] isEqualToString:clickRoomData[@"roomId"]] &&[ timeViewArr[0][@"btn_tag"] integerValue] == i) {
            timeBtn.selected = YES;
            timeBtn.backgroundColor = [Common colorWithHexString:@"fe7353"];
        }else if (timeViewArr.count == 2 ) {
            for (int j = 0; j < timeViewArr.count; j++) {
                if ([timeViewArr[j][@"room_id"] isEqualToString:clickRoomData[@"roomId"]] &&[ timeViewArr[j][@"btn_tag"] integerValue] == i) {
                    timeBtn.selected = YES;
                    timeBtn.backgroundColor = [Common colorWithHexString:@"fe7353"];
                }
            }
        }
        //--- 如果是已选的，按钮改为已选状态 e ---//
        
        [timeScrollView addSubview:timeBtn];
        ///
        timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, i*timeBtnH, timeBtnW - 50, timeBtnH)];
        timeLable.text = [NSString stringWithFormat:@"%@",scrollDataArr[i][@"time"]];
        timeLable.font = [UIFont systemFontOfSize:14.0f];
        timeLable.textAlignment = NSTextAlignmentCenter;
        [timeScrollView addSubview:timeLable];
        ///
        statusLable = [[UILabel alloc] initWithFrame:CGRectMake(timeBtnW - 60, i*timeBtnH, 60, timeBtnH)];
        statusLable.text = [NSString stringWithFormat:@"%@",scrollDataArr[i][@"status"]];
        statusLable.font = [UIFont systemFontOfSize:14.0f];
        [timeScrollView addSubview:statusLable];
    }
    
    timeScrollView.contentSize = CGSizeMake(0, times * timeBtnH);
    //定位到当前时间的下一个小时
    int nowH = [[Common getTimeAfterNowWithDay:0 formatter:@"HH"] intValue];
    CGPoint point = timeScrollView.contentOffset;
    point.y = timeBtnH * (nowH+1);
    timeScrollView.contentOffset = point;
}

///3.渲染已选项
- (void)setSelectedView{
    for (UIView *tempView in selectedView.subviews) {
        if(tempView.frame.origin.x !=0){
            [tempView removeFromSuperview];
        }
    }
    int itemH = 26;int itemW = SCREENWIDTH- MarginLR*2 - selectedItemX;
    for (int i = 0; i < timeViewArr.count; i++) {
        UIView *selectItemView = [[UIView alloc]initWithFrame:CGRectMake(selectedItemX, i * (itemH+0), itemW, itemH)];
        selectItemView.backgroundColor = [UIColor redColor];
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, itemW - itemH*2, itemH)];
        NSArray  *array = [selectedData[@"day"] componentsSeparatedByString:@"-"];
        NSString *tempDate =[NSString stringWithFormat:@"%@.%@ %@ %@",array[1],array[2],timeViewArr[i][@"time"],timeViewArr[i][@"room_name"]];
        textLabel.text = tempDate;
        [textLabel setFont:[UIFont systemFontOfSize:14.0f]];
        textLabel.backgroundColor = [UIColor greenColor];
//        CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
//        CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];//关键语句
//        textLabel.frame = CGRectMake(0, 2, expectSize.width, expectSize.height);//别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
        [selectItemView addSubview: textLabel];
        
        UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(itemW - itemH*2, 0, itemH*2-2, itemH)];
        
        [delBtn setImage:[Common scaleToSize:[UIImage imageNamed:@"delSelectedBtn"] size:CGSizeMake(15, 15)] forState:0];
        delBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        delBtn.tag = i;
        [delBtn addTarget:self action:@selector(delSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
        [selectItemView addSubview:delBtn];
        [selectedView addSubview:selectItemView];
    }
    selectedView.backgroundColor = [UIColor orangeColor];
}


//**************************相应事件***************************//
///左右四天点击事件
-(void)nextFourDaysBtnClick:(UIButton *)btn{
    
    int days = showDays;
    int a = days / 4;//2
    a = days % 4 == 0? a:a+1; //a = 3
    
    //当前显示是否是最后一个或者第一个
    int scrollViewX = scrollView.contentOffset.x;
    if (scrollViewX  == (int)scrollViewW*(a-1) && btn.tag != 1) return;
    if (scrollViewX  == 0 && btn.tag == 1) return;
    
    //调整位置
    CGPoint point = scrollView.contentOffset;
    if(btn.tag == 1){
        rightImageView.image = [UIImage imageNamed:@"cell_right"];
        point.x -= (int)scrollViewW;
    }else{
        leftImageView.image = [UIImage imageNamed:@"cell_left"];
        point.x += (int)scrollViewW;
    }
    [UIView animateWithDuration:.5 animations:^{
        scrollView.contentOffset = point;
    }];
    
    //调整位置之后，是否是最后一个或者第一个 是：换图
    if (scrollView.contentOffset.x  == (int)scrollViewW*(a-1) && btn.tag != 1){// crollDataArr.count
        rightImageView.image = [UIImage imageNamed:@"cell_right_no"];
    }
    if (scrollView.contentOffset.x  == 0 && btn.tag == 1){// crollDataArr.count
         leftImageView.image = [UIImage imageNamed:@"cell_left_no"];
    }
    
    
}

///左右滑动日期
#pragma mark - ScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView.tag == 1){
        //page : 总页数
        int pages = showDays / 4;//2
        pages = showDays % 4 == 0? pages:pages+1; //a = 3
        //
        if (scrollView.contentOffset.x == 0){
            leftImageView.image = [UIImage imageNamed:@"cell_left_no"];
            rightImageView.image = [UIImage imageNamed:@"cell_right"];
        }else if(scrollView.contentOffset.x == (pages-1) * scrollViewW){
            leftImageView.image = [UIImage imageNamed:@"cell_left"];
            rightImageView.image = [UIImage imageNamed:@"cell_right_no"];
        }else{
            leftImageView.image = [UIImage imageNamed:@"cell_left"];
            rightImageView.image = [UIImage imageNamed:@"cell_right"];
        }
    }
    
}

///点击天
-(void)clickDays:(UIButton *)btn{
    
    if (dayBtn != btn) {
        //选中
        btn.layer.borderColor = [[Common colorWithHexString:@"000000"] CGColor ];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [selectedData setValue:dayArr[btn.tag] forKey:@"day"];
        //未选中
        dayBtn.layer.borderColor = [[Common colorWithHexString:@"d8d8d8"] CGColor ];
        [dayBtn setBackgroundColor:[Common colorWithHexString:@"f8f8f8"]];
        dayBtn = btn;
        
        timeViewArr = [NSMutableArray new];
        [self setSelectedView];
        [self getList];
    }
    
}

///选择会议室事件
-(void)selectMeetingRoom:(UIButton *)btn{
    
    
    
    if (lastBtn != btn) {
        //切换日期时，清空已选时间段
        [self clearTimeData];
        [clickRoomData setValue:[NSString stringWithFormat:@"%ld",btn.tag ] forKey:@"roomId"];
        [clickRoomData setValue:[NSString stringWithFormat:@"%@",btn.titleLabel.text ] forKey:@"roomName"];
        //选中
        [btn setTitleColor:[Common colorWithHexString:@"317ee7"] forState:UIControlStateNormal];
        
        //未选中
        [lastBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        lastBtn = btn;
    }
    [self getList];
}

///选择时间事件
-(void)selectTime:(UIButton *)btn{
   
    if( ![scrollDataArr[btn.tag][@"status"] isEqualToString:@"free"]){
        return;
    }
    if( [clickRoomData[@"roomId"] isEqualToString:@""] ){
        [MBProgressHUD showTipMessageInWindow:@"请选择会议室"];
        return;
    }
    if(btn.selected){//已选改未选择
        

        
        for(int i=0;i<timeViewArr.count;i++){
            if([timeViewArr[i][@"btn_tag"] intValue] == btn.tag && [timeViewArr[i][@"room_id"] isEqualToString:clickRoomData[@"roomId"]] ) {
                [timeViewArr removeObjectAtIndex:i];
                break;
            }
        }
        
        btn.backgroundColor = [Common colorWithHexString:@"73ddce"];
        btn.selected = NO;
        [self setSelectedView];
    }else{//未选改已选择
        
        if(timeViewArr.count < 2){
            BOOL ok = NO;
            if(timeViewArr.count == 1 && timeViewArr[0][@"room_id"] != clickRoomData[@"roomId"]){
                //已经选择了一个 并且 换了一个会议室
                ok =YES;
            }else if(timeViewArr.count == 0 || [timeViewArr[0][@"time"] intValue] + 1 == btn.tag || [timeViewArr[0][@"time"] intValue] - 1 == btn.tag){
                //如果还未选择任何一个时间段 或者 本次选的与上次选的是相邻的
                ok = YES;
            }
            if(ok){
                NSMutableDictionary *tempDic = [NSMutableDictionary new];
                
                [tempDic setValue:[NSString stringWithFormat:@"%ld", btn.tag] forKey:@"btn_tag"];
                [tempDic setValue:[NSString stringWithFormat:@"%@", clickRoomData[@"roomId"]] forKey:@"room_id"];
                [tempDic setValue:[NSString stringWithFormat:@"%@", clickRoomData[@"roomName"]] forKey:@"room_name"];
                [tempDic setValue:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@",scrollDataArr[btn.tag][@"time"]]] forKey:@"time"];
                [timeViewArr addObject:tempDic];
                NSLog(@"%@",timeViewArr);
                btn.backgroundColor = [Common colorWithHexString:@"fe7353"];
                btn.selected = YES;
                //底部显示已选项
                [self setSelectedView];
            }else{
                [MBProgressHUD showTipMessageInWindow:@"时间必须连续，不能跳时间选择"];
            }
        }else{
            [MBProgressHUD showTipMessageInWindow:@"每天最多预定两小时"];
        }
    }
}

///删除选择的时间段
-(void)delSelectedItem:(UIButton *)btn{
    
    if([clickRoomData[@"roomId"] isEqualToString: timeViewArr[btn.tag][@"room_id"]]){
        for (UIButton *cbtn in timeScrollView.subviews) {
            if(cbtn.tag == [timeViewArr[btn.tag][@"btn_tag"] integerValue]){
                [self selectTime:cbtn];
                break;
            }
        }
    }else{
        [timeViewArr removeObjectAtIndex:btn.tag];
        [self setSelectedView];
    }
    
}

///清除已选时间数据
-(void)clearTimeData{

    [self setSelectedView];
    //渲染时间cell
    [self setTimeScrollViewData:timeScrollViewW];
}

///submissionData
-(void)submissionData{
    if(timeViewArr == nil || timeViewArr.count <= 0 ){
        [MBProgressHUD showTipMessageInWindow:@"请选择时间"];return;
    }
    if(timeViewArr.count > 2 ){
        [MBProgressHUD showTipMessageInWindow:@"每天最多预定2小时"];return;
    }

//    if(timeViewArr.count >[surplusLableText intValue ]){
//        [MBProgressHUD showTipMessageInWindow:@"超过本月余量，请重新选择"];return;
//    }
    NSLog(@"%@",selectedData);

    NSMutableDictionary *submissDic = [NSMutableDictionary new];
    for(NSMutableDictionary *dicc in  timeViewArr){
        if([[submissDic allKeys] containsObject:dicc[@"room_id"]]){
            
            NSMutableArray *tempArrr = [NSMutableArray new];
            [tempArrr addObjectsFromArray: (NSMutableArray *)submissDic[dicc[@"room_id"]]];
            [tempArrr addObject:dicc[@"time"]];
            [submissDic setValue:tempArrr forKey:dicc[@"room_id"]];
        }else{
            NSMutableArray *tempArrr = [NSMutableArray new];
            [tempArrr addObject:dicc[@"time"]];
            [submissDic setValue:tempArrr forKey:dicc[@"room_id"]];
        }
    }
    NSLog(@"%@",submissDic);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization     dataWithJSONObject:submissDic options:NSJSONWritingPrettyPrinted   error:&error];//此处dataArr参数的key为"data"的数组
    NSString *jsonString = [[NSString alloc]    initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary new];
    [paramsDic setValue:jsonString forKey:@"room"];
    [paramsDic setValue:selectedData[@"day"] forKey:@"date"];
    NSString *url = [NSString stringWithFormat:@"%@Work/reservedRoom",HOSTURL ];
    [HDAFNetWork POST:url params:paramsDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] isEqualToString:@"1"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Index" bundle:nil];
                ScheduledSuccessViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"ScheduledSuccessViewController"];
                vc.title = @"预定成功";
                [responseObject setValue:@"meeting" forKey:@"type"];
                
                vc.dataDic =  [NSMutableDictionary new];
                vc.dataDic =  responseObject;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

-(void)getList{
    NSMutableDictionary *paramsDic = [NSMutableDictionary new];
    NSString *url = [NSString stringWithFormat:@"%@Work/getMeetingRoomsSchedule",HOSTURL ];
    [paramsDic setValue:[NSString stringWithFormat:@"%@", clickRoomData[@"roomId"]]forKey:@"room_id"];
    [paramsDic setValue:selectedData[@"day"] forKey:@"date"];
    [HDAFNetWork GET:url params:paramsDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        if ([responseObject[@"code"] isEqualToString:@"1"]) {
                            //时刻表
                            self->scrollDataArr = [NSMutableArray new];
                            [self->scrollDataArr addObjectsFromArray: responseObject[@"data"][0][@"time_list"]];
                            if(responseObject[@"data"][0][@"room_list"] != nil && ((NSMutableArray *)responseObject[@"data"][0][@"room_list"]).count != 0 ){
                                //会议室
                                self->roomList = responseObject[@"data"][0][@"room_list"];
                                
                                [self setMainView:self->mainViewRect];
                            }else{
                                //渲染时刻表cell
                                [self setTimeScrollViewData:self->timeScrollViewW];
                            }
                            
                        }
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
@end
