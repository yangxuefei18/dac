//
//  UserInfoModel.h
//  农商财富
//
//  Created by 汉德 on 2017/7/28.
//  Copyright © 2017年 河北农商财富. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *userSex;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *userPhoto;
@property (nonatomic,copy)NSString *userPhone;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *userEmail;
@property (nonatomic,copy)NSString *company;
@property (nonatomic,copy)NSString *job;
@property (nonatomic,copy)NSString *info;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *infulence_power;
@property (nonatomic,copy)NSString *credit;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
