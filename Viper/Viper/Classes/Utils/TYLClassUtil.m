//
//  TYLClassUtil.m
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLClassUtil.h"
#import <objc/runtime.h>

@implementation TYLClassUtil
/**
 批量赋值(类型自解析)
 
 @param obj 要赋值的对象
 @param paramDict 赋值字典
 */
+ (void)batchAssign:(id)obj params:(NSDictionary *)paramDict {
    // 属性赋值
    Class baseClass = [obj class];
    Class superClass = baseClass;
    do {
        baseClass = superClass;
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(baseClass, &propertyCount);
        for (int i = 0; i < propertyCount; i++) {
            objc_property_t property = properties[i];
            
            // 取属性名称
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
            if (![paramDict.allKeys containsObject:propertyName]) {
                continue;
            }
            id value = paramDict[propertyName];
            
            NSString *attributeString = [NSString stringWithUTF8String:property_getAttributes(property)];
            /*
             propertyName:    num
             attributeString: Ti,N,V_num
                                T: 在大写 T 后面是放的是该属性的数据类型
                                V: 在大写 V 后面放的是该属性的变量名称
                                N: N代表的是属性的非原子属性 nonatomic 的标识
             */
            NSString *typeString = [[attributeString componentsSeparatedByString:@","] firstObject];
            
            // 类名, 非基础类型
            NSString *classNameString = [[self class] getClassNameFromAttributeString:typeString];
            
            // 基础类型
            if ([value isKindOfClass:[NSNumber class]]) {
                // 当对应的属性为基础类型或者 NSNumber 时才处理
                if ([typeString isEqualToString:@"Td"] || [typeString isEqualToString:@"Ti"] || [typeString isEqualToString:@"Tf"] || [typeString isEqualToString:@"Tl"] || [typeString isEqualToString:@"Tc"] || [typeString isEqualToString:@"Ts"] || [typeString isEqualToString:@"TI"]|| [typeString isEqualToString:@"Tq"] || [typeString isEqualToString:@"TQ"] || [typeString isEqualToString:@"TB"] ||[classNameString isEqualToString:@"NSNumber"]) {
                    [[self class] assign:obj param:propertyName value:value type:typeString];
                }
                else {
                    if ([classNameString isEqualToString:@"NSString"]) {
                        [[self class] assign:obj param:propertyName value:[(NSNumber *)value stringValue] type:typeString];
                    }
                    else if ([classNameString isEqualToString:@"NSArray"]) {
                        [[self class] assign:obj param:propertyName value:@[value] type:typeString];
                    }
                    else{
                        NSLog(@"type error -- name:%@ attribute:%@ ", propertyName, typeString);
                    }
                }
            }
            //字符串
            else if ([value isKindOfClass:[NSString class]]) {
                if ([classNameString isEqualToString:@"NSString"]) {
                    [[self class] assign:obj param:propertyName value:value type:typeString];
                }
                else if ([classNameString isEqualToString:@"NSMutableString"]) {
                    [[self class] assign:obj param:propertyName value:[NSMutableString stringWithString:value] type:typeString];
                }
                //对应的属性为基础类型时，先转成 NSNumber
                else if ([typeString isEqualToString:@"Td"] || [typeString isEqualToString:@"Ti"] || [typeString isEqualToString:@"Tf"] || [typeString isEqualToString:@"Tl"] || [typeString isEqualToString:@"Tc"] || [typeString isEqualToString:@"Ts"] || [typeString isEqualToString:@"TI"]|| [typeString isEqualToString:@"Tq"] || [typeString isEqualToString:@"TQ"] || [typeString isEqualToString:@"TB"]) {
                    
                    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
                    NSNumber *number = [formater numberFromString:value];
                    if (number) {
                        [[self class] assign:obj param:propertyName value:number type:typeString];
                    }
                }
                else if ([classNameString isEqualToString:@"NSArray"]) {
                    [[self class] assign:obj param:propertyName value:@[value] type:typeString];
                }
                else{
                    NSLog(@"type error -- name:%@ attribute:%@ ", propertyName, typeString);
                }
            }
            //字典
            else if ([value isKindOfClass:[NSDictionary class]]) {
                [[self class] assign:obj param:propertyName value:value type:typeString];
            }
            //数组
            else if ([value isKindOfClass:[NSArray class]]) {
                [[self class] assign:obj param:propertyName value:value type:typeString];
            }
            //自定义对象
            else if ([value isKindOfClass:[NSObject class]]) {
                [[self class] assign:obj param:propertyName value:value type:typeString];
            }
            // 空
            else if ([value isKindOfClass:[NSNull class]]) {
                continue;
            }
            // 其它(Block等)
            else {
                [[self class] assign:obj param:propertyName value:value type:typeString];
                continue;
            }
            
        }
        
        free(properties);
        superClass = class_getSuperclass(baseClass);
    } while (superClass != baseClass && superClass != [NSObject class]);
}

+ (NSString *)getClassNameFromAttributeString:(NSString *)attributeString {
    NSString *className = nil;
    NSScanner *scanner = [NSScanner scannerWithString: attributeString];
    [scanner scanUpToString:@"T" intoString: nil];
    [scanner scanString:@"T" intoString:nil];
    if ([scanner scanString:@"@\"" intoString: &className]) {
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                intoString:&className];
    }
    return className;
}

+ (void)assign:(id)obj param:(NSString *)name value:(id)v type:(NSString *)type{
    if (!name || name.length == 0) {
        return;
    }
    NSString *selName = [NSString stringWithFormat:@"set%@%@:", [[name substringToIndex:1] uppercaseString], [name substringFromIndex:1]];
    SEL sel = NSSelectorFromString(selName);
    if ([obj respondsToSelector:sel]) {
        IMP imp = [obj methodForSelector:sel];
        if ([type isEqualToString:@"Td"]) {
            void (*func)(id, SEL, double) = (void *)imp;
            func(obj, sel, [v doubleValue]);
        } else if ([type isEqualToString:@"Ti"]) {
            void (*func)(id, SEL, int) = (void *)imp;
            func(obj, sel, [v intValue]);
        } else if ([type isEqualToString:@"Tf"]) {
            void (*func)(id, SEL, float) = (void *)imp;
            func(obj, sel, [v floatValue]);
        } else if ([type isEqualToString:@"Tl"]) {
            void (*func)(id, SEL, long) = (void *)imp;
            func(obj, sel, [v longValue]);
        } else if ([type isEqualToString:@"Tc"]) {
            void (*func)(id, SEL, char) = (void *)imp;
            func(obj, sel, [v charValue]);
        } else if ([type isEqualToString:@"Ts"]) {
            void (*func)(id, SEL, short) = (void *)imp;
            func(obj, sel, [v shortValue]);
        } else if ([type isEqualToString:@"TI"]) {
            void (*func)(id, SEL, unsigned int) = (void *)imp;
            func(obj, sel, [v unsignedIntValue]);
        } else if ([type isEqualToString:@"Tq"]) {
            void (*func)(id, SEL, long long) = (void *)imp;
            func(obj, sel, [v longLongValue]);
        } else if ([type isEqualToString:@"TQ"]) {
            void (*func)(id, SEL, unsigned long long) = (void *)imp;
            func(obj, sel, [v unsignedLongLongValue]);
        } else if ([type isEqualToString:@"TB"]) {
            void (*func)(id, SEL, BOOL) = (void *)imp;
            func(obj, sel, [v boolValue]);
        } else {
            void (*func)(id, SEL, id) = (void *)imp;
            func(obj, sel, v);
        }
    }
}

@end
