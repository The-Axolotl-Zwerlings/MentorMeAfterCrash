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

- (void) loadCell {
    
    //0. Background Color
    self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 351, 176)];
    self.backgroundImage.backgroundColor = [UIColor colorWithRed:0.49 green:0.83 blue:0.69 alpha:1.0];
    self.backgroundImage.layer.cornerRadius = 0;
    self.backgroundImage.layer.masksToBounds = NO;
    self.backgroundImage.layer.shadowColor = UIColor.grayColor.CGColor;
    self.backgroundImage.layer.shadowRadius = 3;
    self.backgroundImage.layer.shadowOffset = CGSizeMake(0, 5);
    self.backgroundImage.layer.shadowOpacity = 0.4;
    [self addSubview:self.backgroundImage];
    
    //1. Profile Image
    PFImageView *newImage = [[PFImageView alloc] initWithFrame:CGRectMake(12, 12, 100, 100)];
    newImage.file = self.userForCell.profilePic;
    [newImage loadInBackground];
    newImage.layer.borderColor = UIColor.whiteColor.CGColor;
    newImage.layer.borderWidth = 5;
    newImage.layer.cornerRadius = newImage.frame.size.width /2;
    newImage.layer.masksToBounds = YES;
    [self.backgroundImage addSubview:newImage];
    
    double textWidth = self.backgroundImage.frame.size.width - ( newImage.frame.origin.x + newImage.frame.size.width + newImage.frame.origin.x ) - newImage.frame.origin.x;
    
    //2. Name Label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 124, 12, textWidth, 40)];
    nameLabel.text = self.userForCell.name;
    nameLabel.textColor = [UIColor whiteColor];
    [self.backgroundImage addSubview:nameLabel];
    
    //3. Job Label
    NSString *jobLine = [[self.userForCell.jobTitle stringByAppendingString:@" at "] stringByAppendingString:self.userForCell.company];
    UILabel *jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(124, nameLabel.frame.size.height + nameLabel.frame.origin.y, textWidth, 40)];
    jobLabel.text = jobLine;
    jobLabel.textColor = [UIColor whiteColor];
    jobLabel.numberOfLines = 0;
    jobLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.backgroundImage addSubview:jobLabel];
    
    //4. Education Label
    NSString *educationLine = [[[@"Studied " stringByAppendingString:self.userForCell.major] stringByAppendingString:@" at "] stringByAppendingString:self.userForCell.school];
    UILabel *educationLabel = [[UILabel alloc] initWithFrame:CGRectMake(124, jobLabel.frame.size.height + jobLabel.frame.origin.y, textWidth, 40)];
    educationLabel.text = educationLine;
    educationLabel.textColor = [UIColor whiteColor];
    educationLabel.numberOfLines = 0;
    educationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.backgroundImage addSubview:educationLabel];
    
    //5. Auto Layout
    [nameLabel setFont:[UIFont fontWithName:@"Avenir" size:30]];
    [jobLabel setFont:[UIFont fontWithName:@"Avenir" size:17]];
    [educationLabel setFont:[UIFont fontWithName:@"Avenir" size:17]];
    //A. Find Frame
    CGRect frameA = nameLabel.frame;
    CGRect frameB = jobLabel.frame;
    CGRect frameC = educationLabel.frame;
    //B. Change Width
    CGFloat frameWidth = 227;
    frameA.size.width = frameWidth;
    frameB.size.width = frameWidth;
    frameC.size.width = frameWidth;
    //D. Change Height
    
    frameA.size.height = [self getLabelHeight:nameLabel];
    frameB.size.height = [self getLabelHeight:jobLabel];
    frameC.size.height = [self getLabelHeight:educationLabel];
    
    [nameLabel adjustsFontSizeToFitWidth];
    [jobLabel adjustsFontSizeToFitWidth];
    [educationLabel adjustsFontSizeToFitWidth];
    
    /*[nameLabel setBackgroundColor:UIColor.redColor];
    [jobLabel setBackgroundColor:UIColor.greenColor];
    [educationLabel setBackgroundColor:UIColor.blueColor];*/
    
    //B. Change Y-Coordinate
    frameA.origin.y = 12;
    frameB.origin.y = frameA.origin.y+frameA.size.height;
    frameC.origin.y = frameB.origin.y+frameB.size.height;
    
    [nameLabel setFrame:frameA];
    [jobLabel setFrame:frameB];
    [educationLabel setFrame:frameC];
    
    
    
}

- (CGFloat) getLabelHeight:(UILabel*) incomingLabel{
    NSInteger lineCount = 0;
    CGSize textSize = CGSizeMake(incomingLabel.frame.size.width, MAXFLOAT);
    long rHeight = lroundf([incomingLabel sizeThatFits:textSize].height);
    long charSize = lroundf(incomingLabel.font.lineHeight);
    lineCount = rHeight/charSize;
    CGFloat heightOfLabel = lineCount * charSize;
    NSLog(@"Height for %@ is: %f", incomingLabel.text, heightOfLabel);
    return heightOfLabel;
}

- (void) loadCollectionViews {
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //flowLayout.itemSize = CGSizeMake(120, 40);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.estimatedItemSize = CGSizeMake(120, 40);
    
    
    if( self.selectedIndex == 1 ) {
        collectionViewA = [[UICollectionView alloc]     initWithFrame:CGRectMake(12, 115, self.backgroundImage.frame.size.width - 24, 50)   collectionViewLayout:flowLayout];
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
        collectionViewB = [[UICollectionView alloc]     initWithFrame:CGRectMake(12, 115, self.backgroundImage.frame.size.width - 24, 50)   collectionViewLayout:flowLayout];
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





- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    if( [collectionView isEqual:collectionViewA] ){
        
        GetAdviceCollectionViewCell *cellA = [collectionView dequeueReusableCellWithReuseIdentifier:@"GetAdviceCollectionViewCell" forIndexPath:indexPath];
        cellA.interest = self.incomingGetInterests[indexPath.row];
        
        NSSet *mySet = [NSSet setWithObject:cellA.interest.subject];
        
        
        
        cellA.interestNameLabel.text = cellA.interest.subject;
        //[cellA.interestNameLabel sizeToFit];
        [cellA loadCollectionViewCell];
        
        if([mySet intersectsSet:self.giveSet]){
            cellA.backgroundImage.backgroundColor = [UIColor colorWithRed:.47 green:.38 blue:1.0 alpha:1.0];
        }
        return cellA;
        
    } else {
        
        
        
        GiveAdviceCollectionViewCell *cellB = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiveAdviceCollectionViewCell" forIndexPath:indexPath];
        cellB.interest = self.incomingGiveInterests[indexPath.row];
        NSSet *mySet = [NSSet setWithObject:cellB.interest.subject];
        //[cellB.interestNameLabel sizeToFit];
        [cellB loadCollectionViewCell];
        
        if([mySet intersectsSet:self.getSet]){
            cellB.backgroundImage.backgroundColor = [UIColor colorWithRed:.47 green:.38 blue:1.0 alpha:1.0];
        }
        
        return cellB;
    }
    
}

/*- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
 
 if( collectionView == collectionViewA ){
 InterestModel *newInterest = self.incomingGetInterests[indexPath.row];
 NSString *stringToFit = newInterest.subject;
 CGSize calculateSize =[stringToFit sizeWithAttributes:NULL];
 CGSize returnSize = CGSizeMake(calculateSize.width, 40);
 return returnSize;
 } else {
 InterestModel *newInterest = self.incomingGiveInterests[indexPath.row];
 NSString *stringToFit = newInterest.subject;
 CGSize calculateSize =[stringToFit sizeWithAttributes:NULL];
 CGSize returnSize = CGSizeMake(calculateSize.width, 40);
 return returnSize;
 }
 
 }*/

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if( self.selectedIndex == 1 ){
        return self.userForCell.getAdviceInterests.count;
    } else {
        return self.userForCell.giveAdviceInterests.count;
    }
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


@end
