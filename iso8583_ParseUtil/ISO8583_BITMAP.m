//
//  ISO8583_BITMAP.m
//  ISO8583_package
//
//  Created by xututu on 15/11/29.
//  Copyright © 2015年 Defore. All rights reserved.
//

#import "ISO8583_BITMAP.h"
#import "NSString+Trans.h"

@interface ISO8583_BITMAP()
@property (strong,nonatomic)NSMutableString *bin_bitMapContent;
@property (nonatomic) BOOL isExtend;
@end

@implementation ISO8583_BITMAP

- (instancetype)initWithIsExtent:(BOOL)isExtend{
    self = [super init];
    if (self) {
        self.isExtend = isExtend;
        NSMutableString *tempBin_bitMapContent = [[NSMutableString alloc] init];
        
        int len = self.isExtend?128:64;
        for (int i = 0 ; i < len; i++) {
            [tempBin_bitMapContent appendString:@"0"];
        }
        if (isExtend)
            [tempBin_bitMapContent replaceCharactersInRange:NSMakeRange(0, 1) withString:@"1"];
        
        self.bin_bitMapContent = tempBin_bitMapContent;
        [self updateBitMapContent];
        NSLog(@"初始化的域图二进制值 = %@",self.bitMapContent);
    }
    return self;
}

/**
 *  根据Domain ID 设定 BITMap BIT位
 */
- (void)setBitOfBitMapAccordingToDomainIndex:(NSUInteger) DomainID{
    int len = self.isExtend?128:64;
    if (DomainID >1 && DomainID <= len) //2~64,totolly 63 settable / 2~128,127 settable
        [self.bin_bitMapContent replaceCharactersInRange:NSMakeRange(DomainID-1, 1) withString:@"1"];
    else
        return ;
}

/**
 *  在setBitOfBitMapAccordingToDomainIndex 全部设置结束之后调用。更新BitMap内容
 */
-(void)updateBitMapContent{
    self.bitMapContent = [NSString BinaryToHex:self.bin_bitMapContent];
    NSLog(@"Binary_BitContent = %@",self.bin_bitMapContent);
    NSLog(@"BitMapContent = %@",self.bitMapContent);
}

@end
