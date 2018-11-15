//
//  HYBaseModel.m
//  HYlesAssistant
//
//  Created by huangyi on 17/6/26.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "HYBaseModel.h"

@implementation HYBaseModel
// 深拷贝
- (id)copyWithZone:(NSZone *)zone {
    typeof(self) copyModel = [[[self class] allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *propertes = class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {
        const char *propertyName = property_getName(propertes[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        id value = [self valueForKey:name];
        [copyModel setValue:value forKey:name];
    }
    free(propertes);
    return copyModel;
}

// 归档
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivarLists = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            const char* name = ivar_getName(ivarLists[i]);
            NSString* strName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = [aDecoder decodeObjectForKey:strName];
            [self setValue:value forKey:strName];
        }
        free(ivarLists);
    }
    return self;
}

// 解档
-(void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar *ivarLists = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char* name = ivar_getName(ivarLists[i]);
        NSString* strName = [NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:strName] forKey:strName];
    }
    free(ivarLists);
}

#pragma mark - 打印
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@,>",
            NSStringFromClass([self class]),
            self,
            [self modelDescription]];
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    [self handleModel];
}

- (void)handleModel{}

@end
