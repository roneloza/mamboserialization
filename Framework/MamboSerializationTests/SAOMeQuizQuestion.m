//
//  SAOMeQuizQuestion.m
//  Ahora
//
//  Created by Rone Loza on 7/7/17.
//  Copyright © 2017 Mambo. All rights reserved.
//

#import "SAOMeQuizQuestion.h"

@interface SAOMeQuizQuestion()

@property (nonatomic, strong, readwrite, setter=id:) NSString *identifier;
@property (nonatomic, strong, readwrite, setter=description:) NSString *desc;
@property (nonatomic, strong, readwrite, setter=points:) NSNumber *points;
@property (nonatomic, strong, readwrite, setter=type:) NSString *type;
@property (nonatomic, strong, readwrite, setter=order:) NSNumber *order;
@property (nonatomic, strong, readwrite, setter=enabled:) NSNumber *enabled;
@property (nonatomic, strong, readwrite, setter=created:) NSString *created;
@property (nonatomic, strong, readwrite, setter=answers:) NSArray<SAOMeQuizAnswer> *answers;

@end

@implementation SAOMeQuizQuestion

@end
