//
//  MBOGooglePlaceAutoCompletePrediction.m
//  MamboSerialization
//
//  Created by Rone Loza on 8/16/17.
//  Copyright © 2017 Rone Loza. All rights reserved.
//

#import "MBOGooglePlaceAutoCompletePrediction.h"

@interface MBOGooglePlaceAutoCompleteTerms()

@property (nonatomic, strong, setter=offset:) NSNumber *offset;
@property (nonatomic, strong, setter=value:) NSString *value;
@end

@interface MBOGooglePlaceAutoCompleteMatchedSubstrings()

@property (nonatomic, strong, setter=length:) NSNumber *length;
@property (nonatomic, strong, setter=offset:) NSNumber *offset;
@end

@interface MBOGooglePlaceAutoCompleteStructuredFormatting()

@property (nonatomic, strong, setter=main_text:) NSString *mainText;
@property (nonatomic, strong, setter=main_text_matched_substrings:) NSArray<MBOGooglePlaceAutoCompleteMatchedSubstrings> *mainTextMatchedSubstrings;
@property (nonatomic, strong, setter=secondary_text:) NSString *secondaryText;

@end

@interface MBOGooglePlaceAutoCompletePrediction()

@property (nonatomic, strong, setter=description:) NSString *desc;
@property (nonatomic, strong, setter=id:) NSString *uuid;
@property (nonatomic, strong, setter=matched_substrings:) NSArray<MBOGooglePlaceAutoCompleteMatchedSubstrings> *matchedSubstrings;
@property (nonatomic, strong, setter=place_id:) NSString *placeId;
@property (nonatomic, strong, setter=reference:) NSString *reference;
@property (nonatomic, strong, setter=structured_formatting:) MBOGooglePlaceAutoCompleteStructuredFormatting *structuredFormatting;

@property (nonatomic, strong, setter=terms:) NSArray<MBOGooglePlaceAutoCompleteTerms> *terms;

@property (nonatomic, strong, setter=types:) NSArray *types;

@end

@implementation MBOGooglePlaceAutoCompleteTerms

@end

@implementation MBOGooglePlaceAutoCompleteMatchedSubstrings

@end

@implementation MBOGooglePlaceAutoCompleteStructuredFormatting

@end

@implementation MBOGooglePlaceAutoCompletePrediction

@synthesize desc = _desc;
@end
