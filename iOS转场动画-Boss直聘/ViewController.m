//
//  ViewController.m
//  iOS转场动画-Boss直聘
//
//  Created by xxxxx on 16/11/2.
//  Copyright © 2016年 hst. All rights reserved.
//

#import "ViewController.h"
#import "BossViewController.h"
#import "AppDelegate.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** 上一次显示的行 */
@property (nonatomic, assign) NSInteger lastIndexRow;

/** BOSS直聘跳转截图 */
@property (nonatomic, weak) UIImageView *screenshotImageView;

@end

#define SCREEN [UIScreen mainScreen].bounds.size

@implementation ViewController

#pragma mark - 懒加载
- (UIImageView *)screenshotImageView
{
    if (!_screenshotImageView)
    {
        UIImageView *view = [[UIImageView alloc] init];
        [self.view addSubview:view];
        _screenshotImageView = view;
    }
    return _screenshotImageView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tb = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        tb.delegate = self;
        tb.dataSource = self;
        
        [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        [self.view addSubview:tb];
        _tableView = tb;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"First VC";
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - UITabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"BOSS直聘动画";
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"NO.%ld",indexPath.row];
    }
    cell.imageView.image = [UIImage imageNamed:@"appii"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [self tranToBoss];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.lastIndexRow < indexPath.row)
    {
        NSLog(@"向下");
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DRotate(transform, 0, 0, 0, 1); //角度
        transform = CATransform3DScale(transform, 1.2, 1.5, 0); //放大的状态
        cell.layer.transform = transform;
        cell.layer.opacity = 0; //渐变
        
        [UIView animateWithDuration:0.3 animations:^{
            cell.layer.transform = CATransform3DIdentity;
            cell.layer.opacity = 1; //不透明
        }];
    }
    
    self.lastIndexRow = indexPath.row;
}

#pragma mark - Push
- (void)tranToBoss
{
    self.screenshotImageView.image = [self screenImageWithSize:self.view.bounds.size];
    self.screenshotImageView.frame = self.view.bounds;
    self.tableView.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    BossViewController *bossVC = [[BossViewController alloc] init];
    
    [bossVC setBackblock:^{
        [self.screenshotImageView removeFromSuperview];
        self.tableView.hidden = NO;
        self.tabBarController.tabBar.hidden = NO;
    }];
    
    [self presentViewController:bossVC animated:NO completion:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.screenshotImageView.bounds = CGRectMake(50, 50, SCREEN.width - 100, SCREEN.height - 100);
    } completion:^(BOOL finished) {
        [bossVC changeBigView];
    }];
}

#pragma mark - other
- (UIImage *)screenImageWithSize:(CGSize )imgSize
{
    UIGraphicsBeginImageContext(imgSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [app.window.layer renderInContext:context];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
