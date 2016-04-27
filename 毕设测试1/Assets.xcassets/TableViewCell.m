//
//  TableViewCell.m
//  毕设测试1
//
//  Created by sq-ios85 on 16/4/20.
//  Copyright © 2016年 shangqian. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *arr=[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:self options:nil];
    
    [self.cell addSubview:_cell];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
