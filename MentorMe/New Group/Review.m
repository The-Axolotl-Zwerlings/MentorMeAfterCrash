//
//  Review.m
//  MentorMe
//
//  Created by Taylor Murray on 7/30/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "Review.h"

@implementation Review
@dynamic reviewee;

@dynamic rating;
@dynamic complimentsArray;

+(nonnull NSString *)parseClassName{
    return @"Review";
}

+(void)postReview:(PFUser *)reviewee withRating:(NSNumber *)rating andComplimentsArray:(NSArray *)compliments{
    
    
    PFObject *review = [PFObject objectWithClassName:@"Review"];
    review[@"reviewee"] = reviewee;
    review[@"rating"] = rating;
    review[@"complimentsArray"] = compliments;
    
    [review saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error == nil){
            NSLog(@"Saved appointment!");
        }
    }];
    
}

+(NSNumber * _Nullable)getStarRating:(PFUser *)reviewee{
    __block NSNumber *starRating = nil;
    PFQuery *query = [PFQuery queryWithClassName:@"Review"];
    [query includeKey:@"reviewee.username"];
    [query whereKey:@"reviewee.username" equalTo:reviewee.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *reviews, NSError * _Nullable error) {
        if(reviews){
            float totalRating = 0;
            for(Review *review in reviews){
                totalRating += [review.rating floatValue];
            }
            starRating = [NSNumber numberWithFloat:totalRating/reviews.count];
        }
    }];
    return starRating;
}
@end
