//
//  Header.h
//  KDBCommon
//
//  Created by YY on 15/7/23.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#ifndef KDBCommon_Macro_h
#define KDBCommon_Macro_h

#define kAPPBlueColor  [UIColor colorWithHex:0x48b0ef]
#define kSelectedBackGroundColor  [UIColor colorWithHex:0xdddddd]


    #ifndef kScreenWidth
        #define kScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])
    #endif

    #ifndef kScreenHeight
        #define kScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])
    #endif

    #if 0
        #define MYLog(...) NSLog(__VA_ARGS__)
    #else
        #define MYLog(...) {}
    #endif
#endif
