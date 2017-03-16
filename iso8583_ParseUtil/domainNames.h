//
//  domainNames.h
//  iso8583_ParseUtil
//
//  Created by Chen Defore on 2017/3/16.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#ifndef domainNames_h
#define domainNames_h

/* 000 */#define MSG_TYPE_INDICATOR     @"0"
/* 001 */#define BITMAP_EXTEND          @"1"
/* 002 */#define PRIMARY_ACCOUNT_NUM    @"2"
/* 003 */#define PROCESS_CODE           @"3"
/* 004 */#define TRANSACTION_AMOUNT     @"4"
/* 005 */#define SETTLEMENT_AMOUNT      @"5"
/* 006 */#define CARDHOLDER_AMOUNT      @"6"
/* 007 */#define DATE_AND_TIME_TRANSMISSION         @"7"
/* 008 */#define Cardholder_billing_fee_Amount      @"8"
/* 009 */#define CONVERSION_RATE_RECONCILIATION     @"9"
/* 010 */#define CONVERSION_RATE_CARDHOLDER_BILLING @"10"
/* 011 */#define SYSTEMS_TRACE_AUDIT_NUMBER         @"11"
/* 012 */#define DATE_AND_TIME_LOCAL_TRANSACTION    @"12"
/* 013 */#define DATE_EFFECTIVE                     @"13"
/* 014 */#define DATE_EXPIRATION                    @"14"
/* 015 */#define DATE_SETTLEMENT                    @"15"
/* 016 */#define DATE_CONVERSION                    @"16"
/* 017 */#define DATE_CAPTURE                       @"17"
/* 018 */#define MERCHANT_TYPE                      @"18"
/* 019 */#define COUNTRY_CODE_ACQUIRING_INSTITUTION     @"19"
/* 020 */#define COUNTRY_CODE_PRIMARY_ACCOUNT_NUMBER    @"20"
/* 021 */#define COUNTRY_CODE_FORWARDING_INSTITUTION    @"21"
/* 022 */#define POINT_OF_SERVICE_DATA_CODE             @"22"
/* 023 */#define CARD_SEQUENCE_NUMBE                    @"23"
/* 024 */#define NETWORK_INTERNATIONAL_ID               @"24"
/* 025 */#define POINT_OF_SERVICE_CONDITION_CODE        @"25"
/* 026 */#define POINT_OF_SERVICE_PIN_CAPTURE_CODE      @"26"
/* 027 */#define AUTHORIZATION_IDENTIFICATION_RESP_LEN  @"27"
/* 028 */#define AMOUNT_TRANSACTION_FEE             @"28"
/* 029 */#define AMOUNT_SETTLEMENT_FEE              @"29"
/* 030 */#define AMOUNT_TRANSACTION_PROCESSING_FEE  @"30"
/* 031 */#define AMOUNT_SETTLEMENT_PROCESSING_FEE   @"31"
/* 032 */#define ACQUIRER_INSTITUTION_IDENT_CODE    @"32"
/* 033 */#define FORWARDING_INSTITUTION_IDENT_CODE  @"33"
/* 034 */#define PAN_EXTENDED                       @"34"
/* 035 */#define TRACK_2_DATA                       @"35"
/* 036 */#define TRACK_3_DATA                       @"36"
/* 037 */#define RETRIEVAL_REFERENCE_NUM            @"37"
/* 038 */#define APPROVAL_CODE                      @"38"
/* 039 */#define RESPONSE_CODE                      @"39"
/* 040 */#define SERVICE_RESTRICTION_CODE           @"40"
/* 041 */#define CARD_ACCEPTOR_TERMI_IDENTIFICATION @"41"
/* 042 */#define CARD_ACCEPTOR_IDENTIFICATION_CODE  @"42"
/* 043 */#define CARD_ACCEPTOR_NAME_LOCATION        @"43"
/* 044 */#define ADDITIONAL_RESPONSE_DATA           @"44"
/* 045 */#define TRACK_1_DATA                       @"45"
/* 046 */#define ADITIONAL_DATA_ISO                 @"46"
/* 047 */#define ADITIONAL_DATA_NATIONAL            @"47"
/* 048 */#define ADITIONAL_DATA_PRIVATE             @"48"
/* 049 */#define CURRENCY_CODE_TRANSACTION          @"49"
/* 050 */#define CURRENCY_CODE_SETTLEMENT           @"50"
/* 051 */#define CURRENCY_CODE_CARDHOLDER_BILLING   @"51"
/* 052 */#define PERSONAL_PIN_DATA                  @"52"
/* 053 */#define SECUR_RELATED_CTRL_INFO            @"53"
/* 054 */#define AMOUNTS_ADDITIONAL                 @"54"
/* 055 */#define RESERVED_ISO_0                     @"55"
/* 056 */#define RESERVED_ISO_1                     @"56"
/* 057 */#define RESERVED_NATIONAL_0                @"57"
/* 058 */#define RESERVED_NATIONAL_1                @"58"
/* 059 */#define RESERVED_NATIONAL_2                @"59"
/* 060 */#define RESERVED_PRIVATE_0                 @"60"
/* 061 */#define RESERVED_PRIVATE_1                 @"61"
/* 062 */#define RESERVED_PRIVATE_2                 @"62"
/* 063 */#define RESERVED_PRIVATE_3                 @"63"
/* 064 */#define MSG_AUTHENTICATION_CODE_FIELD      @"64"


///* 065 */ IFB_BINARY(8, "BITMAP, EXTENDED"),
///* 066 */ IF_CHAR(1, "SETTLEMENT CODE"),
///* 067 */ Extended payment data", true),
///* 068 */ Country code, receiving institution",
///* 069 */ Country code, settlement institution",
///* 070 */ Country code, authorizing agent Inst.", true),
///* 071 */  4, "Message number", true),
///* 072 */  4, "MESSAGE NUMBER LAST", true),
///* 073 */ IF_CHAR(6, "DATE ACTION"),
///* 074 */  10, "Credits, number", true),
///* 075 */  10, "Credits, reversal number", true),
///* 076 */  10, "Debits, number", true),
///* 077 */  10, "Debits, reversal number", true),
///* 078 */  10, "Transfer, number", true),
///* 079 */  10, "Transfer, reversal number", true),
///* 080 */  10, "Inquiries, number", true),
///* 082 */ IFB_LLNUM(12, "CREDITS, PROCESSING FEE AMOUNT", true),
///* 083 */ IFB_LLNUM(12, "CREDITS, TRANSACTION FEE AMOUNT", true),
///* 084 */ IFB_LLNUM(12, "DEBITS, PROCESSING FEE AMOUNT", true),
///* 085 */ IFB_LLNUM(12, "DEBITS, TRANSACTION FEE AMOUNT", true),
//
///* 086 */ IFB_LLNUM(16, "Credits, amount", true),
///* 087 */ IFB_LLNUM(16, "Credits, reversal amount", true),
///* 088 */ IFB_LLNUM(16, "Debits, amount", true),
///* 089 */ IFB_LLNUM(16, "Debits, reversal amount", true),
//
///* 090 */ ORIGINAL_DATA_ELEMENTS,
///* 091 */ FILE UPDATE_CODE,
///* 092 */ FILE SECURITY_CODE,
///* 093 */ RESPONSE INDICATOR,
///* 094 */ SERVICE INDICATOR,
///* 095 */ REPLACEMENT AMOUNTS,
///* 096 */ MSG_SECURITY_CODE,
//
///* 097 */ AMOUNT_NET_RECONCILIATION,
///* 098 */ PAYEE,
///* 099 */ SETTLEMENT_INSTITUTION_ID_CODE,
///* 100 */ RECEIVING_INSTITUTION_ID_CODE,
///* 101 */ FILE_NAME,
///* 102 */ ACCOUNT_IDENTIFICATION_1,
///* 103 */ ACCOUNT_IDENTIFICATION_2,
///* 104 */ TRANSACT_ON_ESCRIPTION,
///* 105 */ RESERVED_FOR_ISO_USE,
///* 106 */ RESERVED_FOR_ISO_USE,
///* 107 */ RESERVED_FOR_ISO_USE,
///* 108 */ RESERVED_FOR_ISO_USE,
///* 109 */ RESERVED_FOR_ISO_USE,
///* 110 */ RESERVED_FOR_NATIONAL_USE,
///* 111 */ RESERVED_FOR_NATIONAL_USE,
///* 112 */ RESERVED_FOR_NATIONAL_USE,
///* 113 */ RESERVED_FOR_NATIONAL_USE,
///* 114 */ RESERVED_FOR_NATIONAL_USE,
///* 115 */ RESERVED_FOR_NATIONAL_USE,
///* 116 */ RESERVED_FOR_NATIONAL_USE,
///* 117 */ RESERVED_FOR_PRIVATE_USE,
///* 118 */ RESERVED_FOR_PRIVATE_USE,
///* 119 */ RESERVED_FOR_PRIVATE_USE,
///* 120 */ RESERVED_FOR_PRIVATE_USE,
///* 121 */ RESERVED_FOR_PRIVATE_USE,
///* 122 */ RESERVED_FOR_PRIVATE_USE,
///* 123 */ RESERVED_FOR_PRIVATE_USE,
///* 124 */ RESERVED_FOR_PRIVATE_USE,
///* 125 */ RESERVED_FOR_PRIVATE_USE,
///* 126 */ RESERVED_FOR_PRIVATE_USE,
///* 127 */ RESERVED_FOR_PRIVATE_USE,
///* 128 */ MSG_AUTHENTICATION_CODE_FIELD,



#endif /* domainNames_h */
