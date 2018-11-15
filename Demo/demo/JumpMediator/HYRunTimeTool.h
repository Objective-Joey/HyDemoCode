//
//  HYRunTimeTool.h
//  HYlesAssistant
//
//  Created by huangyi on 17/6/12.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYRunTimeTool : NSObject

+ (NSString *)stringWithClass:(Class)clazz;
+ (Class)classWithString:(NSString *)string;

+ (BOOL)hasPropertyName:(NSString *)name atClass:(Class)clazz;
+ (BOOL)hasInstanceMethodForClass:(Class)clazz selector:(SEL)selector;
+ (BOOL)hasClassMethodForClass:(Class)clazz selector:(SEL)selector;

+ (NSArray *)ivarListWithClass:(Class)cls;
+ (NSArray *)propertyListWithClass:(Class)cls;
+ (NSArray *)methodListWithClass:(Class)cls;
+ (void)exchangeMethodWithClass:(Class)methodClass
                   systemMethod:(SEL)systemMethod
                   customMethod:(SEL)customMethod;

@end
