//
//  setIpAndPortPage.h
//  playerControllerUdpClient
//
//  Created by stone on 14-4-18.
//  Copyright (c) 2014年 stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "passValueByDelegate.h"

@interface setIpAndPortPage : UIViewController

@property(retain,nonatomic)IBOutlet UITextField *textFieldIpInput;
@property(retain,nonatomic)IBOutlet UITextField *textFieldPortInput;

//set delegate
@property(nonatomic,assign)NSObject<passValueByDelegate>*delegate;

-(IBAction)chooseOK:(id)sender;
//-(IBAction)closeKeyBoard:(id)sender;


@end
