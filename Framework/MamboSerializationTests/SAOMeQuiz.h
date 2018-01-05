//
//  SAOMeQuiz.h
//  Ahora
//
//  Created by Rone Loza on 7/5/17.
//  Copyright © 2017 Mambo. All rights reserved.
//

//#import "SAOBaseModelObject.h"
#import "MBOInspectableModel.h"

/**
*@brief JSON data for service /api/v1/loyalty/me/quizzes
*
{
    "id": "49423de4-87a3-5354-842d-3e17c789b9c8",
    "name": "Programación orientada a objetos",
    "video": "d6DC3dbtn2k",
    "vimeo": "https://player.vimeo.com/external/203835012.sd.mp4?s=6ee2ccf21cfe8ff9ffb5eae5e05f8a8fd50b0f1a&profile_id=164",
    "year": 2017,
    "month": 4,
    "enabled": true,
    "created": "",
    "resolved": false,
    "is_complete": false,
    "questions": []
}
*
**/
@protocol SAOMeQuizQuestion;

@interface SAOMeQuiz : MBOInspectableModel

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *video;
@property (nonatomic, strong, readonly) NSString *vimeo;
@property (nonatomic, strong, readonly) NSNumber *year;
@property (nonatomic, strong, readonly) NSNumber *month;
@property (nonatomic, strong, readonly) NSNumber *enabled;
@property (nonatomic, strong, readonly) NSString *created;
@property (nonatomic, strong, readonly) NSNumber *resolved;
@property (nonatomic, strong, readonly) NSNumber *isComplete;
@property (nonatomic, strong, readonly) NSArray<SAOMeQuizQuestion> *questions;

@end
