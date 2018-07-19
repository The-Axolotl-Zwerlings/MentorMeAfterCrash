//
//  PFUser+ExtendedUser.h
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "PFUser.h"
#import "Parse/Parse.h"

@interface PFUser (ExtendedUser)
@property (strong,nonatomic) PFFile *profilePic;
@property (strong, nonatomic) PFFile *backgroundPic;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *school;
@property (strong, nonatomic) NSString *jobTitle;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *major;
@property (strong, nonatomic) NSArray *giveAdviceInterests;
@property (strong, nonatomic) NSArray *getAdviceInterests;
@property (strong, nonatomic) PFRelation* usersNearby;
@property (strong, nonatomic) NSNumber *meetupNumber;
@end
