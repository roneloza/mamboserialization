//
//  MBOJSONSerializationParse.h
//  MamboSerialization
//
//  Created by Rone Loza on 8/16/17.
//  Copyright © 2017 Mambo. All rights reserved.
//

@import Foundation;

@interface MBOJSONSerializationParse : NSObject

@property (nonatomic, strong, readonly) id root;

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithFoundation:(id)foundation;

- (id)getValueForKeyPath:(NSString *)key;
- (NSDictionary *)getDictForKeyPath:(NSString *)key;
- (NSArray *)getArrayForKeyPath:(NSString *)key;

- (id)getValueForKeyPath:(NSString *)key atIndex:(NSInteger)index;
- (NSDictionary *)getDictForKeyPath:(NSString *)key atIndex:(NSInteger)index;
- (NSArray *)getArrayForKeyPath:(NSString *)key atIndex:(NSInteger)index;

- (NSDictionary *)getRootDictionary;
- (NSArray *)getRootArray;

- (id)parseRootObjectToObjectClass:(Class)objectClass;
- (NSArray *)parseRootObjectToArrayObjectClass:(Class)objectClass;

- (id)parseByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass;
- (id)parseToObjectByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass;
- (NSArray *)parseToArrayByKeyPath:(NSString *)keyPath toObjectClass:(Class)objectClass;

+ (NSArray *)parseArray:(NSArray *)array toObjectClass:(Class)objectClass;

+ (id)parseDictionary:(NSDictionary *)dictionary toObjectClass:(Class)objectClass;

+ (NSArray *)getAllUniqueKeysToSerializeObject:(id)serializeObject;

@end
