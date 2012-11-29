//
//  Person.m
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"
#import "Building.h"
#import "Elevator.h"
#import "ElevatorButtonsPanel.h"
#import "FloorButtonPanel.h"
#import "FloorButton.h"

//protocol
#import "PersonDelegate.h"

@implementation Person


//-------------------------------------------------------
// designated initializer
// the designated initializer is the initializer with the most parameters
//-------------------------------------------------------

#pragma mark -
#pragma mark Initialization

- (id) initWithInitialFloor:(unsigned)iFloor AndDesiredFloor:(unsigned)dFloor AndWeight:(unsigned)w
{

    // checking values
    /*
    if (!iFloor || !dFloor || !w) {
        [self release];
        return nil;
    }
    */
    
    self = [super init];
    if (self) {
        //isInTheElevator = NO;
        initialFloor    = iFloor;
        desiredFloor    = dFloor;
        weight          = w;
        
        building = [Building sharedBuilding];
        
        //NSLog(@"new Person (%u->%u)", initialFloor, desiredFloor);
    }
        
    return self;
}

@synthesize initialFloor, desiredFloor, weight;
@synthesize waitingTimeOnTheFloor, waitingTimeInTheElevator;

@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Actions

- (void) pushFloorButton
{
    //initTime = [NSDate date];
        
    NSArray *floorButtonPanels = building.floorButtonPanels;
    FloorButtonPanel *floorButtonPanel;
    
    floorButtonPanel = [floorButtonPanels objectAtIndex:initialFloor];
    
    //NSLog(@"pressed floorButtonPanel on %u floor to %u", initialFloor, desiredFloor);
    // Direction Up and Down
    
    Elevator *elevator = [building.elevators objectAtIndex:0];

    if (UP == self.currentDirection)
        if (![floorButtonPanel isUpButtonPressed]) {
            
            //Elevator on current floor with Opened DOORS!!!! DO NOT PRESS THE BUTTON!!!
            if (UP == elevator.currentDirection && elevator.areDoorsOpened && elevator.currentFloor == self.initialFloor) {
                NSLog(@"\t\t UP!!! We've got situation!!!!");
            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(personWillPushUpButtonOnFloor:)])
                    [self.delegate personWillPushUpButtonOnFloor:initialFloor];    
                
                [floorButtonPanel pressUpButton];
                //NSLog(@"Person pressed pressUpButton on %u floor.", initialFloor);
            }
            
            
            
        }
    if (DOWN == self.currentDirection)
        if (![floorButtonPanel isDownButtonPressed]) {
            
            //Elevator on current floor with Opened DOORS!!!! DO NOT PRESS THE BUTTON!!!
            if (DOWN == elevator.currentDirection && elevator.areDoorsOpened && elevator.currentFloor == self.initialFloor) {
                NSLog(@"\t\t DOWN!!! We've got situation!!!!");
            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(personWillPushDownButtonOnFloor:)])
                    [self.delegate personWillPushDownButtonOnFloor:initialFloor];
                
                [floorButtonPanel pressDownButton];
                //NSLog(@"Person pressed pressDownButton on %u floor.", initialFloor);
            }
            
            
        }
}

- (void) pushElevatorButton:(Elevator *)elevator; 
{
    
    if (! [[[[elevator buttonPanel] buttons] objectAtIndex:desiredFloor] isPressed])
        [elevator pressFloorButton:desiredFloor];
    
}

- (unsigned) currentDirection
{
    //Upward
    if ((int)(desiredFloor-initialFloor)>0)
        return UP;
    else
    //Downward
        return DOWN;
}

#pragma mark -

- (NSString *)description
{
    return [NSString stringWithFormat:
    @"Person initialFloor=%u, desiredFloor=%u, weight=%u", initialFloor, desiredFloor, weight];
            
}

- (void) dealloc
{
    //NSLog(@"Person is going to DEALLOC...");
    //NSLog(@"Person from:%u to:%u", initialFloor, desiredFloor);
    
    self.delegate = nil;
}

////////////////////////////////

//For example, this method lets you use a class object as a key to an NSDictionary object
//A key can be any object that adopts the NSCopying protocol and implements the hash and isEqual:
- (id)copyWithZone:(NSZone *)zone
{    
    Person *newPerson = [[Person allocWithZone:zone] initWithInitialFloor:initialFloor AndDesiredFloor:desiredFloor AndWeight:weight];

    return newPerson;
}

////////////////////////////////

- (BOOL)isEqual:(id)anObject
{
    if (![anObject isKindOfClass:[Person class]] )  return NO;

    Person *otherPerson = (Person *)anObject;
    if (self.initialFloor == otherPerson.initialFloor && 
        self.desiredFloor == otherPerson.desiredFloor && 
        self.weight == otherPerson.weight)
        return YES;
        
    return NO;
}

- (NSUInteger) hash
{

    unsigned iF = self.initialFloor;
    unsigned dF = self.desiredFloor;
    unsigned w = self.weight;

    //!=0
    iF++;
    dF++;
    w++;
    
    return iF*dF*w;
}

////////////////////////////////

// Implement the accessor methods
/*
- (id)delegate {
    return delegate;
}
- (void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}
*/
////////////////////////////////

@end
