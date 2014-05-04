//
//  playerControllerUdpViewController.h
//  playerControllerUdpClient
//
//  Created by stone on 14-4-18.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "passValueByDelegate.h"

@interface playerControllerUdpViewController : UIViewController<passValueByDelegate>

@property(nonatomic,strong)NSString *myTextIp;
@property(nonatomic,strong)NSString *myTextPort;

//@property(retain,nonatomic)IBOutlet UITextField *textFieldIpInput;
//@property(retain,nonatomic)IBOutlet UITextField *textFieldPortInput;

@property(nonatomic,retain)IBOutlet UIButton *playPause;
@property(nonatomic,retain)IBOutlet UIButton *mute;
@property(nonatomic,retain)IBOutlet UIButton *playStop;
@property(nonatomic,retain)IBOutlet UIButton *voiceAdd;
@property(nonatomic,retain)IBOutlet UIButton *voiceMult;

-(IBAction)button0:(id)sender;
-(IBAction)button1:(id)sender;
-(IBAction)button2:(id)sender;
-(IBAction)button3:(id)sender;
-(IBAction)button4:(id)sender;
-(IBAction)button5:(id)sender;

-(IBAction)playPause:(id)sender;
-(IBAction)mute:(id)sender;
-(IBAction)playStop:(id)sender;
-(IBAction)voiceAdd:(id)sender;
-(IBAction)voiceMult:(id)sender;
- (IBAction)shutDownPC:(id)sender;

-(IBAction)showSetIpAndPort:(id)sender;


@end
