//
//  PublicHelpers.h
//  Thunder
//
//  Created by 56832357 on 16/5/5.
//  Copyright © 2016年 h. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface PublicHelpers : NSObject

//判断是否为空
+ (BOOL)isBlankString:(NSString *)string;

//判断文字宽高
+ (CGSize)labelAutoCalculateRectWithText:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;

//给一段文字中的某些字设置不同颜色
+ (NSMutableAttributedString *)labelWithText:(NSString *)text arrString:(NSArray *)arrString;

//给一段文字中的某些字设置字体
+ (void)labelWithOldString:(NSMutableAttributedString *)oldString arrString:(NSString *)arrString withFontSize:(CGFloat)fontSize;

//转变颜色为Image
+ (UIImage *)createImageWithColor:(UIColor *)color;

//富文本文字，给某段文字上色
+ (NSMutableAttributedString *)ls_changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray;

/**
 *  同时更改行间距和字间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace withDirection:(NSTextAlignment)textAligment;

//字典转json
+ (NSString*)convertToJSONData:(id)infoDict;

//数组转json
+ (NSString *)arrayToJson:(NSArray *)arr;

//生成随机UUID
+ (NSString *)uuidString;

//判断文件是否存在于沙盒中
+ (BOOL)isExistInLocal:(NSString *)fileName;

//转换成时分秒
+ (NSString *)timeFormatted:(NSInteger)totalSeconds withShowHour:(BOOL)showHour;

//根据时间戳返回时间  yyyy-MM-dd
+ (NSString *)renturnTheDate:(NSDate *)convertDate;

//两个时间戳比较
+ (NSUInteger )getHour:(NSString *)takeCarTime systemTime:(NSString *)systemTime;

//转换成系统需要的时间
+ (NSString *)converToSystemTime:(NSString*)currentTime;

//计算两天时间的时间差（天数）
+ (NSInteger)dayCountBetweenDate:(NSString *)dateEnd startDate:(NSDate *)secondDate;

//根据日期获取年龄
+ (int)ageWithDateOfBirth:(NSString *)dateGet;


+ (NSArray *)retunTheDaysType:(NSInteger)type;

//设置行间距
+(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font;

//判断是否是电话号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//md5加密
+ (NSString *) md5:(NSString *) input;

+ (NSString *)sha1:(NSString *) input;

//获取当天
+ (NSString *)returnTheDateTime;

//说话
+(void)speackTheWord:(NSString *)word;

//获取当前时间的时间戳
+(NSString*)getCurrentTimestamp;

//+ (NSString *)md5:(NSString *)inPutText;

//获取前后天
+(NSString *)returnTheOtherDay:(NSInteger)otherDay;

//根据当前日期计算星期几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 */
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;


/** 根据时间戳返回更新时间 */
+ (NSString *)returnTheNearTime:(NSTimeInterval)createTime;

//判断是否纯数字
+ (BOOL) deptNumInputShouldNumber:(NSString *)str;

//纯粹显示
+ (void)showTextOnly:(NSString *)textShow;

//时间戳转换为几分钟前等
+ (NSString *) compareCurrentTime:(NSString *)str;

//返回服务器时间
+(NSString *)returnTheSeverTime:(NSString*)str;

// 获取设备IP地址
+(NSString *)getIPAddress;


//比较两个日期大小
+(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate;

//比较两个日期的时间差
+ (NSString *)returnTheMiutesTIme:(NSString *)startTime to:(NSString *)endTime;

//NSDicnory转String
+(NSString*)DataTOjsonString:(id)object;

//分割没有分隔符的字符串成数组
+ (NSArray *)subStringWithNoSpace:(NSString *)text;

//判断当前时间少了多少小时
+ (NSInteger)renturnTheMissHour:(NSString*)strTime;

//转换时间戳
+(NSString*)retunSystemTime:(NSString *)longTime;

@end
