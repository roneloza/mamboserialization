//
//  MBOJSONSerializationParse.h
//  MamboSerialization
//
//  Created by Rone Loza on 8/16/17.
//  Copyright © 2017 Mambo. All rights reserved.
//

@import Foundation;

FOUNDATION_EXPORT NSErrorDomain const MBOMamboSerializationErrorDomain;
FOUNDATION_EXPORT NSInteger const MBOMamboSerializationErrorCodeClassNoConformProtocol;
FOUNDATION_EXPORT NSInteger const MBOMamboSerializationErrorCodePropertyNoSupplyJsonKey;

//FOUNDATION_EXPORT NSErrorUserInfoKey const MBOParsingUnderlyingErrorKey;// Key in userInfo. A recommended standard way to embed NSErrors from underlying calls MamboSerialization. The value of this key should be an NSError.

@interface MBOJSONSerializationParse : NSObject

@property (nonatomic, strong, readonly) id root;

- (instancetype)initWithData:(NSData *)data ;
- (instancetype)initWithFoundation:(id)foundation;
- (instancetype)initWithData:(NSData *)data error:(NSError *__autoreleasing *)error;
- (instancetype)initWithFoundation:(id)foundation error:(NSError *__autoreleasing *)error;

#pragma mark - KVC

- (id)getValueForKeyPath:(NSString *)key;
- (NSDictionary *)getDictForKeyPath:(NSString *)key;
- (NSArray *)getArrayForKeyPath:(NSString *)key;

- (id)getValueForKeyPath:(NSString *)key atIndex:(NSInteger)index;
- (NSDictionary *)getDictForKeyPath:(NSString *)key atIndex:(NSInteger)index;
- (NSArray *)getArrayForKeyPath:(NSString *)key atIndex:(NSInteger)index;

+ (NSArray *)getAllUniqueKeysToSerializeObject:(id)serializeObject;

#pragma mark - Parser

- (NSDictionary *)getRootDictionary;
- (NSArray *)getRootArray;

- (id)parseRootObjectToObjectClass:(Class)objectClass;
- (NSArray *)parseRootObjectToArrayObjectClass:(Class)objectClass;

- (id)parseByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass;
- (id)parseToObjectByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass;
- (NSArray *)parseToArrayByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass;

+ (NSArray *)parseArray:(NSArray *)array toObjectClass:(Class)objectClass;
+ (id)parseDictionary:(NSDictionary *)dictionary toObjectClass:(Class)objectClass;

#pragma mark - Parser Handling Error

- (NSArray *)parseRootObjectToArrayObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error;
- (id)parseToObjectByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error;
- (NSArray *)parseToArrayByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error;
- (id)parseRootObjectToObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error;
- (id)parseByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error;

+ (NSArray *)parseArray:(NSArray *)array toObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error;
+ (id)parseDictionary:(NSDictionary *)dictionary toObjectClass:(Class)objectClass error:(NSError *__autoreleasing *)error;

@end
