//
//  AddCell.h
//  MentorMe
//
//  Created by Taylor Murray on 8/2/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddDelegate
-(void)addedTask:(NSString *)taskText;
@end
@interface AddCell : UITableViewCell

@property (strong, nonatomic) UITextField *addTextField;
@property (strong, nonatomic) UIButton *addButton;

@property (strong, nonatomic) id<AddDelegate> delegate;

-(void)setUpAdd;
@end

