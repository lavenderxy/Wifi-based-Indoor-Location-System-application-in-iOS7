//
//  SecondViewController.h
//  wifi_4
//
//  Created by 闫 欣宇 on 14-4-22.
//  Copyright (c) 2014年 闫 欣宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#define SRV_CONNECTED 0
#define SRV_CONNECT_SUC 1
#define SRV_CONNECT_FAIL 2
#define HOST_IP @"192.168.1.101"
#define HOST_PORT 8080


@interface SecondViewController : UIViewController{
    UITextField *inputMsg;
    UILabel *outputMsg;
    AsyncSocket *client;
}

@property (retain, nonatomic) AsyncSocket *client;

@property (retain, nonatomic) IBOutlet UITextField *inputMsg;
@property (retain, nonatomic) IBOutlet UILabel *outputMsg;

-(int)connectServer: (NSString *) hostIP port:(int) hostPort;
-(void) showMessage: (NSString *) msg;
-(IBAction)sendMsg;
-(IBAction)reConnect;
//-(IBAction)textFieldDoneEditing:(id)sender;
-(IBAction)backgroundTouch:(id)sender;
 

@end
