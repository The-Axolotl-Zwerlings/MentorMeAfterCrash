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


+(NSString *)parseClassName{
    return @"InterestModel";
}


+(void) something: (NSString*) theSubject inCategory: (NSString*) theCategory withUsers:(PFRelation*) theUsers{
    
    PFObject* interest = [PFObject objectWithClassName:@"InterestModel"];
    interest[@"category"] = theCategory;
    interest[@"subject"] = theSubject;
    interest[@"users"] = theUsers;
    
    [interest saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Interest added");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
}
@end
