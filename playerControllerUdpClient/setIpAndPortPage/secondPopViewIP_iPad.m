//
//  secondPopViewIP_iPad.m
//  playerControllerUdpClient
//
//  Created by stone on 14-4-22.
//  Copyright (c) 2014年 stone. All rights reserved.
//

#import "secondPopViewIP_iPad.h"
#import "dateDelegate.h"

@interface secondPopViewIP_iPad ()

@end

@implementation secondPopViewIP_iPad
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
    [self dirHome];
    [self dirDoc];
    
    NSString *documentPath = [self dirDoc];
    NSString *testDirectory = [documentPath stringByAppendingPathComponent:@"UDPTest"];
    NSString *testPathIp = [testDirectory stringByAppendingPathComponent:@"UDPTest.txt"];
    NSString *testPathPort = [testDirectory stringByAppendingPathComponent:@"UDPTestPort.txt"];
    textFieldIp.text = [NSString stringWithContentsOfFile:testPathIp encoding:NSUTF8StringEncoding error:nil];
    textFieldPort.text = [NSString stringWithContentsOfFile:testPathPort encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"文件读取成功 ： %@",content);
    //[self creatDir];
    // Do any additional setup after loading the view from its nib.
}

//获取应用沙盒的根路径
-(void)dirHome{
    //NSString *dirHome = NSHomeDirectory();
    NSHomeDirectory();
    //NSLog(@"app_home: %@",dirHome);
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
//        if (res) {
//            NSLog(@"文件夹创建成功");
//        }
//        else{
//            NSLog(@"文件夹创建失败");
//        }
    }
}

//创建文件
-(void)creatFile{
    NSString *documentsPath = [self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"UDPTest"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"UDPTest.txt"];
    NSString *testPathPort = [testDirectory stringByAppendingString:@"UDPTestPort.txt"];
    //BOOL res = [fileManager removeItemAtPath:testPath error:nil];
    //
    if (![fileManager fileExistsAtPath:testPath]) {
       [fileManager createFileAtPath:testPath contents:nil attributes:nil];
    }
    // NSLog(@"文件是否存在：%@",[fileManager fileExistsAtPath:testPath]?@"yes":@"no");
    
    if (![fileManager fileExistsAtPath:testPathPort]) {
        [fileManager createFileAtPath:testPathPort contents:nil attributes:nil];
    }
}

//写文件
//-(void)writeFile{
//    NSString *documentsPath = [self dirDoc];
//    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"UDPTest"];
//    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"UDPTest.txt"];
//    NSString *content = self.textFieldIp.text;
//    BOOL res = [content writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    if (res) {
//        NSLog(@"文件写入成功： %@",content);
//    }else NSLog(@"文件写入失败");
//}

//读取文件
//-(void)readFile{
//    NSString *documentPath = [self dirDoc];
//    NSString *testDirectory = [documentPath stringByAppendingPathComponent:@"UDPTest"];
//    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"UDPTest.txt"];
//    NSString *content = [NSString stringWithContentsOfFile:testPath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"文件读取成功 ： %@",content);
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnOk:(id)sender {
    dateDelegate *date_delegate_iPad = [[dateDelegate alloc]init];
    date_delegate_iPad.textIp = self.textFieldIp.text;
    date_delegate_iPad.textPort = self.textFieldPort.text;
    
    NSString *documentsPath = [self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"UDPTest"];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"UDPTest.txt"];
    NSString *testPathPort = [testDirectory stringByAppendingPathComponent:@"UDPTestPort.txt"];
    NSString *contentIp = self.textFieldIp.text;
    NSString *contentPort = self.textFieldPort.text;
    [contentIp writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [contentPort writeToFile:testPathPort atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [self.delegate passValue:date_delegate_iPad];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
