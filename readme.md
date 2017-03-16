## 导入
* 打开`iso8583_ParseUtil` demo工程，将所有`util`下的文件拖入你的工程。
* 在你的工程中导入
```objc
#import "ISO8583_ParseUtil.h"
```
* `DomainLUT.json`的说明
因为8583包的使用不一而足，很多厂家或设备给句具体的需求，对特定域（如常用的55域）或不定长域的内容是不尽相同的。因此我这里用了一个`JSON`文件将需要的几个参数.如果需要修改，请直接在`JSON`文件中修改
  * `OccupyMaxLen` -- 占据的最大空间
  * `OccupyType`   -- 空间长度的模式，定长/不定长
  * `DataType`     -- 数据格式，BCD,ASCII,BINARY
  * `isLeftPadding`-- 填充是否从左侧开始

## 初始化
```objc
[ISO8583_ParseUtil initWithIsExtend:NO];
```

## 打包
* 对应域内写入对应的内容. `appendDomain:DomainContent`
* 结束填充后调用结束的信息，这样工具会去更新域图 `finishAppendingDomain`
* 打包并获取字符串数据 `packISO8583Data`
Example:
```objc
    [self.util appendDomain:MSG_TYPE_INDICATOR DomainContent:@"0800"];//FLEX,BCD
    [self.util appendDomain:SYSTEMS_TRACE_AUDIT_NUMBER DomainContent:@"000008"];//FLEX,BCD
    [self.util appendDomain:CARD_ACCEPTOR_TERMI_IDENTIFICATION DomainContent:@"000001"];//FLEX,ASC
    [self.util appendDomain:CARD_ACCEPTOR_IDENTIFICATION_CODE DomainContent:@"805320000000002"];//FLEX,ASC
    [self.util appendDomain:RESERVED_PRIVATE_0 DomainContent:@"000000010040"];//LLLVAR,BCD
    [self.util appendDomain:RESERVED_PRIVATE_2 DomainContent:@"5aa5"];//BINARY,LLLVAR
    [self.util appendDomain:RESERVED_PRIVATE_3 DomainContent:@"00001"];//ASC,LLLVAR
    
    [self.util finishAppendingDomain];
    NSString *packMsg = [self.util packISO8583Data];
```

## 解包
Example:
```objc
NSArray *unpack = [self.util unpackageISO8583Message:@"08000020000000c000160000083030303030313030383035333230303030303030303032001200000001004000045aa500053030303031"];
```