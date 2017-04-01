//
//  MPBaseView.h
//  Pods
//
//  Created by liu nian on 2017/3/27.
//
//

#import <UIKit/UIKit.h>

//字符串是否为空
#ifndef isMPNULLString

#define isMPNULLString(__string__) \
(__string__==nil || \
![__string__ isKindOfClass:[NSString class]] || \
[__string__ isEqualToString:@""] || \
[__string__ isEqualToString:@"<null>"] || \
[__string__ isKindOfClass:[NSNull class]] || \
[[__string__ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

#endif
/************************color config*********************/
/**
 *  RGBAcolor
 */
#define kMPColorA(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
/**
 *  RGBcolor
 */
#define kMPColor(R,G,B) kMPColorA(R,G,B,1.0)
/**
 *  color with value
 */
#define kMPColorValue(value) kMPColorA(value,value,value,1.0)
/**
 *  16进制color
 */
#define kMPColor_hex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kMPColor_1 kMPColor(20,148,255)       //通用模块主基色蓝色
#define kMPColor_1H kMPColor(26,126,217)
#define kMPColor_1h kMPColor(232, 241, 250)
#define kMPColor_1D kMPColor(204, 204, 204)
#define kMPColor_2 kMPColor(255,100,110)       //红色
/**
 *   弱1(用于分隔模块或者背景的底色)
 */
#define kMPColor_3 kMPColor(245,245,245)
/**
 *   纯黑色(用于重要文字信息，如导航栏文字，内页标题文字)
 */
#define kMPColor_4 kMPColor(51,51,51)
/**
 *   主标题黑色(用于次级文字，如列表页的标签、菜单栏和导航栏文字、图标)
 */
#define kMPColor_5 kMPColor(102,102,102)
/**
 *   次级标题黑色(用于辅助文字信息，普通文字段落信息和引导词)
 */
#define kMPColor_6 kMPColor(153,153,153)
/**
 *   弱2(用于同模块不同内容的分割线，分割线默认  1px)
 */
#define kMPColor_8 kMPColor(229,229,229)
/**
 *   弱1(用于分隔模块或者背景的底色)
 */
#define kMPColor_9 kMPColor(245,245,245)
/************************Font config*********************/
#define kMPFontWithF(f) [UIFont systemFontOfSize:f]
#define kMPFont_1 kMPFontWithF(21)
#define kMPFont_2 kMPFontWithF(18)
#define kMPFont_3 kMPFontWithF(16)    //用于重要的文字  （如买手主页名称、消息页用户名称）
#define kMPFont_4 kMPFontWithF(15)    //用于大部分的文字标题  （如用户名称、切换导航）
#define kMPFont_5 kMPFontWithF(14)    //用于大部分文字  （如完善个人资料）
#define kMPFont_7 kMPFontWithF(12)
#define kMPFont_8 kMPFontWithF(11)

// 数组比较
#ifndef isArrayWithCountMoreThan0

#define isArrayWithCountMoreThan0(__array__) \
(__array__!=nil && \
[__array__ isKindOfClass:[NSArray class] ] && \
__array__.count>0)

#endif

typedef void(^PaySelectedBlock)();
@interface MPBaseView : UIView

@end
