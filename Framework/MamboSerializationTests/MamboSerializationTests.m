//
//  MamboSerializationTests.m
//  MamboSerializationTests
//
//  Created by Rone Loza on 1/4/18.
//  Copyright © 2018 Mambo. All rights reserved.
//

//#import <XCTest/XCTest.h>
//
//@interface MamboSerializationTests : XCTestCase
//
//@end
//
//@implementation MamboSerializationTests
//
//- (void)setUp {
//    [super setUp];
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//}
//
//- (void)tearDown {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}
//
//- (void)testExample {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}
//
//@end

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import <XCTest/XCTest.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "MBOJSONSerializationParse.h"
#import "MBOInspectableModel.h"
#import "SAOMeQuiz.h"
#import "SAOMeQuizAnswer.h"
#import "SAOMeQuizQuestion.h"


SpecBegin(MamboSerializationTests)

// Tests go here

describe(@"Verifying the model creation quiz", ^{
    
    __block __strong SAOMeQuiz *testObject;
    __block __strong id mockObject;
    
    void (^fillData)(NSString *filename) = ^(NSString *filename) {
        
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]];
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        MBOJSONSerializationParse *parserJson = [[MBOJSONSerializationParse alloc] initWithData:data];
        
        NSError *error = nil;
        
        NSDictionary *foundation = [parserJson getDictForKeyPath:@"data"];
        
        testObject = [SAOMeQuiz newWithData:foundation error:&error];
//        testObject = [parserJson parseByKeyPath:@"data" toObjectClass:[SAOMeQuiz class] error:&error];
        
        error = nil;
    };
    
    describe(@"Verifying the model creation quiz detail", ^{
        
        it(@"Model Creation", ^{
            
            fillData(@"quizDetail.json");
            
            SAOMeQuiz* quizTest = [testObject copy];

            mockObject = OCMPartialMock(quizTest);

            [[[mockObject expect] andReturn:@"49423de4-87a3-5354-842d-3e17c789b9c8"] identifier];
            [[[mockObject expect] andReturn:@"Programación orientada a objetos"] name];
            [[[mockObject expect] andReturn:@"d6DC3dbtn2k"] video];
            [[[mockObject expect] andReturn:@"https://player.vimeo.com/external/203835012.sd.mp4?s=6ee2ccf21cfe8ff9ffb5eae5e05f8a8fd50b0f1a&profile_id=164"] vimeo];
            [(SAOMeQuiz *)[[mockObject expect] andReturn:@(2017)] year];
            [(SAOMeQuiz *)[[mockObject expect] andReturn:@(4)] month];
            [[[mockObject expect] andReturn:@(true)] enabled];
            [(SAOMeQuiz *)[[mockObject expect] andReturn:@""] created];
            [(SAOMeQuiz *)[[mockObject expect] andReturn:@(false)] resolved];
            [(SAOMeQuiz *)[[mockObject expect] andReturn:@(false)] isComplete];


            //Assert
            XCTAssertEqualObjects(quizTest, mockObject);

            [mockObject verify];
        });
    });
    
    describe(@"Verifying the model archiving", ^{
        
        it(@"Model archiver", ^{
            
            fillData(@"quizDetail.json");
            
            SAOMeQuiz *quizTest = [testObject copy];
            
            NSData *archive = [quizTest getArchivedVersion];
            
//            NSSet *classes = [NSSet setWithArray:@[[SAOMeQuiz class], [NSArray class], [SAOMeQuizQuestion class]]];
            // Should throw, but it does not.
            SAOMeQuiz *loaded = [SAOMeQuiz initWithArchivedVersion:archive];
            
            //Assert
            XCTAssertEqualObjects(quizTest, loaded);
            
        });
    });
});

SpecEnd
