//
//  ElevatorDelegate.h
//  EducationUI2
//
//  Created by Sergey Nikolsky on 30.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ElevatorDelegate <NSObject>

@optional
- (void) elevatorWillOpenDoors;
- (void) elevatorWillCloseDoors;
- (void) elevatorDidOpenDoors;
- (void) elevatorDidCloseDoors;
- (void) elevatorWillMoveToTheFloor:(unsigned)floor;
- (void) elevatorDidMoveToTheFloor:(unsigned)floor;

//for FloorButtonPanels
- (void) elevatorWillDropUpButtonOnFloor:(unsigned)floor;
- (void) elevatorWillDropDownButtonOnFloor:(unsigned)floor;

@end
