//
//  ComplimentsCell.m
//  MentorMe
//
//  Created by Taylor Murray on 8/2/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "ComplimentsCell.h"

/*Compliments Array
 0 - Great Convo
 1 - Down to Earth
 2 - Useful Advice
 3 - Friendly
 4 - Super Knowledgeable
 */

@implementation ComplimentsCell

-(void)formatCellReview:(NSNumber *)index andSelected:(NSNumber *)selected andDelegate:(id)delegate{
    NSArray *compliments = [NSArray arrayWithObjects:@"Great Conversation",@"Down to Earth",@"Useful Advice",@"Friendly",@"Super Knowledgeable", nil];
    NSArray *icons = [NSArray arrayWithObjects:@"bubbles3.png",@"earth.png",@"eye.png",@"grin.png",@"cool.png", nil];
    self.complimentLabel.text = [compliments objectAtIndex:[index integerValue]];
   
    [self.selectButton addTarget:self action:@selector(selectedCompliment) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectButton.layer.cornerRadius = 6;
    self.selectButton.clipsToBounds = YES;
    self.delegateAddCompliment = delegate;
    
    self.complimentIcon.image = [UIImage imageNamed:[icons objectAtIndex:[index integerValue]]];
}

-(void)formatCellWithIndex:(NSNumber *)index andCount:(NSNumber *)count{
    NSArray *compliments = [NSArray arrayWithObjects:@"Great Conversation",@"Down to Earth",@"Useful Advice",@"Friendly",@"Super Knowledgeable", nil];
    NSArray *icons = [NSArray arrayWithObjects:@"bubbles3.png",@"earth.png",@"eye.png",@"grin.png",@"cool.png", nil];
    self.complimentLabel.text = [compliments objectAtIndex:[index integerValue]];
    self.numOfTimesReceivedLabel.text = [NSString stringWithFormat: @"%@", count];
    self.complimentIcon.image = [UIImage imageNamed:[icons objectAtIndex:[index integerValue]]];
    
}

-(void)selectedCompliment{
    self.selectButton.selected = !self.selectButton.isSelected;
    NSIndexPath *indexPath = [(UICollectionView *)self.superview indexPathForCell:self];
    if(self.selectButton.isSelected){
        [self.delegateAddCompliment changeCompliment:[NSNumber numberWithInteger:indexPath.item] andSelectedStatus:[NSNumber numberWithBool:YES]];
    } else{
        [self.delegateAddCompliment changeCompliment:[NSNumber numberWithInteger:indexPath.item] andSelectedStatus:[NSNumber numberWithBool:NO]];
    }
}
@end
