//
//  HWMenuDetailItem.m
//  美食街
//
//  Created by 黄炜 on 2018/1/22.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import "HWMenuDetailItem.h"

@implementation HWMenuDetailItem

-(CGFloat)contentViewHeight{
    
    CGSize contentSize = CGSizeMake(HWScreenW, MAXFLOAT);
    
    return [_content sizeWithFont:[UIFont systemFontOfSize:19] constrainedToSize:contentSize].height + 25;
}

-(NSString *)content{
    return [_content stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
}

@end
