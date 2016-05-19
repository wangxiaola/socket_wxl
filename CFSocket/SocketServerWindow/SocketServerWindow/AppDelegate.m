//
//  AppDelegate.m
//  SocketServerWindow
//
//  Created by zzzili on 13-6-23.
//  Copyright (c) 2013年 zzzili. All rights reserved.
//

#import "AppDelegate.h"

struct abc {
    short a;
    short b;
    short c;
    char  d;
    char  e[11];
    long long f;
    char g[11];
    int  h;
    char j[3];
};

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    struct abc a;
    NSLog(@"=== %lu",sizeof(a));
    
    
    server = [[SocketServer alloc]init];
    server.delegate = self;
    // Insert code here to initialize your application
   
}
- (IBAction)SendMessageToClient:(id)sender {
    [server SendMessage];
}

- (IBAction)touchStartServer:(id)sender {
    NSThread *InitThread = [[NSThread alloc]initWithTarget:self selector:@selector(InitThreadFunc:) object:self];
    [InitThread start];
    self.textField.stringValue = @"服务启动成功";
}
-(void)InitThreadFunc:(id)sender
{
    [server StartServer];
}
-(void)ShowMsg:(NSString*)strMsg
{
    NSLog(strMsg);
    self.textField.stringValue = [NSString stringWithFormat:@"%@\n%@",self.textField.stringValue, strMsg];
}
@end
