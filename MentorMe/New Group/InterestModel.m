//
//  InterestModel.m
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "InterestModel.h"

@implementation InterestModel

@dynamic category;
@dynamic subject;
@dynamic users;
@dynamic iconForDetails;
@dynamic iconForFeed;


+(NSString *)parseClassName{
    return @"InterestModel";
}


+(void) addInterest: (NSString*) theSubject inCategory: (NSString*) theCategory withUsers:(PFRelation*) theUsers withSmallIcon: (PFImageView *) iconForFeed withLargeIcon: (PFImageView *) iconForDetails{
    
    PFObject* interest = [PFObject objectWithClassName:@"InterestsModel"];
    interest[@"category"] = theCategory;
    interest[@"subject"] = theSubject;
    interest[@"users"] = theUsers;
    interest[@"iconForFeed"] = iconForFeed;
    interest[@"iconForDetails"] = iconForDetails;
    
    
    [interest saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Interest added");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
}
@end
