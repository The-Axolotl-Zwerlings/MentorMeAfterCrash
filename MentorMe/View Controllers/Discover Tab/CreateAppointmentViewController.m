//
//  CreateAppointmentViewController.m
//  MentorMe
//
//  Created by Taylor Murray on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "CreateAppointmentViewController.h"
#import "ParseUI.h"
#import "Parse.h"

@interface CreateAppointmentViewController ()



@property (strong, nonatomic) IBOutlet UIImageView *mentorIconView;
@property (strong, nonatomic) IBOutlet PFImageView *mentorProfilePicView;
@property (weak, nonatomic) IBOutlet UILabel *mentorNameLabel;


@property (strong, nonatomic) IBOutlet UIImageView *menteeIconView;
@property (strong, nonatomic) IBOutlet PFImageView *menteeProfilePicView;
@property (weak, nonatomic) IBOutlet UILabel *menteeNameLabel;


@property (weak, nonatomic) IBOutlet UILabel *sendMessageLabel;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *appointmentTypeSegControl;

@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IBOutlet UILabel *meetingWithLabel;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) NSString *meetingType;
@property (strong, nonatomic) NSDictionary *meetingTypeDic;

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
    
}

- (void) loadAppointmentDetails {
    if(self.appointmentTypeSegControl.selectedSegmentIndex == 0){ //coffww
        self.dateTextField.text = @"2:00 pm on 6/1/18";
        self.locationLabel.text = @"Red Rock Café";
    } else if(self.appointmentTypeSegControl.selectedSegmentIndex == 1){ //lunch
        self.dateTextField.text = @"12:00 pm on 6/2/18";
        self.locationLabel.text = @"Jimmy Johns";
    } else{
        self.dateTextField.text = @"9:00pm on 6/3/18";
        self.locationLabel.text = @"Skype";
    }
}


- (void) loadProfiles {
    
    PFUser *myUser = [PFUser currentUser];
    PFUser *otherUser = self.otherAttendee;
    
    self.menteeProfilePicView.file = myUser.profilePic;
    self.mentorProfilePicView.file = otherUser.profilePic;
    
    self.menteeNameLabel.text = myUser.name;
    self.mentorNameLabel.text = otherUser.name;
    

    
    
    
    self.sendMessageLabel.text = [[@"Send " stringByAppendingString:otherUser.name] stringByAppendingString:@" a message: "];
    
    
    
}

- (void) loadDateTool {
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
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
    
    
    [AppointmentModel postAppointment:self.isMentorOfMeeting withPerson:self.otherAttendee withMeetingLocation:self.locationLabel.text withMeetingType:self.meetingTypeDic[@(self.appointmentTypeSegControl.selectedSegmentIndex)] withMeetingDate:datePicker.date withIsComing:YES withMessage:self.messageTextView.text withCompletion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didChangeType {
    [self loadAppointmentDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
