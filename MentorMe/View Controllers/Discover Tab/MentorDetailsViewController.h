//
//  MentorDetailsViewController.h
//  MentorMe
//
//  Created by Nico Salinas on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFUser+ExtendedUser.h"
#import "Parse/Parse.h"

@interface MentorDetailsViewController : UIViewController

@property ( strong, nonatomic ) PFUser *mentor;

@end
