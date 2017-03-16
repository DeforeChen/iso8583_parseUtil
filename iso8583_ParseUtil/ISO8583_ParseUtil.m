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
#import "NSString+Trans.h"
//#define DOMAIN_DEBUG //调试用，解包出来的内容标头会加上DomainID

@interface ISO8583_ParseUtil()
@property (copy,nonatomic) NSDictionary *domainLUT;
//组包时用的两个参数，域图与域内容
@property (strong,nonatomic) NSMutableArray *domainList;
@property (strong,nonatomic) ISO8583_BITMAP *bitMap;
@end

@implementation ISO8583_ParseUtil
#pragma mark pack part
+(instancetype)initWithIsExtend:(BOOL)isExtend {
    ISO8583_ParseUtil *util = [[ISO8583_ParseUtil alloc] init];
    if (util) {
        // 初始化域图及域内容
        util.bitMap     = [[ISO8583_BITMAP alloc] initWithIsExtent:isExtend];
        util.domainList = [NSMutableArray new];

        NSString *path = [[NSBundle mainBundle] pathForResource:@"DomainLUT" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        util.domainLUT = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
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


#pragma mark unpack part
-(NSArray *)unpackageISO8583Message:(NSString *)sourceDataOfISO8583Msg {
    sourceDataOfISO8583Msg = sourceDataOfISO8583Msg.uppercaseString;
    NSMutableArray *UnPackageArray = [[NSMutableArray alloc] init];
    //1. 先取出Message ID
    [UnPackageArray addObject:[sourceDataOfISO8583Msg substringWithRange:NSMakeRange(0, 4)]];
    
    //2. 先取出后续8个字节，转成2进制，判断最高位，为1表示扩展，就再取8个字节.
    NSMutableString *BitMap = [[NSMutableString alloc] init];
    [BitMap appendString:[sourceDataOfISO8583Msg substringWithRange:NSMakeRange(4, 16)] ];
    BOOL isExtent = [[[NSString HexToBinary:BitMap] substringToIndex:1] isEqualToString:@"1"];
    int CutLengthOfSrcData = isExtent?(4+32):(4+16);//截取长度,剩下的长度用来解包
    if (isExtent)
        [BitMap appendString:[sourceDataOfISO8583Msg substringWithRange:NSMakeRange(20, 16)]];
    
    [UnPackageArray addObject:BitMap];
    NSString *Binary_BitMap = [NSString HexToBinary:BitMap];
    
    //3.根据2进制的域图 Binary_BitMap, 组一个域元素信息数组 ISO8583_ElementInfoArray
    NSMutableArray *ISO8583_ElementInfoArray = [[NSMutableArray alloc] init];

    for (int i = 1; i < [Binary_BitMap length]; i++) {
        if ([[Binary_BitMap substringWithRange:NSMakeRange(i, 1)] isEqualToString: @"1"]) {
            NSString* keyName              = [NSString stringWithFormat:@"%d",i+1];
            NSDictionary *domainParamDict = self.domainLUT[keyName];
            
            NSUInteger domainIndex = [domainParamDict[DomainID] intValue];
            ISO8583_domain *domain = [ISO8583_domain initWithDomainID:domainIndex
                                                         occupyMaxLen:[domainParamDict[Max_Len] intValue]
                                                           occupyType:domainParamDict[OccupyType]
                                                             dataType:domainParamDict[DataType]
                                                        isLeftPadding:[domainParamDict[isLeft] intValue]];

            [ISO8583_ElementInfoArray addObject:domain];
        }
    }
    
    //4.将ISO8583_ElementInfoArray 数组, 砍掉消息类型+域图后的原始报文 传入
    NSArray *InfoArray = [self getSourceDataFromElementInfo:ISO8583_ElementInfoArray
                            SourceDataWithoutMsgIDAndBitMap:[sourceDataOfISO8583Msg substringFromIndex:CutLengthOfSrcData]];
    [UnPackageArray addObjectsFromArray:InfoArray];
    return UnPackageArray;

}

/**
 *  传入ISO8583_ElementInfoArray数组,逐一根据Info将 砍掉消息类型+域图后的原始报文 取出
 *
 *  @param ElementInfo    ISO8583_ElementInfoArray数组,包含每个调用域的信息
 *  @param RestSourceData 砍掉消息类型+域图后的原始报文
 *
 *  @return 返回原始数据组成的数组
 */
-(NSArray*)getSourceDataFromElementInfo: (NSArray*)ElementInfo
        SourceDataWithoutMsgIDAndBitMap:(NSString*)RestSourceData {
    NSLog(@"进来的截取的数据 = %@",RestSourceData);
    //1.定义一个block，当截取长度固定下来的时候，供底下switch调用
    __block NSMutableArray *InfoArray = [NSMutableArray new];
    __block int cutPosition = 0;//此变量用于获取每次截取段的起始位置
    void(^AppendInfoArrayWhenLengthIsEnsured)(ISO8583_domain*,BOOL,NSUInteger) = ^(ISO8583_domain *element,BOOL isFlexible,NSUInteger cutLength){
        // 1) 判断数据类型asc类型截取长度要翻倍
        cutLength = isFlexible?element.ocupyMaxLen:cutLength;
        // 2) 判断数据类型
        if ([element.data_type isEqualToString: ASCII]) { //长度会翻倍
            NSString *SrcDataWithAsciiToHex = [NSString ascToHex:[RestSourceData substringWithRange:NSMakeRange(cutPosition, cutLength*2)]];
            NSLog(@"asc = %@,hex = %@",[RestSourceData substringWithRange:NSMakeRange(cutPosition, cutLength*2)],SrcDataWithAsciiToHex);
#ifdef DOMAIN_DEBUG
            [InfoArray addObject:[NSString stringWithFormat:@"%lu_%@",element.index,SrcDataWithAsciiToHex]];
#else
            [InfoArray addObject:SrcDataWithAsciiToHex];
#endif
            cutPosition  += cutLength*2;//截取后移动截取位置,ascii类型长度翻倍
        } else { // 其余数据类型截取长度相等
#ifdef DOMAIN_DEBUG
            [InfoArray addObject:[NSString stringWithFormat:@"%lu_%@",element.index,[RestSourceData substringWithRange:NSMakeRange(cutPosition, cutLength)]]];
#else
            [InfoArray addObject:[RestSourceData substringWithRange:NSMakeRange(cutPosition, cutLength)]];
#endif
            NSLog(@"可变长的时候 %@",[RestSourceData substringWithRange:NSMakeRange(cutPosition, cutLength)]);
            cutPosition  += cutLength;//截取后移动截取位置
        }
        NSLog(@"DomainID = %lu",element.index);
    };
    
    //2.轮询数组中的emelemt,根据len_type确定长度,调用上面的block，将转换后的数据存入数组
    for (ISO8583_domain *element in ElementInfo) {
        //        int CutPosition = 0;//此变量用于获取每次截取段的起始位置
        if ([element.len_type isEqualToString:FLEXIBLE_LEN]) {
            AppendInfoArrayWhenLengthIsEnsured(element,YES,0);
        } else if ([element.len_type isEqualToString:LLLVAR_999]) {
            // 获取长度信息，然后LLLVAR截取光标 >> 4
            NSInteger VarLengthInfo = [[RestSourceData substringWithRange:NSMakeRange(cutPosition, 4)] integerValue];
            cutPosition += 4;
            
            if (VarLengthInfo > element.ocupyMaxLen) {
                [InfoArray addObject:@"LLLvar出错,可变长度超过最大长度!"];
                break;
            } else
                AppendInfoArrayWhenLengthIsEnsured(element,NO,VarLengthInfo);
        } else if ([element.len_type isEqualToString:LLVAR_99]) {
            // 获取长度信息，然后LLLVAR截取光标 >> 8
            NSInteger VarLengthInfo = [[RestSourceData substringWithRange:NSMakeRange(cutPosition, 2)] integerValue];
            cutPosition += 2;
            
            if (VarLengthInfo > element.ocupyMaxLen) {
                [InfoArray addObject:@"llvar出错,可变长度超过最大长度!"];
                return nil;
            } else
                AppendInfoArrayWhenLengthIsEnsured(element,NO,VarLengthInfo);
        } else
            [InfoArray addObject:@"other var的类型尚未定义"];
    }
    return InfoArray;
}

@end

