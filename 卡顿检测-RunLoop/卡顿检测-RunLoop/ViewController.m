//
//  ViewController.m
//  卡顿检测-RunLoop
//
//  Created by Alan on 5/7/20.
//  Copyright © 2020 zhaixingzhi. All rights reserved.
//

#import "ViewController.h"
#import "XZBlockMonitor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[XZBlockMonitor sharedInstance] start];

    // Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for(int i = 0 ; i < 100000; i++){
        UIView *v = [[UIView alloc] init];
        v.frame = CGRectMake(0, 100, 100, 100);
        v.backgroundColor = [UIColor redColor];
        [self.view addSubview:v];
    }

}

@end
