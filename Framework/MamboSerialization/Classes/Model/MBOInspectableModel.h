//
//  MBOInspectableModel.h
//  MamboSerialization
//
//  Created by Rone Loza on 8/16/17.
//  Copyright © 2017 Mambo. All rights reserved.
//

@import Foundation;
#import "MBOInspectableObject.h"

@interface MBOInspectableModel : NSObject<MBOInspectableObject, NSCopying, NSSecureCoding>

+ (instancetype)newWithData:(NSDictionary *)data;
+ (instancetype)newWithData:(NSDictionary *)data error:(NSError **)error;
+ (NSString *)classNameString;
+ (instancetype)initWithArchivedVersion:(NSData *)archivedVersion;
- (NSData *)getArchivedVersion;
+ (NSArray *)getAllUniquePropertiesToObjectClass;

@end
