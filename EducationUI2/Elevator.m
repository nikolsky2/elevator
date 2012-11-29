//
//  Elevator.m
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Elevator.h"
#import "ElevatorButtonsPanel.h"
#import "Person.h"
#import "Building.h"
#import "FloorButtonPanel.h"
#import "FloorButton.h"
#import "Defines.h"

//protocol
#import "ElevatorDelegate.h"

@interface Elevator()
// These are private methods that outside classes need not use

-(unsigned) totalWeightOfPeopleInside;
@end


@implementation Elevator

@synthesize peopleInside;
@synthesize buttonPanel;
@synthesize currentFloor;

//readwrite
@synthesize currentDirection, destination;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        isTurned            = YES;
        isInUse             = YES;
        areDoorsOpened      = NO;
        maxWeight           = 1000;
        currentFloor        = 0;
        destination         = 0;
        currentDirection    = UP;

        buttonPanel = [[ElevatorButtonsPanel alloc] init];
        peopleInside = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (BOOL) isOverload
{
    return ([self totalWeightOfPeopleInside] > maxWeight);
}
@synthesize areDoorsOpened;

#pragma mark -
#pragma mark Actions from Person
////////////////////////////////////////////////////////////////////////////////////////
- (void) pressFloorButton:(unsigned)desiredFloor;
{
    FloorButton *floorButton = [buttonPanel.buttons objectAtIndex:desiredFloor];
    [floorButton press];
    
}

////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (BOOL) moveToTheFloor:(unsigned)floor
{
    //check for FLOORS_NUMBER
    if (floor>=FLOORS_NUMBER) {
        return NO;
    }
    
    if (floor == currentFloor) 
        return NO;
    
    // close doors
    if([self areDoorsOpened]) {
        if (! [self closeDoors]) 
            return NO;
    }
    
    // Notify a delegate object
    if ( [delegate respondsToSelector:@selector(elevatorWillMoveToTheFloor:)] ) {
        [delegate elevatorWillMoveToTheFloor:floor];
    }
    
    
    //actual elevator motion
    if (floor > currentFloor)
        for (int i=currentFloor+1; i<=(int)floor; i++) {
#ifdef DEBUG_ELEVATOR
            NSLog(@"Elevator MOVED upward to %i floor", i);
#endif

            currentFloor = i;
            
            //1micro sec = 10e-6
            usleep(ELEVATOR_TIME_TO_PASS_ONE_FLOOR);
        }
    else
        for (int i=currentFloor-1; i>=(int)floor; i--) {
#ifdef DEBUG_ELEVATOR
            NSLog(@"Elevator MOVED dwnwrd to %i floor", i);
#endif
            currentFloor = i;
            
            usleep(ELEVATOR_TIME_TO_PASS_ONE_FLOOR);
        }
    
    
    // Notify a delegate object
    if ( [delegate respondsToSelector:@selector(elevatorDidMoveToTheFloor:)] ) {
        [delegate elevatorDidMoveToTheFloor:floor];
    }
    
    
    return YES;
}

- (void) openDoors 
{
    if (!areDoorsOpened) {
        // Notify a delegate object
        if ( [delegate respondsToSelector:@selector(elevatorWillOpenDoors)] ) {
            [delegate elevatorWillOpenDoors]; 
        }
        
        
        // Than TURN OFF floorButtonPanels
        FloorButtonPanel *floorButtonPanel = [[[Building sharedBuilding] floorButtonPanels] objectAtIndex:currentFloor];    
        if (currentDirection == UP) {
            if ([delegate respondsToSelector:@selector(elevatorWillDropUpButtonOnFloor:)])
                [delegate elevatorWillDropUpButtonOnFloor:currentFloor];
            
            [floorButtonPanel dropUpButton];
        }
        if (currentDirection == DOWN) {
            if ([delegate respondsToSelector:@selector(elevatorWillDropDownButtonOnFloor:)])
                [delegate elevatorWillDropDownButtonOnFloor:currentFloor];
            
            [floorButtonPanel dropDownButton];
        }
        /////////////////////////////////////////////////////////////////
        
        usleep(ELEVATOR_TIME_TO_OPEN_THE_DOORS);
        
        //drop elevator button
        [[[buttonPanel buttons] objectAtIndex:currentFloor] drop];
#ifdef DEBUG_ELEVATOR        
        NSLog(@"Elevator OPENED doors on %u floor", currentFloor);
#endif
        areDoorsOpened  = YES;
        
        // Notify a delegate object
        if ( [delegate respondsToSelector:@selector(elevatorDidOpenDoors)] ) {
            [delegate elevatorDidOpenDoors];    
        }
        ///////////////////////////////////////////////////////////////////////////////
    }
    
}
- (BOOL) closeDoors 
{
    if (!areDoorsOpened) {
        return NO;
    }
    
    if ([self isOverload]) { 
#ifdef DEBUG_ELEVATOR        
        NSLog(@"Elevator is OVERLOADED");
#endif
        return NO;
    }
    // Notify a delegate object
    if ( [delegate respondsToSelector:@selector(elevatorWillCloseDoors)] ) {
        [delegate elevatorWillCloseDoors];
    }
    
    usleep(ELEVATOR_TIME_TO_CLOSE_THE_DOORS);
    areDoorsOpened  = NO;
    //NSLog(@"Elevator CLOSED doors on %u floor", currentFloor);

    // Notify a delegate object
    if ( [delegate respondsToSelector:@selector(elevatorDidCloseDoors)] ) {
        [delegate elevatorDidCloseDoors];    
    }
    
    return YES;
}




-(unsigned) totalWeightOfPeopleInside
{
    unsigned totalWeight = 0;
    for (Person *person in peopleInside) {
        totalWeight+=person.weight; 
    }
    return totalWeight;
}


// Implement the accessor methods
- (id)delegate {
    return delegate;
}
- (void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}
//////////////////////////////////////

@end