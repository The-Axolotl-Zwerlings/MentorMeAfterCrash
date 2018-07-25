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
#import "CreateAppointmentViewController.h"

#import "GetAdviceCollectionViewCell.h"
#import "GiveAdviceCollectionViewCell.h"

@interface MentorDetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *bannerImage;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *occupationLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;


@end

@implementation MentorDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMentor];
    
    self.getAdviceCollectionView.delegate = self;
    self.getAdviceCollectionView.dataSource = self;
    self.giveAdviceCollectionView.delegate = self;
    self.giveAdviceCollectionView.dataSource = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMentor {
    
    /*self.profileImage.file = self.mentor.profilePic;
    self.nameLabel.text = self.mentor.name;
    self.occupationLabel.text = [[ self.mentor.jobTitle stringByAppendingString:@" at "] stringByAppendingString:self.mentor.company];
    self.educationLabel.text = [[[ @"Studied " stringByAppendingString:self.mentor.major] stringByAppendingString:@" at "] stringByAppendingString:self.mentor.school];
    self.descriptionLabel.text = self.mentor.bio;*/

}

- (void) refreshData {
    
    
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"createAppointmentSegue"]){
        CreateAppointmentViewController *createAppointViewController = [segue destinationViewController];
        createAppointViewController.isMentorOfMeeting = self.isMentorOfMeeting;
        createAppointViewController.otherAttendee = self.mentor;
        
    }
}

@end
