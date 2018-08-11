//
//  CreateAppointmentViewController.m
//  MentorMe
//
//  Created by Taylor Murray on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "CreateAppointmentViewController.h"
#import "ParseUI.h"
#import "Parse/Parse.h"
#import "Notifications.h"
#import "HMSegmentedControl.h"

@interface CreateAppointmentViewController ()

@property (strong, nonatomic) IBOutlet PFImageView *mentorProfilePicView;
@property (strong, nonatomic) IBOutlet PFImageView *menteeProfilePicView;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UILabel *meetingWithLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *sendMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *mentorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *menteeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) NSDictionary *meetingTypeDic;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) NSString *meetingType;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@end

@implementation CreateAppointmentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.meetingWithLabel.text = [@"Meeting With " stringByAppendingString:self.otherAttendee.name];
    self.meetingTypeDic = @{ @(0) : @"Coffee", @(1) : @"Lunch", @(2) : @"Video Chat"};
    [self loadDateTool];
    [self loadAppointmentDetails];
    [self loadProfiles];
    [self loadSegmentedControl];
    
    UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender{
    [self.view endEditing:YES];
}



- (void) loadSegmentedControl{
    
    NSArray<UIImage *> *images = @[[UIImage imageNamed:@"image-1"],
                                   [UIImage imageNamed:@"image-2"],
                                   [UIImage imageNamed:@"image-3"]];
    
    NSArray<UIImage *> *selectedImages = @[[UIImage imageNamed:@"checkmark"],
                                           [UIImage imageNamed:@"checkmark"],
                                           [UIImage imageNamed:@"checkmark"]];
    NSArray<NSString *> *titles = @[@"  Meeting  ", @"  Coffee  ", @"  Video Chat  "];
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:selectedImages titlesForSections:titles];
    self.segmentedControl.imagePosition = HMSegmentedControlImagePositionLeftOfText;
    self.segmentedControl.frame = CGRectMake(0, 235, 375, 50);
    self.segmentedControl.selectionIndicatorHeight = 4.0f;
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    [self.segmentedControl addTarget:self action:@selector(didChangeSegControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    
}

- (void) loadAppointmentDetails {
    if(self.segmentedControl.selectedSegmentIndex == 0){ //coffww
        self.locationLabel.text = [@"Location: " stringByAppendingString:@"Jimmy Johns"];
    } else if(self.segmentedControl.selectedSegmentIndex == 1){ //lunch
        self.locationLabel.text = [@"Location: " stringByAppendingString:@"Red Rock Café"];
    } else{
        self.locationLabel.text = [@"Location: " stringByAppendingString:@"Skype"];
    }
}


- (void) loadProfiles {
    
    PFUser *myUser = [PFUser currentUser];
    PFUser *otherUser = self.otherAttendee;
    
    UIColor *colorA = [UIColor colorWithRed:0.87 green:0.77 blue:0.87 alpha:1.0];
    UIColor *colorB = [UIColor colorWithRed:0.86 green:0.81 blue:0.93 alpha:1.0];
    
    if( self.isMentorOfMeeting == false){
        self.mentorProfilePicView.file = myUser.profilePic;
        self.menteeProfilePicView.file = otherUser.profilePic;
        self.mentorNameLabel.text = myUser.name;
        self.menteeNameLabel.text = otherUser.name;
        
        self.mentorProfilePicView.layer.borderColor = colorA.CGColor;
        self.menteeProfilePicView.layer.borderColor = colorB.CGColor;

    } else {
        self.menteeProfilePicView.file = myUser.profilePic;
        self.mentorProfilePicView.file = otherUser.profilePic;
        self.menteeNameLabel.text = myUser.name;
        self.mentorNameLabel.text = otherUser.name;
        
        self.mentorProfilePicView.layer.borderColor = colorB.CGColor;
        self.menteeProfilePicView.layer.borderColor = colorA.CGColor;
    }
    self.mentorProfilePicView.layer.borderWidth = 5;
    self.menteeProfilePicView.layer.borderWidth = 5;
    self.mentorProfilePicView.layer.cornerRadius = self.mentorProfilePicView.frame.size.width/2;
    self.menteeProfilePicView.layer.cornerRadius = self.menteeProfilePicView.frame.size.width/2;
    self.mentorProfilePicView.layer.masksToBounds = true;
    self.menteeProfilePicView.layer.masksToBounds = true;
    
    
    self.sendMessageLabel.text = [[@"Send " stringByAppendingString:otherUser.name] stringByAppendingString:@" a message: "];
    [self.menteeProfilePicView loadInBackground];
    [self.mentorProfilePicView loadInBackground];
}

- (void) loadDateTool {
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.minuteInterval = 15;
    [self.dateTextField setInputView:datePicker];
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,320,44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(updateDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:space,doneButton,nil]];
    [self.dateTextField setInputAccessoryView:toolbar];
}


-(void)updateDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    self.dateTextField.text = [formatter stringFromDate:datePicker.date];
    [self.dateTextField resignFirstResponder];
}


- (IBAction)createAction:(UIButton *)sender {
    
    [AppointmentModel postAppointment:self.isMentorOfMeeting withPerson:self.otherAttendee withMeetingLocation:self.locationLabel.text withMeetingType:self.meetingTypeDic[@(self.segmentedControl.selectedSegmentIndex)] withMeetingDate:datePicker.date withIsComing:YES withMessage:self.messageTextView.text withconfirmation:@"NO" withCompletion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [Notifications addNotification:@"invite" withSender:[PFUser currentUser] withReciever:self.otherAttendee];
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didChangeDate:(UITextField *)sender {
    [self loadAppointmentDetails];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didChangeSegControl:(HMSegmentedControl *)sender {
    [self loadAppointmentDetails];
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
