//
//  GetAdviceCollectionViewCell.m
//  MentorMe
//
//  Created by Nico Salinas on 7/24/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "GetAdviceCollectionViewCell.h"
#import "Parse/Parse.h"
#import "InterestModel.h"
#import "ParseUI.h"
#import "PFUser+ExtendedUser.h"

@implementation GetAdviceCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)reloadInputViews
{
    self.interestNameLabel.text = [@"#" stringByAppendingString: self.interest.subject];

    self.backgroundImage.layer.borderColor = UIColor.whiteColor.CGColor;
    self.backgroundImage.layer.borderWidth = 2;

    
    self.backgroundImage.layer.masksToBounds = YES;
    self.backgroundImage.layer.cornerRadius = self.backgroundImage.frame.size.height/2;
    
    
}

- (void)drawRect:(CGRect)rect
{
    [self reloadInputViews];
    // Drawing code
}

@end
