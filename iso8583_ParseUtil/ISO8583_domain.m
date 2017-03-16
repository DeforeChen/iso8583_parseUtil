//
//  ISO8583_domain.m
//  ISO8583_package
//
//  Created by xututu on 15/11/27.
//  Copyright © 2015年 Defore. All rights reserved.
//

#import "ISO8583_domain.h"
#import "AppDelegate.h"
#import "NSString+Trans.h"
@interface ISO8583_domain()
@property(copy,nonatomic) setRelatedBitMap setBitMapBlk;
@end

@implementation ISO8583_domain
/**
 *  初始化每个 ISO8583 域元素
 *
 *  @param index         域编号(不同于BitID 的位编号，域编号=位编号-1，message_id视为域0)
 *  @param ocupyMaxLen   每个域最大可占用空间大小
 *  @param len_type      空间大小为定长/不定长
 *  @param data_type     消息内容类型，BCD/BINARY/ASCII
 *  @param isLeftPadding 是否左端填充
 *
 *  @return 单个ISO8583域元素
 */
+(instancetype)initWithDomainID: (NSUInteger)index
                   occupyMaxLen: (NSUInteger)ocupyMaxLen
                     occupyType: (NSString*)len_type
                       dataType: (NSString*)data_type
                  isLeftPadding: (NSUInteger)isLeftPadding {

    ISO8583_domain *element = [[ISO8583_domain alloc] init];
    if (element) {
        element.index         = index;
        element.ocupyMaxLen   = ocupyMaxLen;
        if (len_type == nil) {
            NSLog(@"DomainLUT.json中未设置对应域 %lu，请根据需求填充后使用",(unsigned long)index);
        } else {
            element.len_type      = len_type;
            element.data_type     = data_type;
            element.isLeftPadding = isLeftPadding;
        }
    }
    return element;
}

/**
 *  根据域名定义描述，填装ISO8583单个域内容
 *
 *  @param DomainContent 单个元素内的报文内容
 *
 *  @return 处理后的内容
 */
-(NSString*) setDomainContent:(NSString*)DomainContent setBitMapWhenComplete:(setRelatedBitMap)blk{
    NSLog(@"set domain bit %lu",self.index);
    //0域是message ID与BITMAP无关，1域是扩展，已在clearBitMapContentAndSetExtent设置
    if (self.index != 1){
        //1.判断是否超过最大长度
        if ([DomainContent length] > self.ocupyMaxLen)
            return @"超过最大长度";
        
        //2.1 定长，调用定长填充方式
        self.setBitMapBlk = blk;
        if ([self.len_type isEqualToString:FLEXIBLE_LEN])
            return [self packElementWhenLengthIsFlexible:DomainContent];
        else //2.2 不定长，调用不定长填充方式
            return [self packElementWhenLengthIsVariable:DomainContent];
    } else
        return @"不允许设定的域";
}

#pragma mark -setDomainContent需要调用到的子函数
/**
 *  定长时，根据对齐方式和数据类型填充数据，然后返回给 setDomainContent
 *
 *  @param DomainContent 原始数据
 *
 *  @return 返回填充好的数据
 */
- (NSString*)packElementWhenLengthIsFlexible:(NSString*)DomainContent{
    //1. define a string ,padding with "0"
    NSMutableString *String = [[NSMutableString alloc] init];
    for (int i = 0; i < self.ocupyMaxLen; i++) {
        [String appendString:@"0"];
    }
    //2. pad the String with DomainContent according to "isLeft"
    if (self.isLeftPadding == 1)
        [String replaceCharactersInRange:NSMakeRange(0, [DomainContent length]) withString:DomainContent];
    else
        [String replaceCharactersInRange:NSMakeRange([String length]-[DomainContent length], [DomainContent length]) withString:DomainContent];
    //3. 根据BCD,BINARY/ASCII返回数据
    if ([self.data_type isEqualToString:BCD] || [self.data_type isEqualToString:BINARY]){
        self.setBitMapBlk();//执行回调，对应位置位
        return String;
    } else if ([self.data_type isEqualToString: ASCII]) {
        self.setBitMapBlk();//执行回调，对应位置位
        return [NSString hexToAsc:String];
    } else
        return @"不接收的数据类型\n";
}

/**
 *  不定长时，根据可变长度类型和数据类型填充数据，然后返回给 setDomainContent
 *
 *  @param DomainContent 源数据
 *
 *  @return 返回填充好的数据
 */
- (NSString*)packElementWhenLengthIsVariable:(NSString*)DomainContent{
    //1. 根据data type对数据做处理
    NSMutableString *String = [[NSMutableString alloc] init];
    if ([self.data_type isEqualToString:BCD] || [self.data_type isEqualToString:BINARY])
        [String appendString:DomainContent];
    else if ([self.data_type isEqualToString: ASCII])
        [String appendString:[NSString hexToAsc:DomainContent]];
    else
        return [NSString stringWithFormat:@"不接收数据类型 %@",self.data_type];;
    
    //2. 根据不定长度类型len_type添加长度前缀
    NSString *len = [NSString stringWithFormat:@"%lu",[DomainContent length]];
    if ([self.len_type isEqualToString: LLLVAR_999]) {
        NSMutableString *LengthPrefix = [NSMutableString stringWithFormat:@"0000"];
        [LengthPrefix replaceCharactersInRange:NSMakeRange(4-[len length], [len length]) withString:len];
        [String insertString:LengthPrefix atIndex:0];
        self.setBitMapBlk();//执行回调，对应位置位
        return String;
    } else if ([self.len_type isEqualToString: LLVAR_99]) {
        NSMutableString *LengthPrefix = [NSMutableString stringWithFormat:@"00"];
        [LengthPrefix replaceCharactersInRange:NSMakeRange(2-[len length], [len length]) withString:len];
        [String insertString:LengthPrefix atIndex:0];
        self.setBitMapBlk();//执行回调，对应位置位
        return String;
    } else
        return [NSString stringWithFormat:@"不接收的可变长度类型 %@\n",self.len_type];
}
@end
