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



- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    UIColor* const COLOR_A = [UIColor colorWithRed:0.22 green:0.97 blue:0.66 alpha:1.0]; //BACKGROUND
    UIColor* const COLOR_B = [UIColor blackColor]; // TEXT+ BORDER

    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if( self ){
        NSLog(@"Loading cell");
        //0. Background Color
        self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 351, 200)];
        [self.backgroundImage setBackgroundColor:COLOR_A];
        [self.backgroundImage.layer setCornerRadius:10];
        [self.backgroundImage.layer setMasksToBounds:NO];
        [self.backgroundImage.layer setShadowColor: COLOR_A.CGColor];
        [self.backgroundImage.layer setShadowRadius:3];
        [self.backgroundImage.layer setShadowOpacity:0.4];
        [self.backgroundImage.layer setShadowOffset:CGSizeMake(0, 5)];
        
        
        
        [self addSubview:self.backgroundImage];
        
        //1. Profile Image
        self.profilePicture = [[PFImageView alloc] initWithFrame:CGRectMake(12, 12, 100, 100)];
        [self.profilePicture.layer setBorderColor:[UIColor colorWithRed:0.19 green:0.69 blue:1.00 alpha:1.0].CGColor];
        [self.profilePicture.layer setBorderWidth:5];
        [self.profilePicture.layer setCornerRadius: self.profilePicture.frame.size.width/2];
        [self.profilePicture.layer setMasksToBounds:YES];
        [self.backgroundImage addSubview:self.profilePicture];
        
        double textWidth = self.backgroundImage.frame.size.width - ( self.profilePicture.frame.origin.x + self.profilePicture.frame.size.width + self.profilePicture.frame.origin.x ) - self.profilePicture.frame.origin.x;
        
        
        //2. Name Label
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 124, 12, textWidth, 90)];
        [self.nameLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:25]];
        [self.nameLabel setTextColor:COLOR_B];
        [self.nameLabel setNumberOfLines:0];
        [self.nameLabel adjustsFontSizeToFitWidth];
        [self.nameLabel setLineBreakMode:NSLineBreakByClipping];
        
        
        [self.backgroundImage addSubview:self.nameLabel];
        
        
        
        //3. Job Label
        
        self.jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(124, self.nameLabel.frame.size.height + self.nameLabel.frame.origin.y, textWidth, 40)];
        
        [self.jobLabel setFont:[UIFont fontWithName:@"Avenir" size:17]];
        [self.jobLabel setTextColor:COLOR_B];
        [self.jobLabel setNumberOfLines:2];
        [self.jobLabel adjustsFontSizeToFitWidth];
        [self.jobLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        
        [self.backgroundImage addSubview:self.jobLabel];
        
        
        
        //4. Education Label
        self.educationLabel = [[UILabel alloc] initWithFrame:CGRectMake(124, self.jobLabel.frame.size.height + self.jobLabel.frame.origin.y, textWidth, 40)];
        [self.educationLabel setFont:[UIFont fontWithName:@"Avenir" size:17]];
        [self.educationLabel setTextColor:COLOR_B];
        [self.educationLabel setNumberOfLines:2];
        [self.educationLabel adjustsFontSizeToFitWidth];
        [self.educationLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        
        
        [self.backgroundImage addSubview:self.educationLabel];
        
        
        
        
        UICollectionViewFlowLayout* flowLayoutA = [[UICollectionViewFlowLayout alloc] init];
        flowLayoutA.itemSize = CGSizeMake(120, 50);
        [flowLayoutA setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayoutA.minimumInteritemSpacing = 10;
        flowLayoutA.minimumLineSpacing = 0;
        flowLayoutA.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        
        
        
        CGFloat yPositionOfCollectionViews = MAX(self.profilePicture.frame.origin.y + self.profilePicture.frame.size.height + 12, self.educationLabel.frame.origin.y + self.educationLabel.frame.size.height + 12);
        
        
        
        
        collectionViewA = [[UICollectionView alloc]     initWithFrame:CGRectMake(0, yPositionOfCollectionViews, self.backgroundImage.frame.size.width, 30)   collectionViewLayout:flowLayoutA];
        [collectionViewA registerClass:[GetAdviceCollectionViewCell class] forCellWithReuseIdentifier:@"GetAdviceCollectionViewCell"];
        collectionViewA.delegate = self;
        collectionViewA.dataSource = self;
        collectionViewA.backgroundColor = [UIColor clearColor];
        collectionViewA.showsHorizontalScrollIndicator = NO;
        collectionViewA.alwaysBounceHorizontal = YES;
        [self.backgroundImage addSubview:collectionViewA];
        
        
        UICollectionViewFlowLayout* flowLayoutB = [[UICollectionViewFlowLayout alloc] init];
        flowLayoutB.itemSize = CGSizeMake(120, 50);
        [flowLayoutB setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayoutB.minimumInteritemSpacing = 10;
        flowLayoutB.minimumLineSpacing = 0;
        flowLayoutB.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        
        collectionViewB = [[UICollectionView alloc]     initWithFrame:CGRectMake(0, yPositionOfCollectionViews, self.backgroundImage.frame.size.width, 30)   collectionViewLayout:flowLayoutB];
        [collectionViewB registerClass:[GetAdviceCollectionViewCell class] forCellWithReuseIdentifier:@"GetAdviceCollectionViewCell"];
        collectionViewB.delegate = self;
        collectionViewB.dataSource = self;
        collectionViewB.backgroundColor = [UIColor clearColor];
        collectionViewB.showsHorizontalScrollIndicator = NO;
        collectionViewB.alwaysBounceHorizontal = YES;
        [self.backgroundImage addSubview:collectionViewB];
        
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

- (void) loadCell{
    [self.profilePicture setFile:self.userForCell.profilePic];
    [self.profilePicture loadInBackground];
    [self.nameLabel setText:self.userForCell.name];
    NSString *jobLine = [[self.userForCell.jobTitle stringByAppendingString:@" at "] stringByAppendingString:self.userForCell.company];
    [self.jobLabel setText:jobLine];
    NSString *educationLine = [[[@"Studied " stringByAppendingString:self.userForCell.major] stringByAppendingString:@" at "] stringByAppendingString:self.userForCell.school];
    [self.educationLabel setText:educationLine];
    
    
    
    [self.nameLabel setFrame:CGRectMake(124, 12, 215, 40)];
    [self.nameLabel sizeToFit];
    [self.jobLabel setFrame:CGRectMake(124, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height, 215, 40)];
    [self.jobLabel sizeToFit];
    [self.educationLabel setFrame:CGRectMake(124, self.jobLabel.frame.origin.y + self.jobLabel.frame.size.height, 215, 40)];
    [self.educationLabel sizeToFit];
    
    CGFloat yPositionOfCollectionViews = MAX(self.profilePicture.frame.origin.y + self.profilePicture.frame.size.height + 12, self.educationLabel.frame.origin.y + self.educationLabel.frame.size.height + 12);
    
    [collectionViewA setFrame:CGRectMake(0, yPositionOfCollectionViews, 351, 50)];
    [collectionViewB setFrame:CGRectMake(0, yPositionOfCollectionViews, 351, 50)];
    
    
    [collectionViewA reloadData];
    [collectionViewB reloadData];
    
    if( self.selectedIndex == 0 ){
        collectionViewA.hidden = YES;
        collectionViewB.hidden = NO;
    } else {
        collectionViewA.hidden = NO;
        collectionViewB.hidden = YES;
    }
}


/**** COLLECTION VIEW DELEGATE METHODS *****/


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GetAdviceCollectionViewCell *cellA = [collectionView dequeueReusableCellWithReuseIdentifier:@"GetAdviceCollectionViewCell" forIndexPath:indexPath];
    UIColor *COLOR_C = [UIColor colorWithRed:0.47 green:0.38 blue:1.0 alpha:1.0]; // SELECTED CELL COLOR

    if( [collectionView isEqual:collectionViewA] ){
        cellA.interest = self.incomingGetInterests[indexPath.row];
        [cellA layoutInterests];
        NSSet *mySet = [NSSet setWithObject:cellA.interest.subject];
        if([mySet intersectsSet:self.giveSet]){
            cellA.backgroundIMage.backgroundColor = COLOR_C;
            NSLog(@"MATCH!");
        }
    } else {
        cellA.interest = self.incomingGiveInterests[indexPath.row];
        [cellA layoutInterests];
        NSSet *mySet = [NSSet setWithObject:cellA.interest.subject];
        if([mySet intersectsSet:self.getSet]){
            cellA.backgroundIMage.backgroundColor = COLOR_C;
            NSLog(@"MATCH!");
        }
    }
    
    
    return cellA;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    InterestModel *modelA;
    if( [collectionView isEqual: collectionViewB] ){
        modelA = self.incomingGiveInterests[indexPath.row];
    } else {
        modelA = self.incomingGetInterests[indexPath.row];
    }
    
    NSString *testString = modelA.subject;
    
    CGSize textSize = [testString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:17.0f]}];
    textSize.height += 8;
    textSize.width += 24;
    return textSize;
}

- (NSInteger*)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger *numberToReturn;
    if( collectionView == collectionViewB ){
        numberToReturn =  self.userForCell.giveAdviceInterests.count;
        
    } else {
        numberToReturn =  self.userForCell.getAdviceInterests.count;
    }
    return (MIN(2, numberToReturn));
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


@end
