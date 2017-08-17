//
//  MBOGooglePlaceAutoCompletePrediction.h
//  MamboSerialization
//
//  Created by Rone Loza on 8/16/17.
//  Copyright © 2017 Rone Loza. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MamboSerialization/MBOInspectableModel.h>

@protocol MBOGooglePlaceAutoCompleteTerms;
@protocol MBOGooglePlaceAutoCompleteMatchedSubstrings;

@interface MBOGooglePlaceAutoCompleteTerms : MBOInspectableModel

@property (nonatomic, strong, readonly) NSNumber *offset;
@property (nonatomic, strong, readonly) NSString *value;
@end

@interface MBOGooglePlaceAutoCompleteMatchedSubstrings : MBOInspectableModel

@property (nonatomic, strong, readonly) NSNumber *length;
@property (nonatomic, strong, readonly) NSNumber *offset;
@end

@interface MBOGooglePlaceAutoCompleteStructuredFormatting : MBOInspectableModel

@property (nonatomic, strong, readonly) NSString *mainText;
@property (nonatomic, strong, readonly) NSArray<MBOGooglePlaceAutoCompleteMatchedSubstrings> *mainTextMatchedSubstrings;
@property (nonatomic, strong, readonly) NSString *secondaryText;

@end

@interface MBOGooglePlaceAutoCompletePrediction : MBOInspectableModel

@property (nonatomic, strong, readonly) NSString *desc;
@property (nonatomic, strong, readonly) NSString *uuid;
@property (nonatomic, strong, readonly) NSArray<MBOGooglePlaceAutoCompleteMatchedSubstrings> *matchedSubstrings;
@property (nonatomic, strong, readonly) NSString *placeId;
@property (nonatomic, strong, readonly) NSString *reference;
@property (nonatomic, strong, readonly) MBOGooglePlaceAutoCompleteStructuredFormatting *structuredFormatting;

@property (nonatomic, strong, readonly) NSArray<MBOGooglePlaceAutoCompleteTerms> *terms;

@property (nonatomic, strong, readonly) NSArray *types;

@end
