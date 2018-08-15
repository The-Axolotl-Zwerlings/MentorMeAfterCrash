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

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundIMage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width - 8, self.contentView.frame.size.height-4)];
        [self.contentView addSubview:self.backgroundIMage];
        
        
        self.interestNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        [self.contentView addSubview:self.interestNameLabel];
        
        self.interestNameLabel.textColor = [UIColor blackColor];
        
        self.interestNameLabel.font = [UIFont fontWithName:@"Avenir" size:17.0f];
        self.interestNameLabel.textAlignment = NSTextAlignmentLeft;
        self.interestNameLabel.numberOfLines = 0;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{
    UIColor *backgroundColor = self.backgroundIMage.backgroundColor;
    [super setHighlighted:highlighted];
    self.backgroundIMage.backgroundColor = backgroundColor;
}

- (void) setSelected:(BOOL)selected {
    UIColor *backgroundColor = self.backgroundIMage.backgroundColor;
    [super setSelected:selected];
    self.backgroundIMage.backgroundColor = backgroundColor;
}


-(void)layoutInterestsStory{
    
    
    self.interestNameLabelStory.text = [@"#" stringByAppendingString: self.interest.subject];
    //2. Adjust Cell Origin and Height
    CGRect frameA = self.frame;
    frameA.origin.y = 0;
    frameA.size.height = 40;
    self.frame = frameA;
    
    //3. Adjust Background Image
    CGRect frameB = self.backgroundImageStory.frame;
    frameB.size.width = self.frame.size.width;
    frameB.origin.y = 0;
    self.backgroundImageStory.frame = frameB;
    self.backgroundImageStory.layer.borderColor = UIColor.blackColor.CGColor;
    self.backgroundImageStory.layer.borderWidth = 2;
    self.backgroundImageStory.layer.cornerRadius = self.backgroundImageStory.frame.size.height/2;
    self.backgroundImageStory.layer.masksToBounds = YES;
    
    //4. Adjust Text Label
    CGRect frameC = self.interestNameLabelStory.frame;
    frameC.origin.y = 8;
    frameC.origin.x = 0;
    frameC.size.width = self.frame.size.width;
    self.interestNameLabelStory.frame = frameC;
    self.interestNameLabelStory.textAlignment = NSTextAlignmentCenter;
    
    self.backgroundImageStory.backgroundColor = [UIColor clearColor];
}
- (void) layoutInterests{
    self.interestNameLabel.text = [@"#" stringByAppendingString: self.interest.subject];
    //2. Adjust Cell Origin and Height
    CGRect frameA = self.frame;
    frameA.origin.y = 0;
    frameA.size.height = 36;
    self.frame = frameA;
    
    //3. Adjust Background Image
    CGRect frameB = self.backgroundIMage.frame;
    frameB.size.width = self.frame.size.width;
    frameB.origin.y = 0;
    self.backgroundIMage.frame = frameB;
    self.backgroundIMage.layer.borderColor = UIColor.blackColor.CGColor;
    self.backgroundIMage.layer.borderWidth = 2;
    self.backgroundIMage.layer.cornerRadius = self.backgroundIMage.frame.size.height/2;
    self.backgroundIMage.layer.masksToBounds = YES;

    //4. Adjust Text Label
    CGRect frameC = self.interestNameLabel.frame;
    frameC.origin.y = -2;
    frameC.size.width = self.frame.size.width;
    self.interestNameLabel.frame = frameC;
    self.interestNameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.backgroundIMage.backgroundColor = [UIColor clearColor];
}


@end
