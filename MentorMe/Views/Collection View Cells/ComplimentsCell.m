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
    NSArray *icons = [NSArray arrayWithObjects:@"bubbles3.png",@"earthB.png",@"eye.png",@"grin.png",@"cool.png", nil];
    self.complimentLabel.text = [compliments objectAtIndex:[index integerValue]];
   
    [self.selectButton addTarget:self action:@selector(selectedCompliment) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectButton.layer.cornerRadius = 6;
    self.selectButton.clipsToBounds = YES;
    self.delegateAddCompliment = delegate;
    
    self.complimentIcon.image = [UIImage imageNamed:[icons objectAtIndex:[index integerValue]]];
    self.contentView.layer.borderWidth = 5;
    self.contentView.layer.borderColor = [UIColor colorWithRed:0.19 green:0.69 blue:1.00 alpha:1.0].CGColor;
    self.contentView.layer.cornerRadius = 12;
    self.contentView.clipsToBounds = YES;
    if(self.selectButton != nil){
        self.selectButton.layer.borderColor = [UIColor blackColor].CGColor;
        self.selectButton.layer.borderWidth = 1;
    }
    
}

-(void)formatCellWithIndex:(NSNumber *)index andCount:(NSNumber *)count{
    NSArray *compliments = [NSArray arrayWithObjects:@"Great Conversation",@"Down to Earth",@"Useful Advice",@"Friendly",@"Super Knowledgeable", nil];
    NSArray *icons = [NSArray arrayWithObjects:@"bubbles3.png",@"earthB.png",@"eye.png",@"grin.png",@"cool.png", nil];
    self.complimentLabel.text = [compliments objectAtIndex:[index integerValue]];
    self.numOfTimesReceivedLabel.text = [NSString stringWithFormat: @"%@", count];
    self.cornerView.layer.cornerRadius = self.cornerView.frame.size.width/2;
    self.cornerView.clipsToBounds = YES;
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
