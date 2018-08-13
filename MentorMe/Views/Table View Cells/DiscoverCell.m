//
//  DiscoverCell.m
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "Parse/Parse.h"
#import "PFUser+ExtendedUser.h"
#import "QuartzCore/CALayer.h"
#import "DiscoverCell.h"
#import "AdviceCollectionViewCell.h"


@implementation DiscoverCell

- (id)initWithFrame:(CGRect)frame{
    if( self ){
        if( self.selectedIndex == 0 ){
            collectionViewA.hidden = NO;
            collectionViewB.hidden = YES;
        } else {
            collectionViewA.hidden = YES;
            collectionViewB.hidden = NO;
        }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
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

- (void) loadCell:(BOOL)incomingBool  {
    
    //0. Background Color
    self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 351, 200)];
    [self.backgroundImage setBackgroundColor:[UIColor colorWithRed:0.49 green:0.83 blue:0.69 alpha:1.0]];
    [self.backgroundImage.layer setCornerRadius:0];
    [self.backgroundImage.layer setMasksToBounds:NO];
    [self.backgroundImage.layer setShadowColor: UIColor.grayColor.CGColor];
    [self.backgroundImage.layer setShadowRadius:3];
    [self.backgroundImage.layer setShadowOpacity:0.4];
    [self.backgroundImage.layer setShadowOffset:CGSizeMake(0, 5)];
    [self addSubview:self.backgroundImage];
    
    //1. Profile Image
    self.profilePicture = [[PFImageView alloc] initWithFrame:CGRectMake(12, 12, 100, 100)];
    [self.profilePicture setFile:self.userForCell.profilePic];
    if( incomingBool ){
        [self.profilePicture loadInBackground];
    }
    [self.profilePicture.layer setBorderColor:UIColor.whiteColor.CGColor];
    [self.profilePicture.layer setBorderWidth:5];
    [self.profilePicture.layer setCornerRadius: self.profilePicture.frame.size.width/2];
    [self.profilePicture.layer setMasksToBounds:YES];
    [self.backgroundImage addSubview:self.profilePicture];
    
    double textWidth = self.backgroundImage.frame.size.width - ( self.profilePicture.frame.origin.x + self.profilePicture.frame.size.width + self.profilePicture.frame.origin.x ) - self.profilePicture.frame.origin.x;
    
    
    
    //2. Name Label
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 124, 12, textWidth, 90)];
    
    [self.nameLabel setFont:[UIFont fontWithName:@"Avenir" size:25]];
    [self.nameLabel setText:self.userForCell.name];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    
    [self.nameLabel setNumberOfLines:0];
    [self.nameLabel adjustsFontSizeToFitWidth];
    [self.nameLabel setLineBreakMode:NSLineBreakByClipping];
    [self.nameLabel sizeToFit];
    [self.backgroundImage addSubview:self.nameLabel];
    
    
    
    //3. Job Label
    NSString *jobLine = [[self.userForCell.jobTitle stringByAppendingString:@" at "] stringByAppendingString:self.userForCell.company];
    self.jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(124, self.nameLabel.frame.size.height + self.nameLabel.frame.origin.y, textWidth, 40)];
    
    [self.jobLabel setFont:[UIFont fontWithName:@"Avenir" size:17]];
    [self.jobLabel setText:jobLine];
    [self.jobLabel setTextColor:[UIColor whiteColor]];
    
    [self.jobLabel setNumberOfLines:0];
    [self.jobLabel adjustsFontSizeToFitWidth];
    [self.jobLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.jobLabel sizeToFit];
    [self.backgroundImage addSubview:self.jobLabel];
    
    
    
    //4. Education Label
    NSString *educationLine = [[[@"Studied " stringByAppendingString:self.userForCell.major] stringByAppendingString:@" at "] stringByAppendingString:self.userForCell.school];
    self.educationLabel = [[UILabel alloc] initWithFrame:CGRectMake(124, self.jobLabel.frame.size.height + self.jobLabel.frame.origin.y, textWidth, 40)];
    
    [self.educationLabel setFont:[UIFont fontWithName:@"Avenir" size:17]];
    [self.educationLabel setText:educationLine];
    [self.educationLabel setTextColor:[UIColor whiteColor]];
    
    [self.educationLabel setNumberOfLines:0];
    [self.educationLabel adjustsFontSizeToFitWidth];
    [self.educationLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.educationLabel sizeToFit];
    [self.backgroundImage addSubview:self.educationLabel];
    
    
}


- (void) loadCollectionViews {
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(120, 50);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
    
    
    
    CGFloat yPositionOfCollectionViews = MAX(self.profilePicture.frame.origin.y + self.profilePicture.frame.size.height + 12, self.educationLabel.frame.origin.y + self.educationLabel.frame.size.height + 12);

    
    
    if( self.selectedIndex == 1 ) {
        collectionViewA = [[UICollectionView alloc]     initWithFrame:CGRectMake(0, yPositionOfCollectionViews, self.backgroundImage.frame.size.width, 30)   collectionViewLayout:flowLayout];
        [collectionViewA registerClass:[GetAdviceCollectionViewCell class] forCellWithReuseIdentifier:@"GetAdviceCollectionViewCell"];
        collectionViewA.delegate = self;
        collectionViewA.dataSource = self;
        collectionViewA.backgroundColor = [UIColor clearColor];
        collectionViewA.showsHorizontalScrollIndicator = NO;
        collectionViewA.alwaysBounceHorizontal = YES;
        [self.backgroundImage addSubview:collectionViewA];
        [collectionViewA reloadData];
    }
    
    if( self.selectedIndex == 0 ){
        collectionViewB = [[UICollectionView alloc]     initWithFrame:CGRectMake(0, yPositionOfCollectionViews, self.backgroundImage.frame.size.width, 30)   collectionViewLayout:flowLayout];
        [collectionViewB registerClass:[GiveAdviceCollectionViewCell class] forCellWithReuseIdentifier:@"GiveAdviceCollectionViewCell"];
        collectionViewB.delegate = self;
        collectionViewB.dataSource = self;
        collectionViewB.backgroundColor = [UIColor clearColor];
        collectionViewB.showsHorizontalScrollIndicator = NO;
        collectionViewB.alwaysBounceHorizontal = YES;
        [self.backgroundImage addSubview:collectionViewB];
        [collectionViewB reloadData];
    }
    
    
}


/**** COLLECTION VIEW DELEGATE METHODS *****/


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    if( [collectionView isEqual:collectionViewA] ){
        
        GetAdviceCollectionViewCell *cellA = [collectionView dequeueReusableCellWithReuseIdentifier:@"GetAdviceCollectionViewCell" forIndexPath:indexPath];
        cellA.interest = self.incomingGetInterests[indexPath.row];
        [cellA loadCollectionViewCell];
        [cellA layoutInterests];
        NSSet *mySet = [NSSet setWithObject:cellA.interest.subject];
        if([mySet intersectsSet:self.giveSet]){
            cellA.backgroundIMage.backgroundColor = [UIColor colorWithRed:.47 green:.38 blue:1.0 alpha:1.0];
        }
        return cellA;
        
    } else {
        
        GiveAdviceCollectionViewCell *cellB = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiveAdviceCollectionViewCell" forIndexPath:indexPath];
        cellB.interest = self.incomingGiveInterests[indexPath.row];
        [cellB loadCollectionViewCell];
        [cellB layoutInterests];
        NSSet *mySet = [NSSet setWithObject:cellB.interest.subject];
        if([mySet intersectsSet:self.getSet]){
            cellB.backgroundIMage.backgroundColor = [UIColor colorWithRed:.47 green:.38 blue:1.0 alpha:1.0];
        }
        return cellB;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    InterestModel *modelA;
    if( [collectionView isEqual: collectionViewA] ){
        modelA = self.incomingGetInterests[indexPath.row];
    } else {
        modelA = self.incomingGiveInterests[indexPath.row];
    }
    
    NSString *testString = modelA.subject;
    
    CGSize textSize = [testString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:17.0f]}];
    textSize.height += 8;
    textSize.width += 24;
    return textSize;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger *numberToReturn = 0;
    if( self.selectedIndex == 1 ){
        numberToReturn =  self.userForCell.getAdviceInterests.count;
    } else {
        numberToReturn =  self.userForCell.giveAdviceInterests.count;
    }
    
    return MIN(numberToReturn, 3);
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


@end
