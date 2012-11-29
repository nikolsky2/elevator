//
//  Person.h
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


// You often have to decide whether to make an instance variable mutable or immutable.
// If you have any doubts about whether an object is, or should be, mutable, go with immutable.

// Person should be immutable immutable object

#import <Foundation/Foundation.h>

@class Building;
@class Elevator;

@interface Person : NSObject <NSCopying> {

@private
    //ARC
    id __weak delegate;
    
    unsigned initialFloor;
    unsigned desiredFloor;    
    unsigned weight;
    
    //BOOL isInTheElevator;
    //NSDate *initTime;
    
    // since initialisation initTime to [Elevator getIn:person] 
    NSTimeInterval waitingTimeOnTheFloor;
    
    // since [Elevator getIn:person] to [Elevator getOut:person]
    NSTimeInterval waitingTimeInTheElevator;
    
    Building __weak *building;
    
}

@property (nonatomic, readonly) unsigned initialFloor, desiredFloor, weight;
@property (nonatomic, assign) NSTimeInterval waitingTimeOnTheFloor, waitingTimeInTheElevator;
@property (readonly) unsigned currentDirection;

- (id) initWithInitialFloor:(unsigned)initialFloor AndDesiredFloor:(unsigned)desiredFloor AndWeight:(unsigned)weight;

- (void) pushFloorButton;
- (void) pushElevatorButton:(Elevator *)elevator;


// Declare the delegate accessor methods in your class header file
//- (id)delegate;
//- (void)setDelegate:(id)newDelegate;
@property (nonatomic, weak) id delegate;


@end
