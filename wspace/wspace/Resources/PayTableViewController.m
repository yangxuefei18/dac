//
//  PayTableViewController.m
//  wspace
//
//  Created by 汉德 on 2019/3/20.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "PayTableViewController.h"
#import "Ipay.h"
#import "IpayPayment.h"

@interface PayTableViewController  ()<PaymentResultDelegate,UITableViewDelegate,UITableViewDataSource>{
    Ipay *paymentsdk;
}

@end

@implementation PayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self iPay];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)iPay{
    
    paymentsdk = [[Ipay alloc] init];
    paymentsdk.delegate = self;
    IpayPayment *payment = [[IpayPayment alloc] init];
    //设置付款ID
    [payment setPaymentId:@"2"];
    //设置商店密钥 必需）-IPAY88提供的商业密钥。例如Apple 88密钥
    [payment setMerchantKey:@"hRR96HLslF"];
    //设置商店代码 必需）–IPAY88提供的商户代码。例如M099
    [payment setMerchantCode:@"M16397"];
    //设置参考号 用于商业参考目的的参考号，对于每个交易都应该是唯一的。
    [payment setRefNo:@"ORD1188123123000"];
    //设置金额
    [payment setAmount:@"0.50"];
    //设定货币
    [payment setCurrency:@"MYR"];
    //设置产品描述
    [payment setProdDesc:@"Payment for Info"];
    //设置用户名
    [payment setUserName:@"Sam Lee"];
    //设置用户电子邮件
    [payment setUserEmail:@"zmt@139.com"];
    //设置用户联系人
    [payment setUserContact:@"11011011011"];
    //设置备注
    [payment setRemark:@"WSpace Ceshi Pay Remark"];
    //设置语言
    [payment setLang:@"ISO-8859-1"];
    //设置国家
    [payment setCountry:@"MY"];
    //在付款成功时指定有效的商户回拨URL
    [payment setBackendPostURL:@"http://dac.ccooddee.cn/api_frontend/push"];
    
    
    //    [paymentsdk requery:payment];
    UIView *paymentView = [paymentsdk checkout:payment];//This method returns a UIView(an instance of UIWebView).
    
    [self.view addSubview:paymentView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [UITableViewCell new];
}


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 *
 
 
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)paymentCancelled:(NSString *)refNo withTransId:(NSString *)transId withAmount:(NSString *)amount withRemark:(NSString *)remark withErrDesc:(NSString *)errDesc {
    
}

//The interface for providing details on when a payment is completed is defined in <PaymentResultDelegate> protocol. This interface provides you with a way to be notified immediately when a payment has completed:
/// < paymentResultDelegate >协议中定义了用于提供付款完成时间的详细信息的接口。此界面提供了一种在付款完成后立即通知您的方法：
//付款失败
- (void)paymentFailed:(NSString *)refNo withTransId:(NSString *)transId withAmount:(NSString *)amount withRemark:(NSString *)remark withErrDesc:(NSString *)errDesc {
    //Invalid parameters(Payment Not Allow)无效参数（不允许付款）
}

//付款成功
- (void)paymentSuccess:(NSString *)refNo withTransId:(NSString *)transId withAmount:(NSString *)amount withRemark:(NSString *)remark withAuthCode:(NSString *)authCode {
    
}



//Note: only the refNo, merchantCode and amount properties of the IpayPayment object are required for requery(the rest can be left empty).
//注意：只有iPayPayment对象的RefNo、MerchantCode和Amount属性是Requery所必需的（其余可以留空）。

//The interface for providing details on when a requery is completed is defined in <PaymentResultDelegate> protocol. This interface provides you with a way to be notified immediately when a requery has completed:
//在<paymentResultDelegate>协议中定义了用于在完成查询时提供详细信息的接口。此接口为您提供了一种在查询完成后立即通知您的方法：

//请求失败
- (void)requeryFailed:(NSString *)refNo withMerchantCode:(NSString *)merchantCode withAmount:(NSString *)amount withErrDesc:(NSString *)errDesc {
    
}
//请求成功
- (void)requerySuccess:(NSString *)refNo withMerchantCode:(NSString *)merchantCode withAmount:(NSString *)amount withResult:(NSString *)result {
    
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return CGSizeMake(300, 500);
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    
}

- (void)setNeedsFocusUpdate {
    
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return YES;
}

- (void)updateFocusIfNeeded {
    
}


@end
