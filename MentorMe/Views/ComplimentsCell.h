//
//  ComplimentsCell.h
//  MentorMe
//
//  Created by Taylor Murray on 8/2/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplimentsCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *complimentIcon;
@property (strong, nonatomic) IBOutlet UILabel *complimentLabel;


@property (strong, nonatomic) IBOutlet UILabel *numOfTimesReceivedLabel;



-(void)formatCellWithIndex:(NSNumber *)index andCount:(NSNumber *)count;
@end
