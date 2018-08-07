//
//  AddCell.m
//  MentorMe
//
//  Created by Taylor Murray on 8/2/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "AddCell.h"

@implementation AddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setUpAdd{
    self.addButton = [[UIButton alloc]initWithFrame:CGRectMake(12, 12, 16, 16)];
    [self.addButton setTitle:@"+" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.addButton addTarget:self action:@selector(touched) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.addButton];
    
    self.addTextField = [[UITextField alloc]initWithFrame:CGRectMake(40,12, self.contentView.frame.size.width-55, self.contentView.frame.size.height-12)];
    [self.addTextField setPlaceholder:@"Add something..."];
    [self.contentView addSubview:self.addTextField];
}


-(void)touched{
    [self.delegate addedTask:self.addTextField.text];
    self.addTextField.text = @"";
}
@end
