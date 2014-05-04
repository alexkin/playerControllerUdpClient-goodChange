//
//  playerControllerUdpViewController.m
//  playerControllerUdpClient
//
//  Created by stone on 14-4-18.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "playerControllerUdpViewController.h"
#import "setIpAndPortPage.h"
#import "secondPopViewIP_iPad.h"
#import "secondPopViewIP_iPhone.h"
#import "dateDelegate.h"
#import "GCDAsyncUdpSocket.h"
#import "DDLog.h"

//static const int ddLogLevel = LOG_LEVEL_VERBOSE;

#define FORMAT(format,...) [NSString stringWithFormat:(format),##__VA_ARGS__]


#define runAs_iPad  secondPopViewIP_iPad
#define runAs_iPhone    secondPopViewIP_iPhone

@interface playerControllerUdpViewController (){
    long tag;
    GCDAsyncUdpSocket *udpSocket;
    
    NSMutableString *log;
}

@end

@implementation playerControllerUdpViewController{
    bool boolBtnPlayPause,boolBtnMute,boolBtnPlayStop,boolBtnVoiceAdd,boolBtnVoiceMult;
    int intStateMent;
    
}

@synthesize myTextIp;
@synthesize myTextPort;

@synthesize playPause;
@synthesize mute;
@synthesize playStop;
@synthesize voiceAdd;
@synthesize voiceMult;

-(void)passValue:(dateDelegate *)value{
    //self.myTextIp = value.textIp;
    //self.myTextPort = value.textPort;
    
    //NSLog(@"myTextIp here: %@",value.textIp);
    [self readFile];
    
    if (udpSocket == nil) {
        [self setupSocket];
    }
}

//获取应用沙盒的根路径
-(void)dirHome{
    NSString *dirHome = NSHomeDirectory();
    NSLog(@"app_home: %@",dirHome);
}

//获取documents目录路径
-(NSString *)dirDoc{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"app_home_doc : %@",documentsDirectory);
    return documentsDirectory;
}

//创建文件夹
-(void)creatDir{
    NSString *documentsPath = [self dirDoc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"UDPTest"];
    
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:testDirectory isDirectory:&isDir];
    
    if (!(isDirExist && isDir)) {
        //创建目录
        [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        //if (res) {
         //   NSLog(@"文件夹创建成功");
       //// }
       // else{
       //     NSLog(@"文件夹创建失败");
       // }
    }//else
       // NSLog(@"文件夹已经存在拉");
    
}

//创建文件
-(void)creatFile{
    NSString *documentsPath = [self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"UDPTest"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"UDPTest.txt"];
    NSString *testPathPort = [testDirectory stringByAppendingPathComponent:@"UDPTestPort.txt"];
    //BOOL res = [fileManager removeItemAtPath:testPath error:nil];
//    
    if (![fileManager fileExistsAtPath:testPath]) {
        [fileManager createFileAtPath:testPath contents:nil attributes:nil];
    }
    
    if (![fileManager fileExistsAtPath:testPathPort]) {
        [fileManager createFileAtPath:testPathPort contents:nil attributes:nil];
    }
// NSLog(@"文件是否存在：%@",[fileManager fileExistsAtPath:testPath]?@"yes":@"no");
}

//读取文件
-(void)readFile{
    NSString *documentPath = [self dirDoc];
    NSString *testDirectory = [documentPath stringByAppendingPathComponent:@"UDPTest"];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"UDPTest.txt"];
    NSString *testPathPort = [testDirectory stringByAppendingPathComponent:@"UDPTestPort.txt"];
    
    self.myTextPort = [NSString stringWithContentsOfFile:testPathPort encoding:NSUTF8StringEncoding error:nil];
    self.myTextIp = [NSString stringWithContentsOfFile:testPath encoding:NSUTF8StringEncoding error:nil];
   // NSLog(@"madesjksgskgjskgjskg %@",self.myTextPort);
}

//Socket设置
-(void)setupSocket{
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    
    if (![udpSocket bindToPort:0 error:&error]) {
        [self logEror:FORMAT(@"Error binding:%@",error)];
        return;
    }
    if (![udpSocket beginReceiving:&error]) {
        [self logEror:FORMAT(@"Error receiving:%@",error)];
        return;
    }
    [self logInfo:@"Ready"];
}


-(IBAction)showSetIpAndPort:(id)sender{
    
#ifdef runAs_iPad
    runAs_iPad *secondView = [[runAs_iPad alloc]initWithNibName:@"secondPopViewIP_iPad" bundle:[NSBundle mainBundle]];
#else
    runAs_iPhone *secondView = [[runAs_iPhone alloc]initWithNibName:@"secondPopViewIP_iPhone" bundle:[NSBundle mainBundle]];
#endif
    
    //----------------------------------
    secondView.delegate = self;
    
    //controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.navigationController pushViewController:secondView animated:YES];
    
    //[self presentViewController:controller animated:YES completion:nil];
    
    //controller.delegate = self;
    //[self.navigationController pushViewController:controller animated:YES];
    //controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    //controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //controller.modalTransitionStyle = UIModalPresentationPageSheet;
    //[self presentViewController:controller animated:YES completion:nil];
}

-(void)setInitValue{
    boolBtnPlayPause = false;
    boolBtnMute = false;
    boolBtnPlayStop = false;
    boolBtnVoiceAdd = false;
    boolBtnVoiceMult = false;
    
    intStateMent = -1;
}

//select content
-(IBAction)button0:(id)sender{
    intStateMent = 0;
    
    //------------------------
    boolBtnPlayPause = false;
    [playPause setBackgroundImage:[UIImage imageNamed:@"yesTouchPlay.png"] forState:UIControlStateNormal];
    //------------------------
    
    //NSLog(@"here is the report:%@",myTextIp);
   // NSLog(@"ahahhahaha %@",myTextPort);
    NSString *host = self.myTextIp;
    if ([host length] == 0) {
        [self logEror:@"Address required"];
        return;
    }
    
    int port = [self.myTextPort intValue];
    if (port <= 0 || port > 65535) {
        [self logEror:@"Valid port required"];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%d",intStateMent];
    if ([msg length] == 0) {
        [self logEror:@"Message required"];
        return;
    }
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
    [self logMessage:FORMAT(@"SNT (%i): %@",(int)tag,msg)];
    tag ++;
    //send intStatement
}

-(IBAction)button1:(id)sender{
    intStateMent = 1;
    
    //------------------------
    boolBtnPlayPause = false;
    [playPause setBackgroundImage:[UIImage imageNamed:@"yesTouchPlay.png"] forState:UIControlStateNormal];
    //------------------------
    
    
    
    //**************************
    NSString *host = self.myTextIp;
    if ([host length] == 0) {
        [self logEror:@"Address required"];
        return;
    }
    
    int port = [self.myTextPort intValue];
    if (port <= 0 || port > 65535) {
        [self logEror:@"Valid port required"];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%d",intStateMent];
    if ([msg length] == 0) {
        [self logEror:@"Message required"];
        return;
    }
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
    [self logMessage:FORMAT(@"SNT (%i): %@",(int)tag,msg)];
    tag ++;
}

-(IBAction)button2:(id)sender{
    intStateMent = 2;
    
    //------------------------
    boolBtnPlayPause = false;
    [playPause setBackgroundImage:[UIImage imageNamed:@"yesTouchPlay.png"] forState:UIControlStateNormal];
    //------------------------
    
    
    
    NSString *host = self.myTextIp;
    if ([host length] == 0) {
        [self logEror:@"Address required"];
        return;
    }
    
    int port = [self.myTextPort intValue];
    if (port <= 0 || port > 65535) {
        [self logEror:@"Valid port required"];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%d",intStateMent];
    if ([msg length] == 0) {
        [self logEror:@"Message required"];
        return;
    }
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
    [self logMessage:FORMAT(@"SNT (%i): %@",(int)tag,msg)];
    tag ++;
}

-(IBAction)button3:(id)sender{
    intStateMent = 3;
    
    //------------------------
    boolBtnPlayPause = false;
    [playPause setBackgroundImage:[UIImage imageNamed:@"yesTouchPlay.png"] forState:UIControlStateNormal];
    //------------------------
    
    
    NSString *host = self.myTextIp;
    if ([host length] == 0) {
        [self logEror:@"Address required"];
        return;
    }
    
    int port = [self.myTextPort intValue];
    if (port <= 0 || port > 65535) {
        [self logEror:@"Valid port required"];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%d",intStateMent];
    if ([msg length] == 0) {
        [self logEror:@"Message required"];
        return;
    }
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
    [self logMessage:FORMAT(@"SNT (%i): %@",(int)tag,msg)];
    tag ++;
}

-(IBAction)button4:(id)sender{
    intStateMent = 4;
    
    //------------------------
    boolBtnPlayPause = false;
    [playPause setBackgroundImage:[UIImage imageNamed:@"yesTouchPlay.png"] forState:UIControlStateNormal];
    //------------------------
    
    
    NSString *host = self.myTextIp;
    if ([host length] == 0) {
        [self logEror:@"Address required"];
        return;
    }
    
    int port = [self.myTextPort intValue];
    if (port <= 0 || port > 65535) {
        [self logEror:@"Valid port required"];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%d",intStateMent];
    if ([msg length] == 0) {
        [self logEror:@"Message required"];
        return;
    }
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
    [self logMessage:FORMAT(@"SNT (%i): %@",(int)tag,msg)];
    tag ++;
}

-(IBAction)button5:(id)sender{
    intStateMent = 5;
    
    //------------------------
    boolBtnPlayPause = false;
    [playPause setBackgroundImage:[UIImage imageNamed:@"yesTouchPlay.png"] forState:UIControlStateNormal];
    //------------------------
    
    
    NSString *host = self.myTextIp;
    if ([host length] == 0) {
        [self logEror:@"Address required"];
        return;
    }
    
    int port = [self.myTextPort intValue];
    if (port <= 0 || port > 65535) {
        [self logEror:@"Valid port required"];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%d",intStateMent];
    if ([msg length] == 0) {
        [self logEror:@"Message required"];
        return;
    }
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
    [self logMessage:FORMAT(@"SNT (%i): %@",(int)tag,msg)];
    tag ++;
}

//set property of video
-(IBAction)playPause:(id)sender{
    //send
    intStateMent = 6;
    //[playPause setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    
    //[playPause setBackgroundImage:[UIImage imageNamed:@"play-blue.png"] forState:UIControlStateHighlighted];
    
    
    boolBtnPlayPause = !boolBtnPlayPause;
    if (boolBtnPlayPause) {
        NSLog(@"zhe shi yi ge ce shi : %d",boolBtnPlayPause);
        [playPause setBackgroundImage:[UIImage imageNamed:@"noTouchPlay.png"] forState:UIControlStateNormal];
        //[playPause setBackgroundImage:nil forState:UIControlStateNormal];
    }
    else{
        [playPause setBackgroundImage:[UIImage imageNamed:@"yesTouchPlay.png"] forState:UIControlStateNormal];
        NSLog(@"zhe shi yi ge ce shi : %d",boolBtnPlayPause);
    }
    
    
    NSString *host = self.myTextIp;
    if ([host length] == 0) {
        [self logEror:@"Address required"];
        return;
    }
    
    int port = [self.myTextPort intValue];
    if (port <= 0 || port > 65535) {
        [self logEror:@"Valid port required"];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%d",intStateMent];
    if ([msg length] == 0) {
        [self logEror:@"Message required"];
        return;
    }
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
    [self logMessage:FORMAT(@"SNT (%i): %@",(int)tag,msg)];
    tag ++;
    
    
    //UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"1" message:@"2" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    //[alertView show];
}

-(IBAction)mute:(id)sender{
    intStateMent = 7;
    
    //----------
    boolBtnMute = !boolBtnMute;
    if (boolBtnMute) {
        [mute setBackgroundImage:[UIImage imageNamed:@"yesTouchMute.png"] forState:UIControlStateNormal];
        //[playPause setBackgroundImage:nil forState:UIControlStateNormal];
    }
    else{
        [mute setBackgroundImage:[UIImage imageNamed:@"noTouchMute.png"] forState:UIControlStateNormal];
    }
    //----------
    
    NSString *host = self.myTextIp;
    if ([host length] == 0) {
        [self logEror:@"Address required"];
        return;
    }
    
    int port = [self.myTextPort intValue];
    if (port <= 0 || port > 65535) {
        [self logEror:@"Valid port required"];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%d",intStateMent];
    if ([msg length] == 0) {
        [self logEror:@"Message required"];
        return;
    }
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
    [self logMessage:FORMAT(@"SNT (%i): %@",(int)tag,msg)];
    tag ++;
}

-(IBAction)playStop:(id)sender{
    intStateMent = 8;
    
    //[playStop setBackgroundImage:[UIImage imageNamed:@"noTouchStop.png"] forState:UIControlStateNormal];
    
    [playStop setBackgroundImage:[UIImage imageNamed:@"yesTouchStop.png"] forState:UIControlStateHighlighted];
    
    [playPause setBackgroundImage:[UIImage imageNamed:@"noTouchPlay.png"] forState:UIControlStateNormal];
    
    boolBtnPlayPause = !boolBtnPlayPause;
    //----------
    boolBtnPlayStop = !boolBtnPlayStop;
    /* if (boolBtnPlayStop) {
     [playStop setBackgroundImage:[UIImage imageNamed:@"yesTouchStop.png"] forState:UIControlStateNormal];
     //[playPause setBackgroundImage:nil forState:UIControlStateNormal];
     }
     else{
     [playStop setBackgroundImage:[UIImage imageNamed:@"noTouchStop.png"] forState:UIControlStateNormal];
     }
     */
    //----------
    
    NSString *host = self.myTextIp;
    if ([host length] == 0) {
        [self logEror:@"Address required"];
        return;
    }
    
    int port = [self.myTextPort intValue];
    if (port <= 0 || port > 65535) {
        [self logEror:@"Valid port required"];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%d",intStateMent];
    if ([msg length] == 0) {
        [self logEror:@"Message required"];
        return;
    }
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
    [self logMessage:FORMAT(@"SNT (%i): %@",(int)tag,msg)];
    tag ++;
}

-(IBAction)voiceAdd:(id)sender{
    intStateMent = 9;
    
    [voiceAdd setBackgroundImage:[UIImage imageNamed:@"noTouchAdd.png"] forState:UIControlStateNormal];
    [voiceAdd setBackgroundImage:[UIImage imageNamed:@"yesTouchAdd.png"] forState:UIControlStateHighlighted];
    //[playPause setBackgroundImage:nil forState:UIControlStateNormal];
    //----------
    
    NSString *host = self.myTextIp;
    if ([host length] == 0) {
        [self logEror:@"Address required"];
        return;
    }
    
    int port = [self.myTextPort intValue];
    if (port <= 0 || port > 65535) {
        [self logEror:@"Valid port required"];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%d",intStateMent];
    if ([msg length] == 0) {
        [self logEror:@"Message required"];
        return;
    }
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
    [self logMessage:FORMAT(@"SNT (%i): %@",(int)tag,msg)];
    tag ++;
}

-(IBAction)voiceMult:(id)sender{
    intStateMent = 10;
    
    
    [voiceMult setBackgroundImage:[UIImage imageNamed:@"yesTouchMult.png"] forState:UIControlStateHighlighted];
    [voiceMult setBackgroundImage:[UIImage imageNamed:@"noTouchMult.png"] forState:UIControlStateNormal];
    
    
    NSString *host = self.myTextIp;
    if ([host length] == 0) {
        [self logEror:@"Address required"];
        return;
    }
    
    int port = [self.myTextPort intValue];
    if (port <= 0 || port > 65535) {
        [self logEror:@"Valid port required"];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%d",intStateMent];
    if ([msg length] == 0) {
        [self logEror:@"Message required"];
        return;
    }
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
    [self logMessage:FORMAT(@"SNT (%i): %@",(int)tag,msg)];
    tag ++;
}

- (IBAction)shutDownPC:(id)sender {
    intStateMent = 11;
    NSString *host = self.myTextIp;
    if ([host length] == 0) {
        [self logEror:@"Address required"];
        return;
    }
    
    int port = [self.myTextPort intValue];
    if (port <= 0 || port > 65535) {
        [self logEror:@"Valid port required"];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%d",intStateMent];
    if ([msg length] == 0) {
        [self logEror:@"Message required"];
        return;
    }
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
    [self logMessage:FORMAT(@"SNT (%i): %@",(int)tag,msg)];
    tag ++;

}

-(void)logEror:(NSString *)msg{
    NSString *prefix = @"<font color =\"#B40404\">";
    NSString *suffix = @"</font><br/>";
    
    [log appendFormat:@"%@%@%@\n",prefix,msg,suffix];
}

-(void)logMessage:(NSString *)msg{
    NSString *prefix = @"<font color=\"#000000\">";
    NSString *suffix = @"</font><br/>";
    
    [log appendFormat:@"%@%@%@\n",prefix,msg,suffix];
}

- (void)logInfo:(NSString *)msg
{
	NSString *prefix = @"<font color=\"#6A0888\">";
	NSString *suffix = @"</font><br/>";
	
	[log appendFormat:@"%@%@%@\n", prefix, msg, suffix];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self dirHome];
    [self dirDoc];
    [self creatDir];
    [self creatFile];
    [self readFile];
    [self setInitValue];
    
    if (udpSocket == nil) {
        [self setupSocket];
    }
    
    [voiceAdd setBackgroundImage:[UIImage imageNamed:@"noTouchAdd.png"] forState:UIControlStateNormal];
    [voiceMult setBackgroundImage:[UIImage imageNamed:@"noTouchMult.png"] forState:UIControlStateNormal];
    
    [playPause setBackgroundImage:[UIImage imageNamed:@"noTouchPlay.png"] forState:UIControlStateNormal];
    [mute setBackgroundImage:[UIImage imageNamed:@"noTouchMute.png"] forState:UIControlStateNormal];
    [playStop setBackgroundImage:[UIImage imageNamed:@"noTouchStop.png"] forState:UIControlStateNormal];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
