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
        //self.otherAttendeeProfilePic.layer.borderWidth = 5;
        //self.otherAttendeeProfilePic.layer.borderColor = CGColorRetain(UIColor.blueColor.CGColor);
        self.otherAttendeeProfilePic.layer.cornerRadius = self.otherAttendeeProfilePic.frame.size.width /2;
        self.menteeMentorIcon.image = [UIImage imageNamed:@"metaRockTransparent.png"];
        self.rockStatus.text = @"You're the metamorphasis!";
        
    } else{
        self.otherAttendeeName.text = appointment.mentor[@"name"];
        self.otherAttendeeProfilePic.file = appointment.mentor.profilePic;
        [self.otherAttendeeProfilePic loadInBackground];
        //self.mentorOrMenteeLabel.text = @"You're the mentee!";
        
        //self.otherAttendeeProfilePic.layer.masksToBounds = true;
        //self.otherAttendeeProfilePic.layer.borderWidth = 5;
        //self.otherAttendeeProfilePic.layer.borderColor = CGColorRetain(UIColor.greenColor.CGColor);
        self.otherAttendeeProfilePic.layer.cornerRadius = self.otherAttendeeProfilePic.frame.size.width /2;
        self.menteeMentorIcon.image = [UIImage imageNamed:@"pebbleTransparent.png"];
        self.rockStatus.text = @"You're the pebble!";
    }
    
    
    
    //3. Update labels and images
    
    //Location
    NSString *location = [@" at " stringByAppendingString: self.appointment.meetingLocation];
    //Date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *date = [@" on " stringByAppendingString: [formatter stringFromDate:self.appointment.meetingDate]];
    
    //Meeting type
    NSString *type = self.appointment.meetingType;
    
    NSString *fullDetails = [[type stringByAppendingString:location] stringByAppendingString:date];
    self.meetingSummaryLabel.text = fullDetails;
    
    [self.meetingSummaryLabel sizeToFit];

        
    
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
