//
//  ISO8583_BITMAP.h
//  ISO8583_package
//
//  Created by xututu on 15/11/29.
//  Copyright © 2015年 Defore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISO8583_BITMAP : NSObject
@property (copy,nonatomic) NSString *bitMapContent;

/**
 根据域名索引 设定 BITMap BIT位
 @param domainIndex 域名索引
 */
- (void)setBitOfBitMapAccordingToDomainIndex:(NSUInteger) domainIndex;

/**
 *  在setBitOfBitMapAccordingToDomainID 全部设置结束之后调用。更新BitMap内容
 */
- (void)updateBitMapContent;

/**
 *  初始化域图内容
 *
 *  @param isExtend 根据isExtend判断是64/128位图
 */
- (instancetype)initWithIsExtent:(BOOL)isExtend;
@end
