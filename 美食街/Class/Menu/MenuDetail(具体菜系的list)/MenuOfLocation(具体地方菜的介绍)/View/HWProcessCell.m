//
//  HWProcessCell.m
//  美食街
//
//  Created by Jerry Huang on 2018/2/7.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import "HWProcessCell.h"
#import "HWProcessView.h"




@implementation HWProcessCell



-(void)layoutSubviews{
    //获得有几个模型
    NSInteger count = self.processArr.count;

    CGFloat processViewW = self.frame.size.width;
    CGFloat processViewH = 220;
    for (int i = 0; i < count; i++) {
        
        
        CGFloat processViewY = i * processViewH;
        
        HWProcessView *pView = self.subviews[i];
        
        if ([pView isKindOfClass:[NSClassFromString(@"_UITableViewCellSeparatorView") class]]) {
            [pView removeFromSuperview];
        }
        pView.frame = CGRectMake(0, processViewY,processViewW,processViewH);
        pView.backgroundColor = HWRandomColor;
    }
}




- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
