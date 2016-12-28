//
//  ViewController.m
//  TestLayerAnamation
//
//  Created by HLINK010 on 2016/12/27.
//  Copyright © 2016年 HLINK010. All rights reserved.
//

#import "ViewController.h"
#import "LayerAnimation.h"
@interface ViewController ()
{
    LayerAnimation *layer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [[UIColor cyanColor]colorWithAlphaComponent:0.3];
    
    layer = [[LayerAnimation alloc]initWithFrame:CGRectMake(30, 50, 300, 300)];
    [layer setProgress:0.7];
    [self.view addSubview:layer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)beginanimaiton:(id)sender {
    [layer setProgress:0.7];
}


@end
