//
//  ComplimentsCell.h
//  MentorMe
//
//  Created by Taylor Murray on 8/2/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCompliment
-(void)changeCompliment:(NSNumber *)index andSelectedStatus:(NSNumber *)selected;
@end
@interface ComplimentsCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *cornerView;
@property (strong, nonatomic) id<AddCompliment> delegateAddCompliment;
@property (strong, nonatomic) IBOutlet UIImageView *complimentIcon;
@property (strong, nonatomic) IBOutlet UILabel *complimentLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;


@property (strong, nonatomic) IBOutlet UILabel *numOfTimesReceivedLabel;

-(void)formatCellReview:(NSNumber *)index andSelected:(NSNumber *)selected andDelegate:(id)delegate;

-(void)formatCellWithIndex:(NSNumber *)index andCount:(NSNumber *)count;
@end
