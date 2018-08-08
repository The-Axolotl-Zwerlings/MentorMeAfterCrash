//
//  AppointmentDetailsViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "AppointmentDetailsViewController.h"
#import "ParseUI.h"
#import "Parse.h"
#import "DateTools.h"
#import "ReviewViewController.h"
@interface AppointmentDetailsViewController ()
@property (strong, nonatomic) IBOutlet PFImageView *menteeProfileView;

@property (weak, nonatomic) IBOutlet UIImageView *aboutUserBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *mentorBioLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutUserLabel;

@property (weak, nonatomic) IBOutlet UILabel *meetingTitleLabel;

//details
@property (weak, nonatomic) IBOutlet UILabel *meetingDetailsLabel;



@end


@implementation AppointmentDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.49 green:0.83 blue:0.69 alpha:1.0];
    [self loadAppointment];
    
    self.aboutUserBackgroundImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.aboutUserBackgroundImage.layer.shadowOffset = CGSizeMake(0, 5);
    self.aboutUserBackgroundImage.layer.shadowOpacity = 0.4;
    self.aboutUserBackgroundImage.layer.shadowRadius = 3.0;
    self.aboutUserBackgroundImage.clipsToBounds = NO;
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)loadAppointment{
    NSString *titleString;
    
    self.menteeProfileView.layer.borderColor = UIColor.whiteColor.CGColor;

    
    PFUser *otherAttendee;
    BOOL isMentor = NO;
    //1. Check if current user is mentor or mentee of meeting
    if(self.appointment.mentor.username == PFUser.currentUser.username){
        otherAttendee = self.appointment.mentee;
        isMentor = YES;
         self.menteeProfileView.layer.borderColor = UIColor.cyanColor.CGColor;
    } else{
        otherAttendee = self.appointment.mentor;
         self.menteeProfileView.layer.borderColor = UIColor.blueColor.CGColor;
    }
    self.menteeProfileView.layer.borderWidth = 5;
    self.menteeProfileView.layer.masksToBounds = true;
    self.menteeProfileView.layer.cornerRadius = self.menteeProfileView.frame.size.width / 2;
    
    titleString = [@"Meeting with " stringByAppendingString:otherAttendee.name];
    self.menteeProfileView.file = otherAttendee.profilePic;
    
    //2. Check if appointment is upcoming or past
    if(![self.appointment.isUpcoming boolValue] && !isMentor){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Write a Review" style:UIBarButtonItemStylePlain target:self action:@selector(random)];
        NSLog(@"Added a button");
    } else if(isMentor){
        self.navigationItem.rightBarButtonItem.title = @"";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"Edit details";
    }
    
    //3. Update labels and images
    
    self.meetingTitleLabel.text = titleString;
    self.aboutUserLabel.text = [@"About " stringByAppendingString:otherAttendee.name];
    self.mentorBioLabel.text = otherAttendee.bio;
    [self.mentorBioLabel sizeToFit];
    
    //Location
    NSString *location = [@" at " stringByAppendingString: self.appointment.meetingLocation];
    //Date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *date = [@" on " stringByAppendingString: [formatter stringFromDate:self.appointment.meetingDate]];
    
    //Meeting type
    NSString *type = self.appointment.meetingType;
    UIImage *imageForBox;
    if( [type isEqualToString: @"Lunch"] ){
        imageForBox = [UIImage imageNamed:@"spoon-knife"];
    } else if ( [type isEqualToString: @"Coffee"] ){
        imageForBox = [UIImage imageNamed:@"mug"];
    } else {
        imageForBox = [UIImage imageNamed:@"video-camera"];
    }
    self.imageType.image = imageForBox;
    
    NSString *fullDetails = [[type stringByAppendingString:location] stringByAppendingString:date];
    self.meetingDetailsLabel.text = fullDetails;
    
    
   
    
    
}


-(void)random{
    [self performSegueWithIdentifier:@"ReviewSegue" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"ReviewSegue"]){
        ReviewViewController *reviewViewController = [segue destinationViewController];
        reviewViewController.reviewee = self.appointmentWith;
    }
}


@end
