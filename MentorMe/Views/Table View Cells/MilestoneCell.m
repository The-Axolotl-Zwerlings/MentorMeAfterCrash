//
//  MilestoneCell.m
//  MentorMe
//
//  Created by Taylor Murray on 8/2/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "MilestoneCell.h"

@implementation MilestoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

-(void)touched{
    
    if(self.doneButton.isSelected){
        self.doneButton.selected = NO;
        NSString* cutText = self.task.text;
        
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:cutText];
        
        // making text property to strike text- NSStrikethroughStyleAttributeName
        [titleString removeAttribute:NSStrikethroughStyleAttributeName range:NSMakeRange(0, [titleString length])];
        
        // using text on label
        
        [UIView animateWithDuration:.3 animations:^{
            [self.task  setAttributedText:titleString];
        }];
        
        
        
    } else{
        self.doneButton.selected = YES;
        
        NSString* cutText = self.task.text;
        
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:cutText];
        
        // making text property to strike text- NSStrikethroughStyleAttributeName
        [titleString addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [titleString length])];
        
        // using text on label
        [UIView animateWithDuration:.3 animations:^{
            [self.task  setAttributedText:titleString];
        }];
        
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setUpMilestone{
    
    self.task = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, self.contentView.frame.size.width-100, self.contentView.frame.size.height-12)];
    self.task.font = [UIFont fontWithName:@"Avenir" size:13];
    [self.contentView addSubview:self.task];
    
    
    
    self.doneButton = [[UIButton alloc]initWithFrame:CGRectMake( self.contentView.frame.size.width-80, 12, 16, 16)];
    UIImage *unchecked = [UIImage imageNamed:@"checkbox-unchecked.png"];
    UIImage *checked = [UIImage imageNamed:@"checkbox-checked.png"];
    [self.doneButton setImage:unchecked forState:UIControlStateNormal];
    [self.doneButton setImage:checked forState:UIControlStateSelected];
    
    [self.doneButton addTarget:self action:@selector(touched) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.doneButton];
    
 
}


@end
