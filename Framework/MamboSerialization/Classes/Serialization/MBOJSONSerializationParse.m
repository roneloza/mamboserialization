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

NSErrorDomain const MBOMamboSerializationErrorDomain = @"com.mambo.MamboSerializationErrorDomain";
NSInteger const MBOMamboSerializationErrorCodeClassNoConformProtocol = 30001;
NSInteger const MBOMamboSerializationErrorCodePropertyNoSupplyJsonKey = 30002;

@interface MBOJSONSerializationParse()

@property (nonatomic, strong, readwrite) id root;

@end

@implementation MBOJSONSerializationParse

- (instancetype)initWithData:(NSData *)data; {
    
    return [self initWithData:data error:nil];
}

- (instancetype)initWithData:(NSData *)data error:(NSError *__autoreleasing *)error {
    
    if ((self = [super init])) {
        
        _root = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:error];
    }
    
    return self;
}

- (instancetype)initWithFoundation:(id)foundation {
    
    return [self initWithFoundation:foundation error:nil];
}

- (instancetype)initWithFoundation:(id)foundation error:(NSError *__autoreleasing *)error {
    
    if ((self = [super init])) {
        
        if ([NSJSONSerialization isValidJSONObject:foundation]) {
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:foundation options:NSJSONWritingPrettyPrinted error:error];
            
            _root = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:error];
        }
    }
    
    return self;
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

#pragma mark - Parser

+ (NSArray *)parseArray:(NSArray *)array toObjectClass:(Class)objectClass; {

    return [self parseArray:array toObjectClass:objectClass error:nil];
}

+ (id)parseDictionary:(NSDictionary *)dictionary toObjectClass:(Class)objectClass; {

    return [self parseDictionary:dictionary toObjectClass:objectClass error:nil];
}

- (id)parseRootObjectToObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error {
    
    id object = nil;
    
    id rootDictObject = [self getRootDictionary];
    id rootArrayObject = [self getRootArray];
    
    if (rootDictObject) {
        
        object = [[self class] parseDictionary:rootDictObject toObjectClass:objectClass error:error];
    }
    else if (rootArrayObject) {
        
        object = [[self class] parseArray:rootArrayObject toObjectClass:objectClass error:error];
    }
    
    return object;
}

- (id)parseRootObjectToObjectClass:(Class)objectClass; {
    
    return [self parseRootObjectToObjectClass:objectClass error:nil];
}

- (NSArray *)parseRootObjectToArrayObjectClass:(Class)objectClass; {
    
    return [self parseRootObjectToArrayObjectClass:objectClass error:nil];
}

- (NSArray *)parseRootObjectToArrayObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error; {
    
    id object = [self parseRootObjectToObjectClass:objectClass error:error];
    
    return [object isKindOfClass:[NSArray class]] ? object : nil;
}

- (id)parseByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass; {
    
    return [self parseByKeyPath:keyPath toObjectClass:objectClass error:nil];
}

- (NSArray *)parseToArrayByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error; {
    
    id object = [self parseByKeyPath:keyPath toObjectClass:objectClass error:error];
    
    return [object isKindOfClass:[NSArray class]] ? object : nil;
}

- (NSArray *)parseToArrayByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass; {
    
    return [self parseToArrayByKeyPath:keyPath toObjectClass:objectClass error:nil];
}

- (id)parseToObjectByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error; {
  
    id object = [self parseByKeyPath:keyPath toObjectClass:objectClass error:error];
    
    return [object isKindOfClass:objectClass] ? object : nil;
}

- (id)parseToObjectByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass; {
    
    return [self parseToObjectByKeyPath:keyPath toObjectClass:objectClass error:nil];
}

#pragma mark - Parser Handling Error

+ (NSArray *)parseArray:(NSArray *)array toObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error; {
    
    NSMutableArray *objects = nil;
    
    if (array.count > 0) {
        
        objects = [[NSMutableArray alloc] initWithCapacity:array.count];
        
        for (__weak id dictionary in array) {
            
            id object = nil;
            
            if ([dictionary isKindOfClass:[NSDictionary class]]) {
                
                MBOInspectableModel *objectModel = [self parseDictionary:dictionary toObjectClass:objectClass error:error];
                
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

+ (id)parseDictionary:(NSDictionary *)dictionary toObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error; {
 
    id object = nil;
    
    NSMutableArray *noSupplyJsonKeys = [[NSMutableArray alloc] initWithCapacity:0];
    
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
                    
                    if (propertyClass == [NSArray class] && [value isKindOfClass:[NSArray class]]) {
                        
                        value = [self parseArray:value toObjectClass:parseElementClass error:error];
                    }
                    else if ([value isKindOfClass:[NSDictionary class]]) {
                        
                        value = [self parseDictionary:value toObjectClass:propertyClass error:error];
                    }
                    
                    if (value && [value isKindOfClass:propertyClass] && ![value isKindOfClass:[NSNull class]]) {
                        
                        void (*objc_msgSendTyped)(id selfObject, SEL _cmd, id object) = (void*)objc_msgSend;
                        
                        objc_msgSendTyped(object, propertySetter, value);
                    }
                }
                else {
                    
                    [noSupplyJsonKeys addObject:[[NSString alloc] initWithFormat:@"property %@ no supply setter tied with json key.", propertyName]];
                }
            }
            
            if (error != NULL && noSupplyJsonKeys.count > 0) {
                
                // Create and return the custom domain error.
                NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey : [noSupplyJsonKeys componentsJoinedByString:@"\n"]};
                
                *error = [[NSError alloc] initWithDomain:MBOMamboSerializationErrorDomain code:MBOMamboSerializationErrorCodePropertyNoSupplyJsonKey userInfo:errorDictionary];
            }
        }
        else {
            
            if (error != NULL) {
                
                NSString *description = NSLocalizedString(@"object no conforms protocol MBOInspectableObject.", @"");
                
                // Create and return the custom domain error.
                NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey : description};
                
                *error = [[NSError alloc] initWithDomain:MBOMamboSerializationErrorDomain code:MBOMamboSerializationErrorCodeClassNoConformProtocol userInfo:errorDictionary];
            }
            
            object = dictionary;
        }
    }
    
    return object;
}

- (id)parseByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error; {
 
    id value = [self getValueForKeyPath:keyPath];
    
    id object = nil;
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        
        object = [[self class] parseDictionary:value toObjectClass:objectClass error:error];
    }
    else if ([value isKindOfClass:[NSArray class]]) {
        
        object = [[self class] parseArray:value toObjectClass:objectClass error:error];
    }
    
    return object;
}

#pragma mark - KVC

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

#pragma mark - Private

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


@end
