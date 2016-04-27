//
//  personModal.h
//  毕设测试1
//
//  Created by sq-ios85 on 16/4/25.
//  Copyright © 2016年 shangqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface personModal : NSObject
@property (nonatomic,assign)BOOL set;
@property (nonatomic,assign)int age;
@property (nonatomic,assign)int shengao;
@property (nonatomic,assign)int weight;
@property (nonatomic,assign)int dailyGoal;
+(id)getInstance;
@end
