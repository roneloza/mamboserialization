//
//  SAOMeQuizDetail.h
//  Ahora
//
//  Created by Rone Loza on 7/6/17.
//  Copyright © 2017 Mambo. All rights reserved.
//

#import "MBOInspectableModel.h"

/**
 *@brief JSON data for service /api/v1/loyalty/me/quizzes/{{id}}
 *
{
    "id": "bccac937-d0d5-559d-817c-a3ec23ec9836",
    "description": "Esta es la correcta",
    "is_correct": true,
    "type": "single",
    "order": 0,
    "enabled": false,
    "created": "2017-06-20 20:07:54"
}
 *
 **/
@protocol SAOMeQuizAnswer <NSObject>

@end
@interface SAOMeQuizAnswer : MBOInspectableModel

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSString *desc;
@property (nonatomic, strong, readonly) NSNumber *isCorrect;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSNumber *order;
@property (nonatomic, strong, readonly) NSNumber *enabled;
@property (nonatomic, strong, readonly) NSString *created;

@end
