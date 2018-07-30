//
//  ReviewViewController.h
//  MentorMe
//
//  Created by Taylor Murray on 7/24/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "PFUser+ExtendedUser.h"
@interface ReviewViewController : UIViewController
@property (strong, nonatomic) IBOutlet RateView *ratingView;
@property (strong, nonatomic) IBOutlet UILabel *starLabel;
@property (strong, nonatomic) IBOutlet UIButton *greatConvoButton;
@property (strong, nonatomic) IBOutlet UIButton *friendlyButton;
@property (strong, nonatomic) IBOutlet UIButton *usefulAdviceButton;
@property (strong, nonatomic) IBOutlet UIButton *superKnowledgeButton;
@property (strong, nonatomic) IBOutlet UIButton *downToEarthButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) PFUser *reviewee;
@end
