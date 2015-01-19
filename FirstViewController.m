//
//  FirstViewController.m
//  wifi_4
//
//  Created by 闫 欣宇 on 14-4-22.
//  Copyright (c) 2014年 闫 欣宇. All rights reserved.
//

#import "FirstViewController.h"
#import "IndoorMapView.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"main";
        self.tabBarItem.image = [UIImage imageNamed:@"first.png"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    IndoorMapView *mapView = [[IndoorMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    
    [self.view addSubview:mapView];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
