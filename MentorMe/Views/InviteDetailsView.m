//
//  InviteDetailsView.m
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 8/8/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "InviteDetailsView.h"

@implementation InviteDetailsView

-(void)setDisplay{
    self.picture.layer.cornerRadius = self.picture.frame.size.width/2;
    self.picture.layer.masksToBounds = YES;
    self.picture.layer.borderColor = [UIColor colorWithRed:0.22 green:0.97 blue:0.66 alpha:1.0].CGColor;
    self.picture.layer.borderWidth = 3;
    
    [self.nameLabel setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [self.companyLabel setFont:[UIFont fontWithName:@"Avenir" size:12]];
    [self.institutionLabel setFont:[UIFont fontWithName:@"Avenir" size:12]];
    [self.majorLabel setFont:[UIFont fontWithName:@"Avenir" size:12]];
    [self.positionLabel setFont:[UIFont fontWithName:@"Avenir" size:12]];
    [self.messageLabel setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [self.dateLabel setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [self.locationLabel setFont:[UIFont fontWithName:@"Avenir" size:15]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
