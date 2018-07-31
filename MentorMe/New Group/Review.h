//
//  Review.h
//  MentorMe
//
//  Created by Taylor Murray on 7/30/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "PFObject.h"
#import "PFUser+ExtendedUser.h"
#import "Parse/Parse.h"
#import "ParseUI.h"

@interface Review : PFObject <PFSubclassing>


@property (strong, nonatomic) PFUser *reviewee;

@property (strong, nonatomic) NSNumber *rating;

@property (strong, nonatomic) NSArray *complimentsArray;

/*Compliments Array
 0 - Great Convo
 1 - Down to Earth
 2 - Useful Advice
 3 - Friendly
 4 - Super Knowledgeable
 */

+(void)postReview:(PFUser *)reviewee withRating:(NSNumber *)rating andComplimentsArray:(NSArray *)compliments;
@end
