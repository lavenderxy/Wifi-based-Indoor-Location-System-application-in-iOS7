//
//  WifiViewController.m
//  wifi_4
//
//  Created by 闫 欣宇 on 14-4-22.
//  Copyright (c) 2014年 闫 欣宇. All rights reserved.
//

#import "WifiViewController.h"

@interface WifiViewController (){
    NSMutableDictionary *networks; //Key: MAC Address (BSSID)
	
	void *libHandle;
	void *airportHandle;
	int (*apple80211Open)(void *);
	int (*apple80211Bind)(void *, NSString *);
	int (*apple80211Close)(void *);
	int (*associate)(void *, NSDictionary*, NSString*);
	int (*apple80211Scan)(void *, NSArray **, void *);
    
    UITextView *wifiDetails;
    NSTimer *wifiTimer;
}

-(NSDictionary *)networks;                          //returns all 802.11 scanned network(s)
-(NSDictionary *)networks:(NSString *) BSSID;      //return specific 802.11 network by BSSID (MAC Address)
-(void)scanNetworks;
-(int)numberOfNetworks;

@end

@implementation WifiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"wifi";
        self.tabBarItem.image = [UIImage imageNamed:@"wifi.png"];
        
        networks = [[NSMutableDictionary alloc] init];
        libHandle = dlopen("System/Library/SystemConfiguration/IPConfiguration.bundle/IPConfiguration", RTLD_LAZY);
        char *error;
        if (libHandle == NULL && (error = dlerror()) !=NULL) {
            NSLog(@"%s",error);
            exit(1);
        }
        apple80211Open = dlsym(libHandle, "Apple80211Open");
        apple80211Bind = dlsym(libHandle, "Apple80211BindToInterface");
        apple80211Close = dlsym(libHandle, "Apple80211Close");
        apple80211Scan = dlsym(libHandle, "Apple80211Scan");
        apple80211Open(&airportHandle);
        apple80211Bind(airportHandle, @"en0");
        return self;
        
    }
    return self;
}

- (void)viewDidLoad
{
    //    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    wifiDetails=[[UITextView alloc] initWithFrame:CGRectMake(0, 20, 320, 400)];
    
    wifiDetails.backgroundColor=[UIColor clearColor];
    wifiDetails.font=[UIFont systemFontOfSize:16.0];
    wifiDetails.text=@"-----------";
    
    [wifiDetails setEditable:FALSE];
    [self.view addSubview:wifiDetails];
    //    [wifiDetails release];
    
    wifiTimer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(wifiTimerFire) userInfo:nil repeats:
               YES];
    
    wifiDetails.text=@"--!!!!!!!!!";
    wifiDetails.text=[self description];
    
    // Do any additional setup after loading the view from its nib.
}

- (NSDictionary *)network:(NSString *) BSSID
{
	return [networks objectForKey:@"BSSID"];
}

- (NSDictionary *)networks
{
	return networks;
}

-(void)wifiTimerFire{
    [self scanNetworks];
}

-(void)scanNetworks
{
    NSLog(@"Scanning WiFi Channels...");
    
    NSDictionary *parameters = [[NSDictionary alloc] init];
    NSArray *scan_networks;    //is a CFArrayRef of CFDictionaryRef(s) containing key/value data on each discovered network
    apple80211Scan(airportHandle, &scan_networks, (__bridge void *)(parameters));
    NSLog(@"===__======\n%@",scan_networks);
    for (int i=0; i<[scan_networks count]; i++) {
        [networks setObject:[scan_networks objectAtIndex:i] forKey:[[scan_networks objectAtIndex:i] objectForKey:@"BSSID"]];
    }
    NSLog(@"Scanning WiFi Channels Finished.");
    
    wifiDetails.text=[self description];
}

-(int) numberOfNetworks
{
    return [networks count];
}

-(NSString *) description{
    extern NSMutableString *gresult;
    gresult = [[NSMutableString alloc] initWithString:@"Networks State: \n"];
    for(id key in networks){
        [gresult appendString:[NSString stringWithFormat:@"*SSID:%@MAC:%@RSSI:%@CHANNEL:%@\n",
                               [[networks objectForKey:key] objectForKey:@"SSID_STR"],    //Station Name
                               key,  //Station BBSID (MAC Address)
                               [[networks objectForKey:key] objectForKey:@"RSSI"],     //Signal Strength
                               [[networks objectForKey:key] objectForKey:@"CHANNEL"]   //Operating Channel
                               ]];
 /*       [gresult appendString:[NSString stringWithFormat:@"%@ (MAC: %@), RSSI: %@, Channel: %@ \n",
                              [[networks objectForKey:key] objectForKey:@"SSID_STR"],    //Station Name
                              key,  //Station BBSID (MAC Address)
                              [[networks objectForKey:key] objectForKey:@"RSSI"],     //Signal Strength
                              [[networks objectForKey:key] objectForKey:@"CHANNEL"]   //Operating Channel
                              ]];   */
    }
    return [NSString stringWithString:gresult];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
}
- (void)dealloc {
    [super dealloc];
} 

@end

