//
//  NSObject+Extend.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2021/1/15.
//

#import "NSObject+Extend.h"

@implementation NSObject (Extend)

-(NSString *)stringToInt:(NSString *)number {
    float num = [number floatValue];
    
    if (num >= 10000) {
        
        NSString *strNum = [NSString stringWithFormat:@"%f",num/ 10000];
        
        NSRange range = [strNum rangeOfString:@"."];//匹配得到的下标
        NSString *strNum1 = [strNum substringWithRange:NSMakeRange(0, range.location + 2)];
        return [NSString stringWithFormat:@"%@w",strNum1];
            
        
    }else {
        return number;
    }
}

@end
