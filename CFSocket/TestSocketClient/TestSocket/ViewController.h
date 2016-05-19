//
//  ViewController.h
//  TestSocket
//
//  Created by zzzili on 13-5-17.
//  Copyright (c) 2013年 zzzili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    CFSocketRef _socket;
}

- (IBAction)SendMessageTouch:(id)sender;
- (IBAction)TouchConnectServer:(id)sender;

@property (retain, nonatomic) IBOutlet UITextView *TextView;
@property (retain, nonatomic) IBOutlet UITextField *textField;

@end
