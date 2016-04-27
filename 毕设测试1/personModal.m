//
//  personModal.m
//  毕设测试1
//
//  Created by sq-ios85 on 16/4/25.
//  Copyright © 2016年 shangqian. All rights reserved.
//

#import "personModal.h"
static personModal *modal=nil;
@implementation personModal
+(id)getInstance{
    if(modal==nil){
        modal=[[personModal alloc]init];
        modal.set=NO;
    }
    return modal;
}

@end
