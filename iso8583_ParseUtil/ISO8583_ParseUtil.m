//
//  ISO8583_ParseUtil.m
//  iso8583_ParseUtil
//
//  Created by Chen Defore on 2017/3/15.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "ISO8583_ParseUtil.h"
#import "ISO8583_BITMAP.h"
#import "ISO8583_domain.h"

@interface ISO8583_ParseUtil()
@property (copy,nonatomic) NSDictionary *domainLUT;
@property (strong,nonatomic) NSMutableArray *domainList;
@property (strong,nonatomic) ISO8583_BITMAP *bitMap;
@end

@implementation ISO8583_ParseUtil

+(instancetype)initWithIsExtend:(BOOL)isExtend {
    ISO8583_ParseUtil *util = [[ISO8583_ParseUtil alloc] init];
    if (util) {
        // 初始化域图及域内容
        util.bitMap     = [[ISO8583_BITMAP alloc] initWithIsExtent:isExtend];
        util.domainList = [NSMutableArray new];

        NSString *path = [[NSBundle mainBundle] pathForResource:@"DomainLUT" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        util.domainLUT = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"domain LUT = %@",util.domainLUT);
    }
    return util;
}

-(void)appendDomain:(NSString *)domainName DomainContent:(NSString *)content {
    NSDictionary *domainParamDict = [self.domainLUT objectForKey:domainName];
    NSUInteger domainIndex = [domainParamDict[DomainID] intValue];
    ISO8583_domain *domain = [ISO8583_domain initWithDomainID:domainIndex
                                                 occupyMaxLen:[domainParamDict[Max_Len] intValue]
                                                   occupyType:domainParamDict[OccupyType]
                                                     dataType:domainParamDict[DataType]
                                                isLeftPadding:[domainParamDict[isLeft] intValue]];
    [self.domainList addObject:[domain setDomainContent:content setBitMapWhenComplete:^{
        [self.bitMap setBitOfBitMapAccordingToDomainIndex:domainIndex];//设置域时，BitMap对应的域置位
    }]];
}

-(void)finishAppendingDomain {
    [self.bitMap updateBitMapContent];
}

-(NSString *)packISO8583Data {
    //1.insert BitMap Content (DomainID = 1) to the Array
    [self.domainList insertObject:self.bitMap.bitMapContent atIndex:1];
    NSMutableString *message = [NSMutableString new];
    for (NSString* element in self.domainList) {
        [message appendString:element];
    }
    return message;
}

@end

