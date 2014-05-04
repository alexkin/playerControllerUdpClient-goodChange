//
//  setIpAndPortPage.m
//  playerControllerUdpClient
//
//  Created by stone on 14-4-18.
//  Copyright (c) 2014年 stone. All rights reserved.
//

#import "setIpAndPortPage.h"
#import "dateDelegate.h"

@implementation setIpAndPortPage

@synthesize textFieldIpInput;
@synthesize textFieldPortInput;
@synthesize delegate;

//返回上一界面的时候，设置委托
-(IBAction)chooseOK:(id)sender{
    //NSString *myUdpTextIp = self.textFieldIpInput.text;
    //NSString *myUdpTextPort = self.textFieldPortInput.text;
    
    dateDelegate *date_Delegate = [[dateDelegate alloc]init];
    
    date_Delegate.textIp = self.textFieldIpInput.text;
    date_Delegate.textPort = self.textFieldPortInput.text;
    
    //通过委托协议传值
    [self.delegate passValue:date_Delegate];
    
    NSLog(@"here %@",date_Delegate.textIp);
    
    //窗口返回
    [self performSegueWithIdentifier:@"endSetting" sender:nil];
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
