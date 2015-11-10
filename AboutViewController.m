//
//  AboutViewController.m
//  ETF_Blackjack
//
//  Created by Eric on 10/4/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (IBAction)done:(id)sender{
    //UIViewController *parent = self.presentingViewController;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"%s", __FUNCTION__);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillLayoutSubviews{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLayoutSubviews{
    NSLog(@"%s", __FUNCTION__);
}

- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
