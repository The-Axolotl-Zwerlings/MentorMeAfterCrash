//
//  MilestoneCell.h
//  MentorMe
//
//  Created by Taylor Murray on 8/2/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FinishedDeleagte
-(void)finishedTask:(UITableView *)tableView andPath:(NSIndexPath *)indexPath;
@end
@interface MilestoneCell : UITableViewCell
@property (strong, nonatomic) id<FinishedDeleagte> delegate;
@property (strong, nonatomic) UILabel *task;
@property (strong, nonatomic) UIButton *doneButton;

-(void)setUpMilestone;
@end
