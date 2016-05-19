//
//  SocketServer.h
//  SocketServerWindow
//
//  Created by zzzili on 13-6-23.
//  Copyright (c) 2013年 zzzili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

@interface SocketServer : NSObject
{
    CFSocketRef _socket;
}
@property (retain, nonatomic) id delegate;
-(void) StartServer;
-(void) SendMessage;
@end
