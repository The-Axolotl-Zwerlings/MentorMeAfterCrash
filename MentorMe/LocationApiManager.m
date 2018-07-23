//
//  LocationApiManager.m
//  MentorMe
//
//  Created by Taylor Murray on 7/2/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "LocationApiManager.h"
#import <UIKit+AFNetworking.h>
@interface LocationApiManager()
@property (nonatomic,strong) NSURLSession *session;

@end

@implementation LocationApiManager

-(id)init{
    self = [super init];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    return self;
}

-(void)fetchDistanceWithOrigin:(NSString *)origin andEnd:(NSString *)end andCompletion:(void(^)(NSDictionary *elementDic,NSError *error))completion{
    
    NSString *editedOrigin = [origin stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *editedEnd = [end stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    //NSString *api_key = @"AIzaSyAUqVeGY4elRDjM3em7Z-Ydzkltw6PYZHU";


    
    NSString *fullURLString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%@&destinations=%@&key=AIzaSyAUqVeGY4elRDjM3em7Z-Ydzkltw6PYZHU", editedOrigin, editedEnd];
    
    NSURL *url = [NSURL URLWithString:fullURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Distance"
                                                                           message:@"Unable to connect to Network"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            
            // create a cancel action
            UIAlertAction *tryAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  // handle cancel response here. Doing nothing will dismiss the view.
                                                              }];
            // add the cancel action to the alertController
            [alert addAction:tryAction];
            //[self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
            //}];
            
            
            completion(nil,error);
        } else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", dataDictionary);
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
            NSDictionary *elementDic = dataDictionary[@"rows"][0][@"elements"][0];
            
            
            completion(elementDic,nil);
            //changed for search view
        }
    }];
    [task resume];
}

@end



