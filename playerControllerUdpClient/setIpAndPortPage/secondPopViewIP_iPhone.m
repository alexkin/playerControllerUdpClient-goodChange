//
//  secondPopViewIP_iPhone.m
//  playerControllerUdpClient
//
//  Created by stone on 14-4-22.
//  Copyright (c) 2014年 stone. All rights reserved.
//

#import "secondPopViewIP_iPhone.h"
#import "dateDelegate.h"

@interface secondPopViewIP_iPhone ()

@end

@implementation secondPopViewIP_iPhone
@synthesize textFieldIp;
@synthesize textFieldPort;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnOk:(id)sender {
    dateDelegate *date_Delegate = [[dateDelegate alloc]init];
    date_Delegate.textIp = self.textFieldIp.text;
    date_Delegate.textPort = self.textFieldPort.text;
    
    [self.delegate passValue:date_Delegate];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
