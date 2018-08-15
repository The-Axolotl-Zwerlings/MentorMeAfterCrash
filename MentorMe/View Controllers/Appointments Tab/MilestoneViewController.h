//
//  MilestoneViewController.h
//  MentorMe
//
//  Created by Taylor Murray on 8/2/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MilestoneTableView.h"
#import "Milestone.h"
#import "Parse.h"
@interface MilestoneViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) Milestone *milestone;
@property (nonatomic, strong) PFUser *mentor;
@property (nonatomic, strong) PFUser *mentee;
-(void)setUI;
@end
