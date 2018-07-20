//
//  MentorDetailsViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "MentorDetailsViewController.h"
#import "PFUser+ExtendedUser.h"
#import "DiscoverTableViewController.h"
#import "Parse/Parse.h"
#import "ParseUI.h"

@interface MentorDetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *mentorName;
@property (weak, nonatomic) IBOutlet UILabel *occupationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UITextView *mentorDescription;
@property (weak, nonatomic) IBOutlet UITextView *giveAdviceText;
@property (weak, nonatomic) IBOutlet UITextView *getAdviceText;

@end

@implementation MentorDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMentor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMentor {
    
    //self.profilePictureImageView.file = self.mentor.profilePic;
    self.mentorName.text = self.mentor.name;
    self.occupationLabel.text = [[self.mentor.jobTitle stringByAppendingString:@" at "] stringByAppendingString:self.mentor.company];
    self.locationLabel.text = @"Lives in Mountain View, CA";
    self.educationLabel.text = [@"Attends " stringByAppendingString: self.mentor.school];
    self.mentorDescription.text = self.mentor.bio;
    
    if( self.mentor.giveAdviceInterests.count != 0 ){
        self.giveAdviceText.text = self.mentor.giveAdviceInterests[0];
    } else {
        self.giveAdviceText.text = @"None at the moment";
    }
    
    if( self.mentor.getAdviceInterests.count != 0 ){
        self.getAdviceText.text = self.mentor.getAdviceInterests[0];
    } else {
        self.getAdviceText.text = @"None at the moment";
    }
}

- (void) refreshData {
    
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
