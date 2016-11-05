//
//  BossViewController.h
//  iOS转场动画-Boss直聘
//
//  Created by xxxxx on 16/11/2.
//  Copyright © 2016年 hst. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackBlock)(void);

@interface BossViewController : UIViewController

/** block */
@property(nonatomic, copy) BackBlock backblock;

- (void)setBackblock:(BackBlock)backblock;

- (void)changeBigView;

@end
