//
//  PublicHelpers.m
//  Thunder
//
//  Created by 56832357 on 16/5/5.
//  Copyright © 2016年 h. All rights reserved.
//

#import "PublicHelpers.h"
#import<CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
@implementation PublicHelpers
//判断是否为空
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if ([string isEqualToString:@" "]) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (NSMutableAttributedString *)labelWithText:(NSString *)text arrString:(NSArray *)arrString{
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:text];
    
    for (NSDictionary * dic in arrString) {
        NSRange range = NSMakeRange([[str string] rangeOfString:dic[@"text"]].location,[[str string] rangeOfString:dic[@"text"]].length);
        
        //设置字号
        [str addAttribute:NSFontAttributeName value:dic[@"font"] range:range];
        
        //设置文字颜色
        [str addAttribute:NSForegroundColorAttributeName value:dic[@"color"] range:range];
    }
    
    return str;
}

+ (CGSize)labelAutoCalculateRectWithText:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return labelSize;
}

+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (NSMutableAttributedString *)ls_changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    for (NSString *rangeStr in subArray) {
        NSRange range = [totalStr rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedStr length])];
        
    }
    return attributedStr;
}

//给一段文字中的某些字设置字体
+ (void)labelWithOldString:(NSMutableAttributedString *)oldString arrString:(NSString *)arrString withFontSize:(CGFloat)fontSize{
    NSRange range = [oldString.string rangeOfString:arrString options:NSBackwardsSearch];
    [oldString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [oldString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [oldString length])];
}

/**
 *  同时更改行间距和字间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace withDirection:(NSTextAlignment)textAligment{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [paragraphStyle setAlignment:textAligment];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&textSpace);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    return attributedStr;
}

//字典转json
+ (NSString*)convertToJSONData:(id)infoDict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

//数组转json
+ (NSString *)arrayToJson:(NSArray *)arr{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


//生成随机UUID
+ (NSString *)uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

+ (BOOL)isExistInLocal:(NSString *)fileName{
    // 取得沙盒目录
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 要检查的文件目录
    NSString *filePath = [localPath  stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    else {
        return NO;
    }
}

//转换成时分秒
+ (NSString *)timeFormatted:(NSInteger)totalSeconds withShowHour:(BOOL)showHour{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = (int)totalSeconds / 3600;
    return  showHour?[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds]:[NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

 

//根据时间戳返回时间  yyyy-MM-dd
+ (NSString *)renturnTheDate:(NSDate *)convertDate{
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:convertDate];
    return strDate;
}

//计算两天时间的时间差（天数）
+ (NSInteger)dayCountBetweenDate:(NSString *)dateEnd startDate:(NSDate *)secondDate{
    if ([self isBlankString:dateEnd]) {
        return 0;
    }
    
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate  *date = [dateFormatter dateFromString:dateEnd];
    
    NSString * timeStamp = [PublicHelpers getZeroTimeStampWithDate:date];
    date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    
    timeStamp = [PublicHelpers getZeroTimeStampWithDate:secondDate];
    secondDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    
    NSInteger dayCount = [date timeIntervalSinceDate:secondDate];
    
    dayCount = dayCount/3600/24;
    
    return dayCount;
}

//两个时间戳比较
+ (NSUInteger)getHour:(NSString *)takeCarTime systemTime:(NSString *)systemTime{
    //  时区相差8个小时 加上这个时区即是北京时间
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger delta = [timeZone secondsFromGMT];
    // 两个时间戳转换日期类
    // [takeCarTime doubleValue]/1000 这里除以1000 我们后台传来的时间戳有问题
    NSDate *DRstartDate = [[NSDate alloc] initWithTimeIntervalSince1970:[takeCarTime doubleValue] + delta];
    NSDate *DRendDate = [[NSDate alloc] initWithTimeIntervalSince1970:[systemTime doubleValue] + delta];
    // 日历对象 （方便比较两个日期之间的差距）
    NSComparisonResult result = [DRstartDate compare:DRendDate];
    NSInteger isNotReflush = 0;
    if (result == NSOrderedSame){
        // 相等  aa=0
        isNotReflush = 0;
    }else if (result == NSOrderedAscending){
        //系统时间比过期时间大
        isNotReflush = 1;
    }else if (result == NSOrderedDescending){
        //系统时间比过期时间小
        isNotReflush = 2;
    }
    return isNotReflush;
}



+ (NSString *)getZeroTimeStampWithDate:(NSDate *)date{
    
    NSString *timesp = nil;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    if(!date)
    {
        date = [NSDate date];
    }
    
    NSString * dateStr = [dateFormatter stringFromDate:date];
    date = [dateFormatter dateFromString:dateStr];
    
    NSTimeInterval dis =[date timeIntervalSince1970];
    timesp =[NSString stringWithFormat:@"%d",(int)dis];
    
    return timesp;
}

//根据日期获取年龄
+ (int)ageWithDateOfBirth:(NSString *)dateGet{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateGet];
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    int iAge = (int)(currentDateYear - brithDateYear - 1);
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    return iAge;
}


+ (NSString *)returnTheDateTime{
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}

+ (NSArray *)retunTheDaysType:(NSInteger)type{
     if (type == 0){
        //一周
    }else if (type == 1){
        //本月
        NSDate *today = [NSDate date]; //Get a date object for today's date
        NSCalendar *c = [NSCalendar currentCalendar];
        NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                               inUnit:NSCalendarUnitMonth
                              forDate:today];
        
        if (days.length == 31) {
            return  @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
        }else if (days.length == 30){
            return @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30"];
        }else if (days.length == 28){
            return @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28"];
        }else if (days.length == 29){
            return @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29"];
        }
    }else if (type == 2){
        
    }
    return nil;
}


+(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 2; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}

//判断是否是电话号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString *)sha1:(NSString *) input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

//说话
+(void)speackTheWord:(NSString *)word{
    AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:word];
    [av speakUtterance:utterance];
}

//获取当前时间的时间戳
+(NSString*)getCurrentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a=[dat timeIntervalSince1970];
//    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    NSString *timeSp = [NSString stringWithFormat:@"%ld000000000000", (long)[dat timeIntervalSince1970]];
    timeSp = [timeSp substringToIndex:10];
    return timeSp;
}

//转换成系统需要的时间
+ (NSString *)converToSystemTime:(NSString*)currentTime{
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* dat = [dateFormatter dateFromString:currentTime];
    NSString *timeSp = [NSString stringWithFormat:@"%ld000000000000", (long)[dat timeIntervalSince1970]];
    timeSp = [timeSp substringToIndex:10];
    return timeSp;
}

//获取前后天
+(NSString *)returnTheOtherDay:(NSInteger)otherDay{
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateGet = [NSDate dateWithTimeIntervalSinceNow:otherDay*24*60*60];
//    NSString *strDate = [self weekdayStringFromDate:dateGet];
    NSString *strDate = [dateFormatter stringFromDate:dateGet];
    return strDate;
}

//根据当前日期计算星期几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:inputDate];
    NSString *strWeekDay = [weekdays objectAtIndex:comps.weekday];
    
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:inputDate];
    
    return [NSString stringWithFormat:@"%@ %@",strDate,strWeekDay];
}


/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 */
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

/** 根据时间戳返回更新时间 */
+ (NSString *)returnTheNearTime:(NSTimeInterval)createTime {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    [stampFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:createTime];
    return [stampFormatter stringFromDate:stampDate2];
    
//    //秒转天数
//    NSInteger days = time/3600/24;
//    if (days < 30) {
//        return [NSString stringWithFormat:@"%ld天前",days];
//    }
//    //秒转月
//    NSInteger months = time/3600/24/30;
//    if (months < 12) {
//        return [NSString stringWithFormat:@"%ld月前",months];
//    }
//    //秒转年
//    NSInteger years = time/3600/24/30/12;
//    return [NSString stringWithFormat:@"%ld年前",years];
}

//判断是否纯数字
+ (BOOL) deptNumInputShouldNumber:(NSString *)str{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

 

 //时间戳转换为几分钟前等
+ (NSString *) compareCurrentTime:(NSString *)str{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = [str longLongValue];
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    NSInteger sec = time/60;
    if (sec<60) {
        return [NSString stringWithFormat:@"%d分钟前",(int)sec];
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%d小时前",(int)hours];
    }
    

//    return [dateFormatter stringFromDate:timeDate];
  
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%d天前",(int)days];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [objDateformat stringFromDate:date];
    
//    //秒转月
//    NSInteger months = time/3600/24/30;
//    if (months < 12) {
//        return [NSString stringWithFormat:@"%ld月前",months];
//    }
//    //秒转年
//    NSInteger years = time/3600/24/30/12;
//    return [NSString stringWithFormat:@"%ld年前",years];
}

//返回服务器时间
+(NSString *)returnTheSeverTime:(NSString*)str{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [objDateformat stringFromDate:date];
}

// 获取设备IP地址
+(NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // 检索当前接口,在成功时,返回0
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // 循环链表的接口
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // 检查接口是否en0 wifi连接在iPhone上
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // 得到NSString从C字符串
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // 释放内存
    freeifaddrs(interfaces);
    return address;
}


 

//比较两个日期大小
+(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate{
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    switch (result){
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
}

//比较两个日期的时间差
+ (NSString *)returnTheMiutesTIme:(NSString *)startTime to:(NSString *)endTime{
    // 当前日历
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    // 需要对比的时间数据
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
//    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute ;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startTime];
    date2 = [formatter dateFromString:endTime];
    
    // 对比时间差
//    NSDateComponents *dateCom = [calendar components:unit fromDate:date1 toDate:date2 options:0];
//    NSString *time = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld",dateCom.year,dateCom.month,dateCom.day,dateCom.hour,dateCom.minute,dateCom.second];
//    NSLog(@"time is %f",[time floatValue]);
//    NSString *strFinal;
//    if (dateCom.month != 0) {
//        strFinal =  [NSString stringWithFormat:@"共%ld月%ld天%ld时%ld分钟",(long)dateCom.month,(long)dateCom.day,(long)dateCom.hour,(long)dateCom.minute];
//    }else{
//        strFinal = [NSString stringWithFormat:@"共%ld天%ld小时%ld钟",(long)dateCom.day,(long)dateCom.hour,(long)dateCom.minute];
//    }
    
    NSString *strFinal;
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
    //计算天数、时、分、秒
    float days = ((int)time)/(3600*24);
    float hours = ((int)time)%(3600*24)/3600;
    float minutes = ((int)time)%(3600*24)%3600/60;
    strFinal = [NSString stringWithFormat:@"%.1f",days*24+hours+minutes/10];
    return strFinal;
}

//NSDicnory转String
+(NSString*)DataTOjsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}
 
//分割没有分隔符的字符串成数组
+ (NSArray *)subStringWithNoSpace:(NSString *)text{
    NSMutableArray *textArray = @[].mutableCopy;
    for (NSInteger i = 0; i < text.length; i++) {
        NSString *str = [text substringToIndex:1];
        text = [text substringFromIndex:1];
        i = 0;
        [textArray addObject:str];
        if (text.length == 1) {
            [textArray addObject:text];
        }
    }
    return textArray;
}

//判断当前时间少了多少小时
+ (NSInteger)renturnTheMissHour:(NSString*)strTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [NSDate date];
    NSDate *date2 = [[NSDate alloc] init];
    date2 = [formatter dateFromString:strTime];
    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
    double secondsInAnHour =3600;// 除以3600是把秒化成小时，除以60得到结果为相差的分钟数
    NSInteger hoursBetweenDates = distanceBetweenDates/secondsInAnHour;
    return hoursBetweenDates;
}

//转换时间戳
+(NSString*)retunSystemTime:(NSString*)longTime{
    NSTimeInterval interval    =[longTime doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    return  dateString;
}

@end
