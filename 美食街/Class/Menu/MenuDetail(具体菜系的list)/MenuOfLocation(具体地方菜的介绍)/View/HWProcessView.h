//
//  HWProcessView.h
//  美食街
//
//  Created by Jerry Huang on 2018/2/7.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWProcessItem;
@interface HWProcessView : UIView

//** processItem */
@property (strong, nonatomic) HWProcessItem *item;
@property (weak, nonatomic) IBOutlet UIImageView *pImage;
@property (weak, nonatomic) IBOutlet UILabel *pLabel;
@end
