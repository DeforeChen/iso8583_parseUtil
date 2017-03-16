//
//  ISO8583_ParseUtil.h
//  iso8583_ParseUtil
//
//  Created by Chen Defore on 2017/3/15.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "domainNames.h"

@interface ISO8583_ParseUtil : NSObject
/**
 初始化8583工具

 @param isExtend 定义是否有扩展，扩展条件为128且最高位为1，不扩展情况为64位全零
 @return 工具
 */
+(instancetype)initWithIsExtend:(BOOL)isExtend;
/*
 ---------------------------------------
 8583 包打包部分
 ---------------------------------------
*/


/**
 添加8583域

 @param domainName 域名, 可在domainName.h中查询
 @param content 域内容
 */
-(void)appendDomain:(NSString*)domainName
      DomainContent:(NSString*)content;


/**
 结束域添加
 */
-(void)finishAppendingDomain;


/**
 打包8583包

 @return 返回打包好的8583包字符串(明文)
 */
-(NSString*)packISO8583Data;
@end
