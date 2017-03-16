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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 组包
    ISO8583_ParseUtil *util = [ISO8583_ParseUtil initWithIsExtend:NO];
    [util appendDomain:MSG_TYPE_INDICATOR DomainContent:@"0800"];//FLEX,BCD
    [util appendDomain:SYSTEMS_TRACE_AUDIT_NUMBER DomainContent:@"000008"];//FLEX,BCD
    [util appendDomain:CARD_ACCEPTOR_TERMI_IDENTIFICATION DomainContent:@"000001"];//FLEX,ASC
    [util appendDomain:CARD_ACCEPTOR_IDENTIFICATION_CODE DomainContent:@"805320000000002"];//FLEX,ASC
    [util appendDomain:RESERVED_PRIVATE_0 DomainContent:@"000000010040"];//LLLVAR,BCD
    [util appendDomain:RESERVED_PRIVATE_2 DomainContent:@"5AA5"];//BINARY,LLLVAR
    [util appendDomain:RESERVED_PRIVATE_3 DomainContent:@"00001"];//ASC,LLLVAR
    
    [util finishAppendingDomain];
    NSString *packMsg = [util packISO8583Data];
    NSLog(@"pack message = %@",packMsg);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
