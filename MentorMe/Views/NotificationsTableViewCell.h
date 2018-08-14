//
//  NotificationsTableViewCell.h
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 8/8/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;

@property (strong, nonatomic) NSString *notificationID;

@property (strong, nonatomic) NSString *senderString;
@property (strong, nonatomic) NSString *receiverString;

@property (strong, nonatomic) NSString *typeOfNotification;

- (void) loadCell;

@end
