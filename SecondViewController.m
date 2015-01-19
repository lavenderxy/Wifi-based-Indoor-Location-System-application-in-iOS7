//
//  SecondViewController.m
//  wifi_4
//
//  Created by 闫 欣宇 on 14-4-22.
//  Copyright (c) 2014年 闫 欣宇. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize inputMsg, outputMsg;
@synthesize client;

//******初始化界面下方小图标*******//
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"sub";
        self.tabBarItem.image = [UIImage imageNamed:@"second.png"];
    }
    return self;
}
//*****************************//


//********载入界面运行的程序********//
- (void)viewDidLoad
{
    //   [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    asyncSocket=[[AsyncSocket alloc] initWithDelegate:self];
    //    [asyncSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self connectServer:HOST_IP port:HOST_PORT];
    //监听读取
    
    outputMsg = [[UILabel alloc] initWithFrame: CGRectMake( 70.0f,  280.0f,  180.0f,  50.0f)];
    outputMsg.textColor = [UIColor redColor];
    outputMsg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: outputMsg];
    outputMsg.text=@"waiting...";
    
}
//********************************//

//**********屏幕旋转程序************//
-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
//*********************************//



//***********连接主机程序*******************//
- (int) connectServer:(NSString *)hostIP port:(int)hostPort{
    
    if (client == nil) {
        client = [[AsyncSocket alloc] initWithDelegate:self];
        [client setRunLoopModes:[NSArray arrayWithObjects:NSRunLoopCommonModes, nil]];   //important!!不加程序崩溃，闪退
        NSError *err = nil;
        //192.168.110.128
        if (![client connectToHost:hostIP onPort:hostPort error:&err]) {
            NSLog(@"%ld %@", (long)[err code], [err localizedDescription]);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Connection failed to host" stringByAppendingString:hostIP] message:[[[NSString alloc] initWithFormat:@"%ld",(long)[err code]] stringByAppendingString:[err localizedDescription]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            //client = nil;
            return SRV_CONNECT_FAIL;
        } else {
            NSLog(@"Connectou!");
            outputMsg.text=@"connect success";
            return SRV_CONNECT_SUC;
        }
    }
    else {
        [client readDataWithTimeout:-1 tag:0];
        return SRV_CONNECTED;
    }
}
//*****************************************//

//****************重新连接reconnect button*********//
-(IBAction)reConnect{
    int stat = [self connectServer:HOST_IP port:HOST_PORT];
    switch (stat) {
        case SRV_CONNECT_SUC:
            [self showMessage:@"connect success"];
            break;
        case SRV_CONNECTED:
            [self showMessage:@"It's connected, don't again"];
            break;
        default:
            break;
    }
}
//************************************************//


//***************发送数据send button***************//
-(IBAction)sendMsg{
    extern NSMutableString *gresult;
    
    //    NSString *sendTohost = @"1";
    NSString *sendTohost = gresult;
    NSLog(@"%@",sendTohost);
    NSData *data = [sendTohost dataUsingEncoding:NSISOLatin1StringEncoding];
    [client writeData:data withTimeout:-1 tag:0];
    
}
//***********************************************//

#pragma mark -
#pragma mark close Keyboard
/*-(IBAction)textFieldDoneEditing:(id)sender{
 [inputMsg resignFirstResponder];
 }    */

#pragma mark socket uitl

//**************警告函数**************************//
-(void) showMessage:(NSString *)msg{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}
//***********************************************//

#pragma mark socket delegate

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    [client readDataWithTimeout:-1 tag:0];
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"Error");
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSString *msg= @"Sorry this connect is failure";
    [self showMessage:msg];
    [msg release];
    client = nil;
}

-(void)onSocketDidSecure:(AsyncSocket *)sock{
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    extern NSString *gStr;
    NSString *aStr= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Hava received datas is :%@",aStr);
    self.outputMsg.text = aStr;
    gStr=[aStr retain];
    [aStr release];
    [client readDataWithTimeout:-1 tag:0];

}

/*-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    extern NSString *gStr;
    gStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Hava received datas is :%@",gStr);
    self.outputMsg.text = gStr;
    [gStr release];
    [client readDataWithTimeout:-1 tag:0];

}   */



//***********释放内存***************//
- (void)viewDidUnload{
    self.outputMsg = nil;
    self.client = nil;
    self.inputMsg = nil;
    //Release any retained subviews of the main view.
    //e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    //Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil) {
        self.client = nil;
        self.inputMsg = nil;
        self.outputMsg = nil;
    }
    // Dispose of any resources that can be recreated.
    //Release any cached data, images, etc that aren't in use.
}
//**********************************//



#pragma mark dealloc

- (void)dealloc {
    if ([self isViewLoaded]) {
        [self viewDidUnloaded];
    }
    
    //    [client release];
    //    [inputMsg release];
    //    [outputMsg release];
    //    [_inputMsg release];
    //    [_inputMsg release];
    //    [_outputMsg release];
    [super dealloc];
}

@end

