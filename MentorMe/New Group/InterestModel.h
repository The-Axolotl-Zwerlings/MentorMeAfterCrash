//
//  InterestModel.h
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "PFObject.h"
#import "Parse/Parse.h"
#import "ParseUI.h"

@interface InterestModel : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString* category;
@property (strong, nonatomic) PFRelation* users;
@property (strong, nonatomic) NSString* subject;
@property (strong, nonatomic) PFFile* icon;


+(void) addInterest: (NSString*) theSubject inCategory: (NSString*) theCategory withUsers:(PFRelation*) theUsers withIcon: (PFFile *) icon;

@end
