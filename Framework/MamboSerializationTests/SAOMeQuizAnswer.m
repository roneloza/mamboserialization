//
//  SAOMeQuizDetail.m
//  Ahora
//
//  Created by Rone Loza on 7/6/17.
//  Copyright © 2017 Mambo. All rights reserved.
//

#import "SAOMeQuizAnswer.h"


@interface SAOMeQuizAnswer()

@property (nonatomic, strong, readwrite, setter=id:) NSString *identifier;
@property (nonatomic, strong, readwrite, setter=description:) NSString *desc;
@property (nonatomic, strong, readwrite, setter=is_correct:) NSNumber *isCorrect;
@property (nonatomic, strong, readwrite, setter=type:) NSString *type;
@property (nonatomic, strong, readwrite, setter=order:) NSNumber *order;
@property (nonatomic, strong, readwrite, setter=enabled:) NSNumber *enabled;
@property (nonatomic, strong, readwrite, setter=created:) NSString *created;

@end

@implementation SAOMeQuizAnswer

@end
