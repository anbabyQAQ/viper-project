//
//  TYLSwizzler.m
//  Nirvana
//
//  Created by tianyulong on 2017/12/4.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import "TYLSwizzler.h"
#import <objc/runtime.h>

@implementation TYLSwizzler

+ (void)swizzleWithClass:(Class)processedClass originalSelector:(SEL)originSelector swizzleSelector:(SEL)swizzlSelector {
    Method originMethod = class_getInstanceMethod(processedClass, originSelector);
    Method swizzleMethod = class_getInstanceMethod(processedClass, swizzlSelector);
    
    BOOL addMethod = class_addMethod(processedClass, originSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    
    if (addMethod) {
        class_replaceMethod(processedClass, swizzlSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }
    else {
        method_exchangeImplementations(originMethod, swizzleMethod);
    }
}

+ (void)swizzleWithOriginClass:(Class)originalClass originSel:(SEL)originSelector swizzleClass:(Class)swizzlClass swizzleSelector:(SEL)swizzlSelector error:(NSError**)error {
    Method originalMethod = class_getInstanceMethod(originalClass, originSelector);
    if (!originalMethod) {
        dSetNSError(error, @"original method %@ not found for class %@", NSStringFromSelector(originSelector),NSStringFromClass([self class]));
    }
    
    Method swizzleMethod = class_getInstanceMethod(swizzlClass, swizzlSelector);
    if (!swizzleMethod) {
        dSetNSError(error, @"swizzleMethod method %@ not found for class %@", NSStringFromSelector(swizzlSelector), NSStringFromClass([self class]));
    }
    
    IMP replacedMethodIMP = method_getImplementation(swizzleMethod);
    
    BOOL addMethod = class_addMethod(originalClass, swizzlSelector, replacedMethodIMP, "v@:@@");
    
//    BOOL addMethod = class_addMethod(originalClass, originSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (addMethod) {
        Method newMethod = class_getInstanceMethod(originalClass, swizzlSelector);
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

+ (void)swizzleWithClass:(Class)processedClass originalSelector:(SEL)originSelector swizzleSelector:(SEL)swizzlSelector error:(NSError**)error {
    Method originMethod = class_getInstanceMethod(processedClass, originSelector);
    if (!originMethod) {
        dSetNSError(error, @"original method %@ not found for class %@", NSStringFromSelector(originSelector),NSStringFromClass([self class]));
    }
    
    Method swizzleMethod = class_getInstanceMethod(processedClass, swizzlSelector);
    if (!swizzleMethod) {
        dSetNSError(error, @"swizzleMethod method %@ not found for class %@", NSStringFromSelector(swizzlSelector), NSStringFromClass([self class]));
    }
    
    BOOL addMethod = class_addMethod(processedClass, originSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    
    if (addMethod) {
        class_replaceMethod(processedClass, swizzlSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }
    else {
        method_exchangeImplementations(originMethod, swizzleMethod);
    }
}
@end
