//
//  ViewController.m
//  iso8583_ParseUtil
//
//  Created by Chen Defore on 2017/3/15.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "ViewController.h"
#import "ISO8583_ParseUtil.h"
@interface ViewController ()
@property (strong,nonatomic) ISO8583_ParseUtil *util;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.util = [ISO8583_ParseUtil initWithIsExtend:NO];
    

}
- (IBAction)pack8583:(id)sender {
    [self.util appendDomain:MSG_TYPE_INDICATOR DomainContent:@"0800"];//FLEX,BCD
    [self.util appendDomain:SYSTEMS_TRACE_AUDIT_NUMBER DomainContent:@"000008"];//FLEX,BCD
    [self.util appendDomain:CARD_ACCEPTOR_TERMI_IDENTIFICATION DomainContent:@"000001"];//FLEX,ASC
    [self.util appendDomain:CARD_ACCEPTOR_IDENTIFICATION_CODE DomainContent:@"805320000000002"];//FLEX,ASC
    [self.util appendDomain:RESERVED_PRIVATE_0 DomainContent:@"000000010040"];//LLLVAR,BCD
    [self.util appendDomain:RESERVED_PRIVATE_2 DomainContent:@"5aa5"];//BINARY,LLLVAR
    [self.util appendDomain:RESERVED_PRIVATE_3 DomainContent:@"00001"];//ASC,LLLVAR
    
    [self.util finishAppendingDomain];
    NSString *packMsg = [self.util packISO8583Data];
    NSLog(@"pack message = %@",packMsg);
}

- (IBAction)unpack8583:(id)sender {
    // 解包
    NSArray *unpack = [self.util unpackageISO8583Message:@"08000020000000c000160000083030303030313030383035333230303030303030303032001200000001004000045aa500053030303031"];
    NSLog(@"解包数据 = %@",unpack);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
