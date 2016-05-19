//
//  AppDelegate.h
//  SocketServerWindow
//
//  Created by zzzili on 13-6-23.
//  Copyright (c) 2013年 zzzili. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SocketServer.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    SocketServer *server;
}
@property (assign) IBOutlet NSTextField *textField;

@property (assign) IBOutlet NSWindow *window;
- (IBAction)SendMessageToClient:(id)sender;
- (IBAction)touchStartServer:(id)sender;

@end
