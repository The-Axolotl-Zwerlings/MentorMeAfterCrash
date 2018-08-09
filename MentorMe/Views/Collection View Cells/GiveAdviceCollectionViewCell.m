//
//  GiveAdviceCollectionViewCell.m
//  MentorMe
//
//  Created by Nico Salinas on 7/24/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "GiveAdviceCollectionViewCell.h"
#import "Parse/Parse.h"
#import "InterestModel.h"
#import "ParseUI.h"
#import "PFUser+ExtendedUser.h"

@implementation GiveAdviceCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)loadCollectionViewCell{
    
    self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 110, 30)];
    
    //CELL BACKGROUND COLOR HERE
    self.backgroundImage.backgroundColor = [UIColor clearColor];
    self.backgroundImage.layer.borderColor = UIColor.whiteColor.CGColor;
    self.backgroundImage.layer.borderWidth = 1;
    self.backgroundImage.layer.masksToBounds = NO;
    self.backgroundImage.layer.cornerRadius = self.backgroundImage.frame.size.height/2;
    

    
    [self.contentView addSubview:self.backgroundImage];
    
    
    self.interestNameLabel = [[UILabel alloc] initWithFrame:self.backgroundImage.frame];
    self.interestNameLabel.textColor = [UIColor whiteColor];
    self.interestNameLabel.font = [UIFont fontWithName:@"Avenir" size:15];
    self.interestNameLabel.text = [@"#" stringByAppendingString: self.interest.subject];
    self.interestNameLabel.textAlignment = NSTextAlignmentCenter;
    self.interestNameLabel.numberOfLines = 0;
    self.interestNameLabel.layer.cornerRadius = self.backgroundImage.frame.size.height/2;
    
    CGSize textSize = [self.interestNameLabel intrinsicContentSize];
    
    //self.backgroundImage.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, textSize.width, textSize.height);
    [self.contentView addSubview:self.interestNameLabel];
    //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, textSize.width+24, textSize.height);
}

@end
