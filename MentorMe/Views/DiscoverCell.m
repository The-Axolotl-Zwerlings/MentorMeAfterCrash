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

@interface DiscoverCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation DiscoverCell


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;

    self.getCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.getCollectionView.dataSource = self;
    self.getCollectionView.delegate = self;
    
    self.giveCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.giveCollectionView.dataSource = self;
    self.giveCollectionView.delegate = self;
    
    
    self.giveInterets = self.userForCell.giveAdviceInterests;
    self.getInterests = self.userForCell.getAdviceInterests;

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
    self.educationLabel.text = [[[@"Studied " stringByAppendingString:majorLabelAppend] stringByAppendingString:@" at " ] stringByAppendingString: schoolLabelAppend];
    
    
    self.profilePicView.file = user[@"profilePic"];
    [self.profilePicView loadInBackground];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if( collectionView == self.getCollectionView){
        return self.getInterests.count;
    } else {
        return self.giveInterets.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [collectionView isEqual:self.getCollectionView] ){
        GetAdviceCollectionViewCell *cellA = [collectionView dequeueReusableCellWithReuseIdentifier:@"GetAdviceCollectionViewCell" forIndexPath:indexPath];
        cellA.interestNameLabel.text = self.getInterests[indexPath.item];
        return cellA;
        
    } else {
        GiveAdviceCollectionViewCell *cellB = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiveAdviceCollectionViewCell" forIndexPath:indexPath];
        cellB.interestNameLabel.text = self.giveInterets[indexPath.item];
        
        return cellB;
    }
}


@end
