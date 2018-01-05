//
//  SAOMeQuizQuestion.h
//  Ahora
//
//  Created by Rone Loza on 7/7/17.
//  Copyright © 2017 Mambo. All rights reserved.
//

#import "MBOInspectableModel.h"

/**
 *@brief JSON data for service /api/v1/loyalty/me/quizzes/{{id}}
 *
 {
 "id": "e12cb9c8-ed8e-504f-aa90-6500b2940be7",
 "description": "Que es la Especializacion",
 "points": 20,
 "type": "single",
 "order": 1,
 "enabled": true,
 "created": "2017-01-23 07:32:20",
 "answers": []
 }
 *
 **/

@protocol SAOMeQuizAnswer;

@protocol SAOMeQuizQuestion <NSObject>

@end

@interface SAOMeQuizQuestion : MBOInspectableModel

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSString *desc;
@property (nonatomic, strong, readonly) NSNumber *points;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSNumber *order;
@property (nonatomic, strong, readonly) NSNumber *enabled;
@property (nonatomic, strong, readonly) NSString *created;
@property (nonatomic, strong, readonly) NSArray<SAOMeQuizAnswer> *answers;

@end
