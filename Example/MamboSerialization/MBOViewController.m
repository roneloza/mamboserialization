//
//  MBOViewController.m
//  MamboSerialization
//
//  Created by Rone Loza on 08/16/2017.
//  Copyright (c) 2017 Rone Loza. All rights reserved.
//

#import "MBOViewController.h"
#import "MBOGooglePlaceAutoCompletePrediction.h"

@import MamboSerialization;

@interface MBOViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<MBOGooglePlaceAutoCompletePrediction *> *predictions;

@end

@implementation MBOViewController

- (void)placeAutocompleteByInputAddress:(NSString *)addressString
                   success:(void (^)(NSArray<MBOGooglePlaceAutoCompletePrediction *> *predictions))success
                   failure:(void (^)(NSError *))failure {
//    NSURLSessionDataTask *geocodingTask =
    
    [self taskPlaceAutocompleteByInputAddress:addressString resultsLanguage:@"es" success:^(NSArray<MBOGooglePlaceAutoCompletePrediction *> *predictions) {
        
        if (success) success(predictions);
        
    } failure:^(NSError *error, NSString *statusCode) {
        
        if (failure) failure(error);
    }];
}

- (NSURLSessionDataTask *)taskPlaceAutocompleteByInputAddress:(NSString *)address
                                 resultsLanguage:(NSString *)resultsLanguage
                                         success:(void (^)(NSArray<MBOGooglePlaceAutoCompletePrediction *> *))success
                                         failure:(void (^)(NSError *error, NSString *statusCode))failure {
    
    // TODO: Get a valid GOOGLE MAPS API KEY
    NSString *urlString = [NSString stringWithFormat:@"%@/place/autocomplete/json?key=%@&input=%@&components=country:pe&language=%@",@"https://maps.googleapis.com/maps/api",
                           @"AIzaSyBfMFTHiNZleqX2bcOsOM65RMSH5_DjfHY",
                           address,
                           resultsLanguage];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURL *URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *geocodingTask = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *taskError) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (taskError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) failure(taskError, @"UnknownError");
            });
        }
        else{
            
            NSError *serializationError;
        
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
            
            if (serializationError) {
            
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    if (failure) failure(serializationError, @"UnknownError");
                });
            }
            else{
                
                NSString *statusCode = [[responseDict objectForKey:@"status"] isEqualToString:@"OK"] ? @"OK" : @"NotFound" ;
                
                if ([statusCode isEqualToString:@"OK"]) {
                    
                    MBOJSONSerializationParse *parser = [[MBOJSONSerializationParse alloc] initWithData:data];
                    
                    NSArray<MBOGooglePlaceAutoCompletePrediction *> *predictions = [parser parseToArrayByKeyPath:@"predictions" toObjectClass:[MBOGooglePlaceAutoCompletePrediction class]];
                    
                    //NSString *status = [responseDict objectForKey:@"status"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (success) success(predictions);
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (failure) failure(nil, statusCode);
                    });
                }
            }
        }
    }];
    
    [geocodingTask resume];
    return geocodingTask;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self placeAutocompleteByInputAddress:@"av+la" success:^(NSArray<MBOGooglePlaceAutoCompletePrediction *> *predictions) {
        
        self.predictions = predictions;
        [self.tableView reloadData];
        
        [self secureArchiveModelObject:[self.predictions lastObject]];
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)secureArchiveModelObject:(MBOGooglePlaceAutoCompletePrediction *)objectModel {
    
//    NSMutableData *data = [NSMutableData data];
//    NSKeyedArchiver *secureEncoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [secureEncoder setRequiresSecureCoding:YES]; // just to ensure things
//    
//    NSString *key = @"key";
//    
//    MBOGooglePlaceAutoCompletePrediction *prediction = objectModel;
//    
//    [secureEncoder encodeObject:prediction forKey:key];
//    [secureEncoder finishEncoding];
//    
//    NSKeyedUnarchiver *secureDecoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    [secureDecoder setRequiresSecureCoding:YES];
//    
//    [secureDecoder setClass:[objectModel class] forClassName:NSStringFromClass([objectModel class])];
//    
//    NSSet *classes = [NSSet setWithObjects:
//                      [NSArray class],
//                      [MBOGooglePlaceAutoCompletePrediction class],
//                      [MBOGooglePlaceAutoCompleteTerms class],
//                      [MBOGooglePlaceAutoCompleteStructuredFormatting class],
//                      [MBOGooglePlaceAutoCompleteMatchedSubstrings class],
//                      nil];
//    
//    MBOGooglePlaceAutoCompletePrediction *predictionDecoded = [secureDecoder decodeObjectOfClasses:classes forKey:key];
//    
//    predictionDecoded = nil;
//    
//    [secureDecoder finishDecoding];
    
    NSData *data = [objectModel getArchivedVersion];
    
    MBOGooglePlaceAutoCompletePrediction *predictionDecoded = [MBOGooglePlaceAutoCompletePrediction initWithArchivedVersion:data];
    
    MBOGooglePlaceAutoCompletePrediction *predictionDecodedCopy = [predictionDecoded copy];
    
    predictionDecoded = nil;
    predictionDecodedCopy = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Fetch Data
//
#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.predictions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak MBOGooglePlaceAutoCompletePrediction *prediction = [self.predictions objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PredictionTVC" forIndexPath:indexPath];
    
    cell.textLabel.text = prediction.desc;
    
    return cell;
}

@end
