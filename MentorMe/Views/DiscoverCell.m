//
//  DiscoverCell.m
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "DiscoverCell.h"
#import "PFUser+ExtendedUser.h"
#import "GetAdviceCollectionViewCell.h"
#import "GiveAdviceCollectionViewCell.h"

@implementation DiscoverCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutCell:(PFUser *)user{
    
    self.nameLabel.text = user.name;
    
    NSString *jobTitleAppend = user[@"jobTitle"];
    NSString *companyLabelAppend = user[@"company"];
    self.occupationLabel.text = [[jobTitleAppend stringByAppendingString:@" at "] stringByAppendingString:companyLabelAppend];
    NSString *majorLabelAppend = user[@"major"];
    NSString *schoolLabelAppend = user[@"school"];
    //self.educationLabel.text = [[[@"Studied " stringByAppendingString:majorLabelAppend] stringByAppendingString:@" at " ] stringByAppendingString: schoolLabelAppend];
    
    [self.educationLabel sizeToFit];
    
    self.profilePicView.file = user[@"profilePic"];
    [self.profilePicView loadInBackground];
    
    self.profilePicView.layer.masksToBounds = true;
    self.profilePicView.layer.borderWidth = 5;
    self.profilePicView.layer.borderColor = CGColorRetain(UIColor.whiteColor.CGColor);
    self.profilePicView.layer.cornerRadius = self.profilePicView.frame.size.width /2;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     if( [collectionView isEqual:self.getCollectionView] ){
         return self.getInterests.count;
     } else {
         return self.giveInterets.count;
     }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if( [collectionView isEqual:self.getCollectionView] ){
        
        GetAdviceCollectionViewCell *cellA = [collectionView dequeueReusableCellWithReuseIdentifier:@"GetAdviceCollectionViewCell" forIndexPath:indexPath];
        //cellA.interest = self.getInterests[indexPath.item];
        [cellA reloadInputViews];
        return cellA;
        
    } else {
        
        GiveAdviceCollectionViewCell *cellB = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiveAdviceCollectionViewCell" forIndexPath:indexPath];
         //cellB.interest = self.getInterests[indexPath.item];
        [cellB reloadInputViews];
        return cellB;
        
        
    }
    
}



@end
