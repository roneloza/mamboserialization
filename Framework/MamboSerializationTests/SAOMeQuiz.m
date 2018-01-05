//
//  SAOMeQuiz.m
//  Ahora
//
//  Created by Rone Loza on 7/5/17.
//  Copyright © 2017 Mambo. All rights reserved.
//

#import "SAOMeQuiz.h"

@interface SAOMeQuiz ()

@property (nonatomic, strong, readwrite, setter=id:) NSString *identifier;
@property (nonatomic, strong, readwrite, setter=name:) NSString *name;
@property (nonatomic, strong, readwrite, setter=video:) NSString *video;
@property (nonatomic, strong, readwrite, setter=vimeo:) NSString *vimeo;
@property (nonatomic, strong, readwrite, setter=year:) NSNumber *year;
@property (nonatomic, strong, readwrite, setter=month:) NSNumber *month;
@property (nonatomic, strong, readwrite, setter=enabled:) NSNumber *enabled;
@property (nonatomic, strong, readwrite, setter=created:) NSString *created;
@property (nonatomic, strong, readwrite, setter=resolved:) NSNumber *resolved;
@property (nonatomic, strong, readwrite, setter=is_complete:) NSNumber *isComplete;
@property (nonatomic, strong, readwrite, setter=questions:) NSArray<SAOMeQuizQuestion>  *questions;

@end

@implementation SAOMeQuiz

@end
