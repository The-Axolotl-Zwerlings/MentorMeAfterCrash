//
//  AppointmentCell.m
//  MentorMe
//
//  Created by Nico Salinas on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "AppointmentCell.h"
#import "AppointmentDetailsViewController.h"
#import "PFUser+ExtendedUser.h"
#import "Parse/Parse.h"
#import "DateTools.h"





@implementation AppointmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setAppointment:(AppointmentModel *)appointment {
   
    _appointment = appointment;
    
    CGSize newSize = CGSizeMake(self.otherAttendeeProfilePic.frame.size.width, self.otherAttendeeProfilePic.frame.size.width);
    

    if([appointment.mentor.username isEqualToString:PFUser.currentUser.username]){
        self.otherAttendeeName.text = appointment.mentee[@"name"];
        self.otherAttendeeProfilePic.file = appointment.mentee.profilePic;
        
        [self.otherAttendeeProfilePic loadInBackground];
        //self.mentorOrMenteeLabel.text = @"You're the mentor!";
        
        self.otherAttendeeProfilePic.layer.masksToBounds = true;
        self.otherAttendeeProfilePic.layer.borderWidth = 5;
        self.otherAttendeeProfilePic.layer.borderColor = CGColorRetain(UIColor.blueColor.CGColor);
        self.otherAttendeeProfilePic.layer.cornerRadius = self.otherAttendeeProfilePic.frame.size.width /2;
        
    } else{
        self.otherAttendeeName.text = appointment.mentor[@"name"];
        self.otherAttendeeProfilePic.file = appointment.mentor.profilePic;
        [self.otherAttendeeProfilePic loadInBackground];
        //self.mentorOrMenteeLabel.text = @"You're the mentee!";
        
        self.otherAttendeeProfilePic.layer.masksToBounds = true;
        self.otherAttendeeProfilePic.layer.borderWidth = 5;
        self.otherAttendeeProfilePic.layer.borderColor = CGColorRetain(UIColor.yellowColor.CGColor);
        self.otherAttendeeProfilePic.layer.cornerRadius = self.otherAttendeeProfilePic.frame.size.width /2;
    }
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    
    
    self.meetingDate.text = [formatter stringFromDate:appointment.meetingDate];
    self.meetingType.text = self.appointment.meetingType;
    self.meetingLocation.text = self.appointment.meetingLocation;
        
    
}


- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
    
}

@end
