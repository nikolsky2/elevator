//
//  PersonDelegate.h
//  EducationUI2
//
//  Created by Sergey Nikolsky on 15.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PersonDelegate <NSObject>

@optional
- (void) personWillPushUpButtonOnFloor:(unsigned)floor;
- (void) personWillPushDownButtonOnFloor:(unsigned)floor;

@end
