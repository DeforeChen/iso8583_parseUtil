//
//  ISO8583_domain.h
//  ISO8583_package
//
//  Created by xututu on 15/11/27.
//  Copyright © 2015年 Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DomainID @"domainID"
#define Max_Len @"OccupyMaxLen"
#define OccupyType @"OccupyType"
#define DataType @"DataType"
#define isLeft @"isLeftPadding" 

/* LengthType */
#define FLEXIBLE_LEN    @"FLEXIBLE_LEN"
#define LLVAR_99        @"LLVAR_99"
#define LLLVAR_999      @"LLLVAR_999"
#define OTHENR_LEN_TYPE @"OTHENR_LEN_TYPE"

/* DataType */
#define BCD     @"BCD"
#define BINARY  @"BINARY"
#define ASCII   @"ASCII"

typedef void(^setRelatedBitMap)();

@interface ISO8583_domain : NSObject
@property (nonatomic,assign) NSUInteger index;
@property (nonatomic,assign) NSUInteger ocupyMaxLen;
@property (nonatomic,copy)   NSString* len_type;
@property (nonatomic,copy)   NSString* data_type;
@property (nonatomic,assign) NSUInteger isLeftPadding;

/**
 *  初始化每个 ISO8583 域元素
 *
 *  @param index      域编号(不同于BitID 的位编号，域编号=位编号-1，message_id视为域0)
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
                  isLeftPadding: (NSUInteger)isLeftPadding;

/**
 *  根据域名定义描述，填装ISO8583单个域内容
 *
 *  @param DomainContent 单个元素内的报文内容
 *  @param blk 写入域内容成功时进行回调
 *  @return 处理后的内容
 */
-(NSString*) setDomainContent:(NSString*)DomainContent setBitMapWhenComplete:(setRelatedBitMap)blk;
@end
