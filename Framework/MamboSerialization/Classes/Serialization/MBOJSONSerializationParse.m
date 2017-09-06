//
//  MBOJSONSerializationParse.m
//  MamboSerialization
//
//  Created by Rone Loza on 8/16/17.
//  Copyright © 2017 Mambo. All rights reserved.
//

#import "MBOJSONSerializationParse.h"
#import "MBOInspectableModel.h"
#import <objc/message.h>

@interface MBOJSONSerializationParse()

@property (nonatomic, strong, readwrite) id root;

@end

@implementation MBOJSONSerializationParse

- (instancetype)initWithData:(NSData *)data; {
    
    if ((self = [super init])) {
        
        
        NSError *error = nil;
        
        _root = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:&error];
    }
    
    return self;
}

- (instancetype)initWithFoundation:(id)foundation {
    
    if ((self = [super init])) {
        
        if ([NSJSONSerialization isValidJSONObject:foundation]) {
            
            NSError *error = nil;
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:foundation
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
            [self setData:data];
        }
    }
    
    return self;
}

- (void)setData:(NSData *)data {
    
    NSError *error = nil;
    
    self.root = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:&error];
}

- (NSDictionary *)getRootDictionary; {
    
    return ([self.root isKindOfClass:[NSDictionary class]] ? self.root : nil);
}

- (NSArray *)getRootArray; {
    
    return ([self.root isKindOfClass:[NSArray class]] ? self.root : nil);
}

- (id)getValueForKeyPath:(NSString *)key; {
    
    id value = nil;
    
    value = [self.root valueForKeyPath:key];
    
    return value;
}

- (NSDictionary *)getDictForKeyPath:(NSString *)key; {
    
    NSDictionary *value = nil;
    
    if ([self.root isKindOfClass:[NSDictionary class]]) {
        
        value = [self.root valueForKeyPath:key];
    }
    
    return ([value isKindOfClass:[NSDictionary class]] ? value : nil);
}

- (NSArray *)getArrayForKeyPath:(NSString *)key; {
    
    NSArray * value = nil;
    
    if ([self.root isKindOfClass:[NSDictionary class]]) {
        
        value = [self.root valueForKeyPath:key];
    }
    
    return ([value isKindOfClass:[NSArray class]] ? value : nil);
}

- (id)getValueForKeyPath:(NSString *)key atIndex:(NSInteger)index; {
    
    id value = nil;
    
    NSArray *array = [self getArrayForKeyPath:key];
    
    if (array.count > 0 && index < array.count) {
        
        value = [array objectAtIndex:index];
    }
    
    return value;
}

- (NSDictionary *)getDictForKeyPath:(NSString *)key atIndex:(NSInteger)index; {
    
    id value = [self getValueForKeyPath:key atIndex:index];
    
    return ([value isKindOfClass:[NSDictionary class]] ? (NSDictionary *)value : nil);
}

- (NSArray *)getArrayForKeyPath:(NSString *)key atIndex:(NSInteger)index; {
    
    id value = [self getValueForKeyPath:key atIndex:index];
    
    return ([value isKindOfClass:[NSArray class]] ? (NSArray *)value : nil);
}

+ (NSArray *)parseArray:(NSArray *)array toObjectClass:(Class)objectClass; {
    
    NSMutableArray *objects = nil;
    
    if (array.count > 0) {
        
        objects = [[NSMutableArray alloc] initWithCapacity:array.count];
        
        for (__weak id dictionary in array) {
            
            id object = nil;
            
            if ([dictionary isKindOfClass:[NSDictionary class]]) {
                
                MBOInspectableModel *objectModel = [self parseDictionary:dictionary toObjectClass:objectClass];
                
                object = objectModel;
            }
            else {
                
                object = dictionary;
            }
            
            if (object) [objects addObject:object];
        }
    }
    
    return [objects copy];
}

+ (id)parseDictionary:(NSDictionary *)dictionary toObjectClass:(Class)objectClass; {
    
    id object = nil;
    
    if (dictionary) {
        
        object = [[objectClass alloc] init];
        
        if ([object conformsToProtocol:@protocol(MBOInspectableObject)]) {
            
            for (__weak NSString *propertyName in [object propertyNames]) {
                
                SEL propertySetter = [object getPropertySetter:propertyName];
                
                if (class_respondsToSelector([object class], propertySetter)) {
                    
                    Class propertyClass = [object getPropertyClassWrapClass:propertyName];
                    Class parseElementClass = [object getPropertyClassElementToParse:propertyName];
                    
                    NSString *key = [NSStringFromSelector(propertySetter) stringByReplacingOccurrencesOfString:@":" withString:@""];
                    
                    id value = [dictionary valueForKey:key];
                    
                    if ((propertyClass == [NSArray class])&&
                        [value isKindOfClass:[NSArray class]]) {
                        
                        value = [self parseArray:value toObjectClass:parseElementClass];
                    }
                    else if ([value isKindOfClass:[NSDictionary class]]) {
                        
                        value = [self parseDictionary:value toObjectClass:propertyClass];
                    }
                    
                    if (value &&
                        [value isKindOfClass:propertyClass] &&
                        ![value isKindOfClass:[NSNull class]]) {
                        
                        void (*objc_msgSendTyped)(id selfObject, SEL _cmd, id object) = (void*)objc_msgSend;
                        
                        objc_msgSendTyped(object, propertySetter, value);
                    }
                }
            }
        }
        else {
            
            object = dictionary;
        }
    }
    
    return object;
}

- (id)parseRootObjectToObjectClass:(Class)objectClass; {
    
    id object = nil;
    
    id rootDictObject = [self getRootDictionary];
    id rootArrayObject = [self getRootArray];
    
    if (rootDictObject) {
        
        object = [[self class] parseDictionary:rootDictObject toObjectClass:objectClass];
    }
    else if (rootArrayObject) {
        
        object = [[self class] parseArray:rootArrayObject toObjectClass:objectClass];
    }
    
    return object;
}

- (NSArray *)parseRootObjectToArrayObjectClass:(Class)objectClass; {
    
    id object = [self parseRootObjectToObjectClass:objectClass];
    
    return [object isKindOfClass:[NSArray class]] ? object : nil;
}

- (id)parseByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass; {
    
    id value = [self getValueForKeyPath:keyPath];
    
    id object = nil;
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        
        object = [[self class] parseDictionary:value toObjectClass:objectClass];
    }
    else if ([value isKindOfClass:[NSArray class]]) {
        
        object = [[self class] parseArray:value toObjectClass:objectClass];
    }
    
    return object;
}

- (NSArray *)parseToArrayByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass; {
    
    id object = [self parseByKeyPath:keyPath toObjectClass:objectClass];
    
    return [object isKindOfClass:[NSArray class]] ? object : nil;
}

- (id)parseToObjectByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass; {
    
    id object = [self parseByKeyPath:keyPath toObjectClass:objectClass];
    
    return [object isKindOfClass:objectClass] ? object : nil;
}


- (NSString *)jsonStringWithPrettyPrint:(BOOL)prettyPrint {
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.root options:(NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0) error:&error];
    
    if (!jsonData) {
        
        return @"{}";
    }
    else {
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}


+ (NSArray *)getAllUniqueKeysToSerializeObject:(id)serializeObject; {
    
    __block NSArray *allUniqueKeys = [[NSArray alloc] init];
    
    //    void (^allDictKeys)(NSDictionary *dict) = ^(NSDictionary *dict){
    //
    //        [allUniqueKeys addObjectsFromArray:[dict allKeys]];
    //    };
    
    //    void (^allArrayNestedDictKeys)(NSArray *array) = ^(NSArray *array){
    //
    //        [allUniqueKeys addObjectsFromArray:[array valueForKeyPath:@"@distinctUnionOfArrays.@allKeys"]];
    //    };
    
    if (serializeObject &&
        [serializeObject isKindOfClass:[NSDictionary class]] &&
        [serializeObject count] > 0) {
        
        // Add all keys
        allUniqueKeys = [allUniqueKeys arrayByAddingObjectsFromArray:[serializeObject allKeys]];
        
        NSArray *allValues = [serializeObject allValues];
        
        // All Nested keys into first object NSArray
        NSPredicate *predicateContainsArrays = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [NSArray class]];
        
        NSArray *allArrays = [allValues filteredArrayUsingPredicate:predicateContainsArrays];
        
        if (allArrays && allArrays.count > 0) {
            
            for (__weak id item in allArrays) {
                
                allUniqueKeys = [allUniqueKeys arrayByAddingObjectsFromArray:[[self class] getAllUniqueKeysToSerializeObject:item]];
            }
        }
        
        // All Nested keys into NSDictionary
        NSPredicate *predicateContainsDictionary = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [NSDictionary class]];
        
        NSArray *allDictionaries = [allValues filteredArrayUsingPredicate:predicateContainsDictionary];
        
        if (allDictionaries && allDictionaries.count > 0) {
            
            for (__weak id item in allDictionaries) {
                
                allUniqueKeys = [allUniqueKeys arrayByAddingObjectsFromArray:[[self class] getAllUniqueKeysToSerializeObject:item]];
            }
        }
    }
    else if (serializeObject &&
             [serializeObject isKindOfClass:[NSArray class]] &&
             [serializeObject count] > 0) {
        
        
        NSArray *allKeys = [(NSArray *)serializeObject valueForKeyPath:@"@distinctUnionOfArrays.@allKeys"];
        
        //        NSDictionary *dict =[(NSArray *)objectDeserialize dictionaryWithValuesForKeys:allKeys];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:allKeys.count];
        
        for (__weak id item in serializeObject) {
            
            for (__weak NSString *key in [item allKeys]) {
                
                if (![dict.allKeys containsObject:key]) {
                    
                    [dict setValue:[item valueForKey:key] forKey:key];
                }
            }
        }
        
        allUniqueKeys = [allUniqueKeys arrayByAddingObjectsFromArray:[[self class] getAllUniqueKeysToSerializeObject:dict]];
    }
    
    return allUniqueKeys;
}

@end
