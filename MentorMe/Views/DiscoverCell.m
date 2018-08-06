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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor *backgroundColor = self.backgroundImage.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.backgroundImage.backgroundColor = backgroundColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor *backgroundColor = self.backgroundImage.backgroundColor;
    [super setSelected:selected animated:animated];
    self.backgroundImage.backgroundColor = backgroundColor;
}
- (void)layoutCell:(PFUser *)user{
    
    self.nameLabel.text = user.name;
    
    
    NSString *jobTitleAppend = user[@"jobTitle"];
    NSString *companyLabelAppend = user[@"company"];
    self.occupationLabel.text = [[jobTitleAppend stringByAppendingString:@" at "] stringByAppendingString:companyLabelAppend];
    NSString *majorLabelAppend = user[@"major"];
    NSString *schoolLabelAppend = user[@"school"];
    self.educationLabel.text = [[[@"Studied " stringByAppendingString:majorLabelAppend] stringByAppendingString:@" at " ] stringByAppendingString: schoolLabelAppend];
    
    [self.educationLabel sizeToFit];
    
    self.profilePicView.file = user[@"profilePic"];
    [self.profilePicView loadInBackground];
    
    //self.backgroundColor = [UIColor colorWithRed:1.00 green:0.51 blue:0.38 alpha:0.7];
    
    self.backgroundImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundImage.layer.shadowOffset = CGSizeMake(5, 5);
    self.backgroundImage.layer.shadowOpacity = 0.4;
    self.backgroundImage.layer.shadowRadius = 3.0;
    self.backgroundImage.clipsToBounds = NO;
        
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
         return self.giveInterests.count;
     }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if( [collectionView isEqual:self.getCollectionView] ){
        
        GetAdviceCollectionViewCell *cellA = [collectionView dequeueReusableCellWithReuseIdentifier:@"GetAdviceCollectionViewCell" forIndexPath:indexPath];
        cellA.interest = self.getInterests[indexPath.item];
        [cellA reloadInputViews];
        
        return cellA;
        
    } else {
        
        GiveAdviceCollectionViewCell *cellB = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiveAdviceCollectionViewCell" forIndexPath:indexPath];
        cellB.interest = ((InterestModel *)self.giveInterests[indexPath.item]);
        [cellB reloadInputViews];
        return cellB;
        
        
    }
    
}



@end
