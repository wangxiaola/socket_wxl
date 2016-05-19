//
//  SocketServer.m
//  SocketServerWindow
//
//  Created by zzzili on 13-6-23.
//  Copyright (c) 2013年 zzzili. All rights reserved.
//

#import "SocketServer.h"
CFWriteStreamRef outputStream;

@implementation SocketServer

-(int)setupSocket
{
    CFSocketContext sockContext = {0, // 结构体的版本，必须为0
        self,
        NULL, // 一个定义在上面指针中的retain的回调， 可以为NULL
        NULL,
        NULL};
    
    _socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, TCPServerAcceptCallBack, &sockContext);
    
    if (NULL == _socket)
    {
        NSLog(@"Cannot create socket!");
        return 0;
    }
    
    int optval = 1;
    
    setsockopt(CFSocketGetNative(_socket), SOL_SOCKET, SO_REUSEADDR, // 允许重用本地地址和端口
               (void *)&optval, sizeof(optval));
    
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(8888);
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));
    
    if (kCFSocketSuccess != CFSocketSetAddress(_socket, address))
    {
        NSLog(@"Bind to address failed!");
        if (_socket)
            CFRelease(_socket);
        _socket = NULL;
        return 0;
    }
    
    CFRunLoopRef cfRunLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
    CFRunLoopAddSource(cfRunLoop, source, kCFRunLoopCommonModes);
    CFRelease(source);
    
    return 1;
}

-(void) SendMessage
{
    char *str = "你好 Client";
    uint8_t * uin8b = (uint8_t *)str;
    if (outputStream != NULL)
    {
        CFWriteStreamWrite(outputStream, uin8b, strlen(str) + 1);
    }
    else {
        NSLog(@"Cannot send data!");
    }
    
}
// 开辟一个线程线程函数中
-(void) StartServer
{
    int res = [self  setupSocket];
    if (!res) {
        exit(1);
    }
    NSLog(@"运行当前线程的CFRunLoop对象");
    CFRunLoopRun();    // 运行当前线程的CFRunLoop对象
}

-(void)ShowMsgOnMainPage:(NSString*)strMsg
{
    [self.delegate ShowMsg:strMsg];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// socket回调函数
static void TCPServerAcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    if (kCFSocketAcceptCallBack == type)
    {
        // 本地套接字句柄
        CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
        uint8_t name[SOCK_MAXADDRLEN];
        socklen_t nameLen = sizeof(name);
        if (0 != getpeername(nativeSocketHandle, (struct sockaddr *)name, &nameLen)) {
            NSLog(@"error");
            exit(1);
        }
        CFReadStreamRef iStream;
        CFWriteStreamRef oStream;
        // 创建一个可读写的socket连接
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocketHandle, &iStream, &oStream);
        if (iStream && oStream)
        {
            CFStreamClientContext streamContext = {0, info, NULL, NULL};
            if (!CFReadStreamSetClient(iStream, kCFStreamEventHasBytesAvailable,readStream, &streamContext))
            {
                exit(1);
            }
            
            if (!CFWriteStreamSetClient(oStream, kCFStreamEventCanAcceptBytes, writeStream, &streamContext))
            {
                exit(1);
            }
            CFReadStreamScheduleWithRunLoop(iStream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
            CFWriteStreamScheduleWithRunLoop(oStream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
            CFReadStreamOpen(iStream);
            CFWriteStreamOpen(oStream);
        } else
        {
            close(nativeSocketHandle);
        }
    }
}
// 读取数据
void readStream(CFReadStreamRef stream, CFStreamEventType eventType, void *clientCallBackInfo)
{
    UInt8 buff[255];
    CFReadStreamRead(stream, buff, 255);
    
    ///根据delegate显示到主界面去
    NSString *strMsg = [[NSString alloc]initWithFormat:@"客户端传来消息：%s",buff];
    SocketServer *info = (SocketServer*)clientCallBackInfo;
    [info ShowMsgOnMainPage:strMsg];
}
void writeStream (CFWriteStreamRef stream, CFStreamEventType eventType, void *clientCallBackInfo)
{
    outputStream = stream;
}
@end
