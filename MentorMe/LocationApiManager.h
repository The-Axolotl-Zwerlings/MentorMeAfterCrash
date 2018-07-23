//
//  LocationApiManager.h
//  MentorMe
//
//  Created by Taylor Murray on 7/2/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationApiManager : NSObject
-(void)fetchDistanceWithOrigin:(NSString *)origin andEnd:(NSString *)end andCompletion:(void(^)(NSDictionary *elementDic,NSError *error))completion;
@end

