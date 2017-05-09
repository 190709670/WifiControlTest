//
//  ViewController.m
//  WifiControlTest
//
//  Created by lihui on 2017/5/9.
//  Copyright © 2017年 test. All rights reserved.
//

#import "ViewController.h"
@import CocoaAsyncSocket;
@interface ViewController ()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *socket;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self socketInit];
}
-(void)socketInit{
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [socket connectToHost:@"www.baidu.com" onPort:80 withTimeout:10 error:nil];
    
    [socket readDataWithTimeout:10 tag:1];
    [socket writeData:[@"GET/HTTP/1.1\n\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
}
#pragma mark GCDAsyncSocketDelegate
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"did connection to host");
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"did read data");
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"message is: \n %@",message);
}
-(void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    NSLog(@"didReadPartialDataOfLength :%ld  tag:%ld",partialLength,tag);
}
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"didWriteData tag : %ld",tag);
    
    [socket readDataWithTimeout:10 tag:1];
 //   [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:10 maxLength:50000 tag:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
