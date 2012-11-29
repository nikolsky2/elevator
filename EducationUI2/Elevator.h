//
//  Elevator.h
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;
@class ElevatorButtonsPanel;

@interface Elevator : NSObject {
@private
    id delegate;
    
    BOOL isTurned;
    BOOL isInUse;
    BOOL areDoorsOpened;
    
    unsigned maxWeight;
    unsigned currentFloor;
    unsigned destination;
    
    unsigned currentDirection;
        
    NSMutableSet *peopleInside;
    ElevatorButtonsPanel *buttonPanel;
}

@property (nonatomic) NSMutableSet *peopleInside;
@property (nonatomic, readonly) ElevatorButtonsPanel *buttonPanel;

@property (readonly) BOOL isOverload, areDoorsOpened;
@property (readonly) unsigned currentFloor;

//readwrite
@property unsigned currentDirection, destination;

#pragma mark -
#pragma mark Actions from BuildingElevatorsController

//actions from BuildingElevatorsController
- (BOOL) moveToTheFloor:(unsigned)floor;
- (void) openDoors;
- (BOOL) closeDoors;

#pragma mark -
#pragma mark Actions from Person

// actions from Person
- (void) pressFloorButton:(unsigned)desiredFloor;

// Declare the delegate accessor methods in your class header file
- (id)delegate;
- (void)setDelegate:(id)newDelegate;

@end
