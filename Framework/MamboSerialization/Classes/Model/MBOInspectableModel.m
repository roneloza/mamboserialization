//
//  MBOInspectableModel.m
//  MamboSerialization
//
//  Created by Rone Loza on 8/16/17.
//  Copyright © 2017 Mambo. All rights reserved.
//

#import "MBOInspectableModel.h"
#import "MBOJSONSerializationParse.h"
#import <objC/message.h>

@implementation MBOInspectableModel

@synthesize propertyNames = _propertyNames;

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (instancetype)initWithArchivedVersion:(NSData *)archivedVersion {
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:archivedVersion];
}

- (NSData *)getArchivedVersion {
    
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (instancetype)newWithData:(NSDictionary *)data; {
    
    return [self newWithData:data error:nil];
}

+ (instancetype)newWithData:(NSDictionary *)data error:(NSError **)error; {
    
    id model = [MBOJSONSerializationParse parseDictionary:data toObjectClass:[self class] error:error];
    
//    id model = [[[MBOJSONSerializationParse alloc] initWithFoundation:data error:error] parseRootObjectToObjectClass:[self class] error:error];
    
    return model;
}

+ (NSString *)classNameString {
    
    return NSStringFromClass([self class]);
}

#pragma mark - NSSecureCoding

- (id)copyWithZone:(NSZone *)zone {
    
    id copy = [[[self class] allocWithZone:zone] init];
    
    if ([copy conformsToProtocol:@protocol(MBOInspectableObject)]) {
        
        for (__weak NSString *propertyName in [copy propertyNames]) {
            
            SEL propertySetter = [copy getPropertySetter:propertyName];
            SEL propertyGetter = [copy getPropertyGetter:propertyName];
            
            if (class_respondsToSelector([copy class], propertySetter)) {
                
                id (*objc_msgSendTypedGetter)(id _self, SEL _cmd) = (void*)objc_msgSend;
                
                void (*objc_msgSendTypedSetter)(id _self, SEL _cmd, id object) = (void*)objc_msgSend;
                
                id value = objc_msgSendTypedGetter(self, propertyGetter);
                
                if (![value isKindOfClass:[NSNull class]]) {
                    
                    objc_msgSendTypedSetter(copy, propertySetter, value);
                }
            }
        }
    }
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    if ([self conformsToProtocol:@protocol(MBOInspectableObject)]) {
        
        for (__weak NSString *propertyName in [self propertyNames]){
            
            SEL propertyGetter = [self getPropertyGetter:propertyName];
            
            if (class_respondsToSelector([self class], propertyGetter)) {
                
                id (*objc_msgSendTypedGetter)(id _self, SEL _cmd) = (void*)objc_msgSend;
                
                id value = objc_msgSendTypedGetter(self, propertyGetter);
                
                if (![value isKindOfClass:[NSNull class]]) {
                    
                    [encoder encodeObject:value forKey:propertyName];
                }
            }
        }
        
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if ([self conformsToProtocol:@protocol(MBOInspectableObject)]) {
        
        for (__weak NSString *propertyName in [self propertyNames]) {
            
            SEL propertySetter = [self getPropertySetter:propertyName];
            
            if (class_respondsToSelector([self class], propertySetter)) {
                
                void (*objc_msgSendTypedSetter)(id _self, SEL _cmd, id object) = (void*)objc_msgSend;
                
                Class propertyClass =  [self getPropertyClassWrapClass:propertyName];
                
                id value = [decoder decodeObjectOfClass:propertyClass forKey:propertyName];
                
//                id value = [decoder decodeObjectOfClass:[self class] forKey:propertyName];
//                id value = [decoder decodeObjectForKey:propertyName];
                
                if (![value isKindOfClass:[NSNull class]]) {
                    
                    objc_msgSendTypedSetter(self, propertySetter, value);
                }
            }
        }
    }
    return self;
}

- (NSSet *)propertyForClass:(Class)class {
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    NSMutableSet *propertiesArray = [[NSMutableSet alloc] initWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        if (propertyName) [propertiesArray addObject:propertyName];
    }
    
    free(properties);
    
    return [propertiesArray copy];
}

- (NSSet *)propertyNames; {
    
    if (!_propertyNames) {
        
        NSMutableSet* result = [NSMutableSet new];
        Class observed = [self class];
        
        while ([observed isSubclassOfClass:[MBOInspectableModel class]] && observed != [MBOInspectableModel class]) {
            
            [result unionSet:[self propertyForClass:observed]];
            observed = [observed superclass];
        }
        
        _propertyNames = [result copy];;
    }
    
    return _propertyNames;
}

- (NSSet *)settersPropertyNames; {
    
    NSMutableArray *setters = [[NSMutableArray alloc] init];
    
    for (__weak NSString *propertyName in [self propertyNames]) {
        
        SEL propertySetter = [self getPropertySetter:propertyName];
        
        NSString *key = [NSStringFromSelector(propertySetter) stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        [setters addObject:key];
    }
    
    return [setters copy];
}

- (NSString *)getPropertyAttributes:(NSString *)propertyName; {
    
    Class objectClass = object_getClass(self);
    
    objc_property_t property = class_getProperty(objectClass, [propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
    
    NSString *attributeString  = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    
    return attributeString;
}

- (SEL)getPropertySetter:(NSString *)propertyName; {
    
    Class objectsClass = object_getClass(self);
    
    objc_property_t property = class_getProperty(objectsClass, [propertyName cStringUsingEncoding:NSUTF8StringEncoding] );
    
    SEL setter = NULL;
    
    const char* setterName = property_copyAttributeValue(property, "S");
    
    if (setterName == NULL) {
        
        NSString *setterSelectorName = [NSString stringWithFormat:@"set%@%@:",
                                [[propertyName substringToIndex:1] uppercaseString],[propertyName substringFromIndex:1]];
        
        setter = NSSelectorFromString(setterSelectorName);
    }
    else {
        
        setter = sel_getUid(setterName);
    }
    
    return setter;
}

- (SEL)getPropertyGetter:(NSString *)propertyName; {
    
    Class objectsClass = object_getClass(self);
    
    objc_property_t property = class_getProperty(objectsClass, [propertyName cStringUsingEncoding:NSUTF8StringEncoding] );
    
    SEL getter = NULL;
    
    const char* getterName = property_copyAttributeValue(property, "G");
    
    if (getterName == NULL) {
        
        getter = NSSelectorFromString(propertyName);
    }
    else {
        
        getter = sel_getUid(getterName );
    }
    
    return getter;
}

//- (NSString *)getPropertyAttribute:(NSString *)attribute propertyName:(NSString *)propertyName {
//
//    Class objectsClass = object_getClass(self);
//
//    objc_property_t property = class_getProperty(objectsClass, [propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
//
//    NSString *attributeString  = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
//
//    return attributeString;
//}

- (Class)getPropertyAttributeClass:(NSString *)propertyName; {
    
    Class propertyClass = NULL;
    
    Class objectClass = object_getClass(self);
    
    objc_property_t property = class_getProperty(objectClass, [propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
    
    if (property != NULL) {
        
        const char* attributes = property_getAttributes(property);
        
        if (attributes[1] == '@') {
            
            NSMutableString* className = [NSMutableString new];
            
            for (int j=3; attributes[j] && attributes[j]!='"'; j++)
                [className appendFormat:@"%c", attributes[j]];
            
            propertyClass = objc_getClass([className UTF8String]);
        }
    }
    
    return propertyClass;
}

- (Class)getPropertyClassElementToParse:(NSString *)propertyName; {
    
    NSString *getStringPropertyClass = [self getStringPropertyClass:propertyName];
    
    getStringPropertyClass = [[getStringPropertyClass componentsSeparatedByCharactersInSet:
                               [NSCharacterSet characterSetWithCharactersInString:@"@\""]]
                              componentsJoinedByString:@""];
    
    Class elementToParseClass = NULL;
    
    NSRange range1 = [getStringPropertyClass rangeOfString:@"<"];
    NSRange range2 = [getStringPropertyClass rangeOfString:@">"];
    NSRange range = NSMakeRange(range1.location + 1, (range2.location - range1.location) - 1);
    
    if (range1.location != NSNotFound &&
        range2.location != NSNotFound) {
        
        NSString *stringProtocol = [getStringPropertyClass substringWithRange:range];
        
        //        Class class = objc_allocateClassPair([NSObject class], [stringProtocol UTF8String], 0);
        //        elementToParseClass = NSClassFromString(stringProtocol);
        elementToParseClass = objc_getClass([stringProtocol UTF8String]);
    }
    
    return elementToParseClass;
}

- (Class)getPropertyClassWrapClass:(NSString *)propertyName; {
    
    NSString *getStringPropertyClass = [self getStringPropertyClass:propertyName];
    
    getStringPropertyClass = [[getStringPropertyClass componentsSeparatedByCharactersInSet:
                               [NSCharacterSet characterSetWithCharactersInString:@"@\""]]
                              componentsJoinedByString:@""];
    
    Class propertyClass = NULL;
    
    NSRange range1 = [getStringPropertyClass rangeOfString:@"<"];
    NSRange range2 = [getStringPropertyClass rangeOfString:@">"];
    NSRange range = NSMakeRange(0, range1.location);
    
    if (range1.location != NSNotFound &&
        range2.location != NSNotFound) {
        
        NSString *stringListClass = [getStringPropertyClass substringWithRange:range];
        
        propertyClass = objc_getClass([stringListClass UTF8String]);
    }
    else {
        
        propertyClass = objc_getClass([getStringPropertyClass UTF8String]);
    }
    
    return propertyClass;
}

- (NSString *)getStringPropertyClass:(NSString *)propertyName; {
    
    Class objectClass = object_getClass(self);
    
    objc_property_t property = class_getProperty(objectClass, [propertyName cStringUsingEncoding:NSUTF8StringEncoding] );
    
    const char* cPropertyClass = property_copyAttributeValue(property, "T");
    
    NSString *sPropertyClass = [[NSString alloc] initWithCString:cPropertyClass encoding:NSUTF8StringEncoding];
    
    return sPropertyClass;
}

+ (NSArray *)getAllUniquePropertiesToObjectClass; {
    
    return [[self class] getAllUniquePropertiesToObjectClass:[self class]];
}

+ (NSArray *)getAllUniquePropertiesToObjectClass:(Class)objectClass; {
    
    __block NSArray *allUniqueKeys = [[NSArray alloc] init];
    
    MBOInspectableModel *object = [[objectClass alloc] init];
    
    if ([object conformsToProtocol:@protocol(MBOInspectableObject)]) {
        
        allUniqueKeys = [allUniqueKeys arrayByAddingObjectsFromArray:[object settersPropertyNames].allObjects];
        
        for (__weak NSString *propertyName in [object propertyNames]) {
            
            Class propertyClass = [object getPropertyClassWrapClass:propertyName];
            
            Class parseElementClass = [object getPropertyClassElementToParse:propertyName];
            
            if (propertyClass == [NSArray class]) {
                
                allUniqueKeys = [allUniqueKeys arrayByAddingObjectsFromArray:[[self class] getAllUniquePropertiesToObjectClass:parseElementClass]];
            }
            else if ([propertyClass conformsToProtocol:@protocol(MBOInspectableObject)]) {
                
                allUniqueKeys = [allUniqueKeys arrayByAddingObjectsFromArray:[[self class] getAllUniquePropertiesToObjectClass:propertyClass]];
            }
        }
    }
    
    return allUniqueKeys;
}

- (NSString *)description {
    
    NSString *desc = [[NSString alloc] initWithFormat:@"%@ : {", NSStringFromClass([self class])];
    
    if ([self conformsToProtocol:@protocol(MBOInspectableObject)]) {
        
        for (__weak NSString *propertyName in [self propertyNames]) {
            
            SEL propertyGetter = [self getPropertyGetter:propertyName];
            
            if (class_respondsToSelector([self class], propertyGetter)) {
                
                id (*objc_msgSendTypedGetter)(id _self, SEL _cmd) = (void*)objc_msgSend;
                
                id value = objc_msgSendTypedGetter(self, propertyGetter);
                
                if (![value isKindOfClass:[NSNull class]]) {
                    
                    desc = [desc stringByAppendingFormat:@"\r%@ : %@", propertyName, value];
                }
            }
        }
    }
    
    desc = [desc stringByAppendingFormat:@"\r}"];
    
    return desc;
}

@end
