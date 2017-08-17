//
//  MBOInspectableObject.h
//  MamboSerialization
//
//  Created by Rone Loza on 8/16/17.
//  Copyright © 2017 Mambo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MBOInspectableObject <NSObject>

@property (nonatomic, copy) NSSet *propertyNames;

- (NSString *)getPropertyAttributes:(NSString *)propertyName;

- (SEL)getPropertySetter:(NSString *)propertyName;

- (SEL)getPropertyGetter:(NSString *)propertyName;

- (Class)getPropertyClassElementToParse:(NSString *)propertyName;

- (Class)getPropertyClassWrapClass:(NSString *)propertyName;

@end
