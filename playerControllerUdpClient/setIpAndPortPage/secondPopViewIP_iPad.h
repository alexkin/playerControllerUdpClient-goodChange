//
//  secondPopViewIP_iPad.h
//  playerControllerUdpClient
//
//  Created by stone on 14-4-22.
//  Copyright (c) 2014年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "passValueByDelegate.h"

@interface secondPopViewIP_iPad : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textFieldIp;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPort;

@property (retain, nonatomic) NSObject<passValueByDelegate>*delegate;

- (IBAction)btnOk:(id)sender;

@end
