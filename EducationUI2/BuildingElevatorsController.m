//
//  BuildingElevatorsController.m
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuildingElevatorsController.h"
#import "Building.h"
#import "FloorButtonPanel.h"
#import "Elevator.h"
#import "ElevatorButtonsPanel.h"
#import "FloorButton.h"
#import "Defines.h"

@interface BuildingElevatorsController(myPrivateMethods)
// These are private methods that outside classes need not use
- (void)setupSharedBuildingElevatorsController; 

- (BOOL) isEmptyUpwardFloorRequests;
- (BOOL) isEmptyDownwardFloorRequests;
- (BOOL) isEmptyElevatorFloorRequests:(Elevator *)elevator;
- (BOOL) areThereAnyRequestsForElevator:(Elevator *)elevator;

- (unsigned) highestUpwardFloorRequest;
- (unsigned) highestDownwardFloorRequest;
- (unsigned) highestFloorRequestForElevator:(Elevator *)elevator;
- (unsigned) theHighestRequestForElevator:(Elevator *)elevator; 

- (unsigned) lowestUpwardFloorRequest;
- (unsigned) lowestDownwardFloorRequest;
- (unsigned) lowestFloorRequestForElevator:(Elevator *)elevator;
- (unsigned) theLowestRequestForElevator:(Elevator *)elevator;

- (void) analyseRequestsForElevator:(Elevator *)elevator;

@end

@implementation BuildingElevatorsController

////////////////////// BuildingElevatorsController is a SINGLETON ///////////////////////////////
static BuildingElevatorsController *buildingElevatorsControllerInstance = nil;
+ (id) sharedBuildingElevatorsController
{
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ buildingElevatorsControllerInstance = [[self alloc] init]; });
    }   
    return buildingElevatorsControllerInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    // The @synchronized directive is a convenient way to create mutex locks on the fly in Objective-C code.
    @synchronized(self) {
        if (buildingElevatorsControllerInstance == nil) {
            buildingElevatorsControllerInstance = [super allocWithZone:zone];
            return buildingElevatorsControllerInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
/*
- (id)retain {
    return self;
}
- (NSUInteger)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}
- (oneway void)release {
    //do nothing
}
- (id)autorelease {
    return self;
}
*/ 

// setup the data
- (id) init {
	if (self = [super init]) {
        NSLog(@"SharedBuildingElevatorsController initialization...");
		[self setupSharedBuildingElevatorsController];
	}
	return self;
}

- (void) setupSharedBuildingElevatorsController 
{
    // setup internal data
    
    //NSLog(@"setupSharedBuildingElevatorsController...");
    // get elevators from sharedBuilding
    //Building *building = [Building sharedBuilding];
    //elevators = [building elevators];
    
}

-(id) initWithElevators:(NSArray *)elvtrs AndFloorButtonPanels:(NSArray *)flrBttnPnls 
{
    //NSLog(@"[elvtrs retainCount] = %lu", [elvtrs retainCount]);
    
    
    floorButtonPanels   = [flrBttnPnls copyWithZone:nil];
    
    // Copy to another object elevators BUT same elevators inside! Shallow copy // each elevator has retain=2 // BUT elevators has retain=1
    //elevators=[[NSArray alloc] initWithArray: elvtrs copyItems: NO];
    
    //The returned object is implicitly RETAINed by the sender, who is responsible for releasing it.
    elevators           = [elvtrs copyWithZone:nil];
    
       
    
    return self;
}

//////////////////////////////////////////////////////////////////////////////

- (void) analyseRequestsForElevator:(Elevator *)elevator
{
    unsigned TheHighestR = [self theHighestRequestForElevator:elevator];
    unsigned TheLowestR = [self theLowestRequestForElevator:elevator];
    
    // Distances are not used
    //unsigned hDistance, lDistance;
    //unsigned eCF = elevator.currentFloor;
    //hDistance = (eCF >= TheHighestR)?(eCF - TheHighestR):(TheHighestR - eCF);
    //lDistance = (eCF >= TheLowestR)?(eCF - TheLowestR):(TheLowestR - eCF);
    
    //////////////////////////////////////////////////////
    //switch direction on Max floor
    if (TheHighestR==elevator.currentFloor && UP == elevator.currentDirection) {
        //NSLog(@"(TheHighestR)change direction...");
        if ([[floorButtonPanels objectAtIndex:[elevator currentFloor]] isUpButtonPressed])
            elevator.currentDirection = UP;
        else    
            elevator.currentDirection = DOWN;
    }
    // switch direction on Min floor
    if (TheLowestR==elevator.currentFloor && DOWN == elevator.currentDirection) {
        //NSLog(@"(TheLowestR)change direction...");
        if ([[floorButtonPanels objectAtIndex:[elevator currentFloor]] isDownButtonPressed])
            elevator.currentDirection = DOWN;
        else
            elevator.currentDirection = UP;
    }
    //////////////////////////////////////////////////////
    
    if (TheHighestR == TheLowestR) {
        //NSLog(@"(TheHighestR == TheLowestR) ?...");
        if (TheHighestR == [elevator currentFloor]) {
            //check floor buttons direction
            
            //very seldom situation -- if UP and DOWN simultaneously (no change direction)
            if ( !([[floorButtonPanels objectAtIndex:[elevator currentFloor]] isUpButtonPressed] && 
                   [[floorButtonPanels objectAtIndex:[elevator currentFloor]] isDownButtonPressed])) {
                if ([[floorButtonPanels objectAtIndex:[elevator currentFloor]] isUpButtonPressed])
                    elevator.currentDirection = UP;        
                if ([[floorButtonPanels objectAtIndex:[elevator currentFloor]] isDownButtonPressed])
                    elevator.currentDirection = DOWN;
            }
        }
    }
    
    if (UP==elevator.currentDirection)
        elevator.destination = TheHighestR;
    
    if (DOWN==elevator.currentDirection)
        elevator.destination = TheLowestR;
    //////////////////////////////////////////////////////
    
    if (! [self areThereAnyRequestsForElevator:elevator])
        elevator.currentDirection = IDLE;
    //////////////////////////////////////////////////////

    //NSLog(@"(highest=%u lowest=%u) cur=%u->%u", TheHighestR, TheLowestR, elevator.currentFloor, elevator.destination);
}

- (void) moveElevator:(Elevator *)elevator ToTheFloor:(unsigned)floor
{
    Building *building = [Building sharedBuilding];
    
    // Some Person get in Elevator and request a ride in the middle of Elevator trip. 0--9 // 2--8
    if (floor > elevator.currentFloor) {
        for (int i=elevator.currentFloor+1; i<=(int)floor-1; i++) {
            [elevator moveToTheFloor:i];
            //NSLog(@"\tChecking for new request during upward Elevator step on %i.", i);
            if ([[floorButtonPanels objectAtIndex:i] isUpButtonPressed] || [[[[elevator buttonPanel] buttons] objectAtIndex:i] isPressed]) {
                [elevator openDoors];
                NSLog(@"\tDoors was opened due to upward new request on %i", i);
                
                //remove people
                [building removePeopleFromElevator:elevator];
                //get people
                [building addPeopleToElevator:elevator];
            }
        }
        [elevator moveToTheFloor:floor];
    }
    else {
        for (int i=elevator.currentFloor-1; i>=(int)floor+1; i--) {
            [elevator moveToTheFloor:i];
            //NSLog(@"\tChecking for new request during downward Elevator step on %i.", i);
            if ([[floorButtonPanels objectAtIndex:i] isDownButtonPressed] || [[[[elevator buttonPanel] buttons] objectAtIndex:i] isPressed]) {
                [elevator openDoors];
                NSLog(@"\tDoors was opened due to downward new request on %i", i);
                
                //remove people
                [building removePeopleFromElevator:elevator];
                //get people
                [building addPeopleToElevator:elevator];
            }
        }
        [elevator moveToTheFloor:floor];
    }
    
    // hide pass-through motion
    //[elevator moveToTheFloor:floor];
    
    ////////////////////////////////////  Refresh each move ////////////////////////////////////////////////
    // 1 BEFORE door openning
    [self analyseRequestsForElevator:elevator];
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [elevator openDoors];
    //remove people
    [building removePeopleFromElevator:elevator];
    //get people
    [building addPeopleToElevator:elevator];
    
    //NSLog(@"People in Elevator = %lu", [elevator.peopleInside count]);
    ////////////////////////////////////  Refresh each move ////////////////////////////////////////////////
    // 2 AFTER people are inside
    [self analyseRequestsForElevator:elevator];
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}

////////////////////////////////////////// Floor Requests ////////////////////////////////////
- (BOOL) isEmptyUpwardFloorRequests
{
    for (FloorButtonPanel *floorButtonPanel in floorButtonPanels)
        if ([floorButtonPanel isUpButtonPressed])
            return NO;
    return YES;
}
- (BOOL) isEmptyDownwardFloorRequests
{
    for (FloorButtonPanel *floorButtonPanel in floorButtonPanels)
        if ([floorButtonPanel isDownButtonPressed])
            return NO;
    return YES;
}
- (BOOL) isEmptyElevatorFloorRequests:(Elevator *)elevator
{
    for(FloorButton *floorButton in [[elevator buttonPanel] buttons])
        if ([floorButton isPressed])
            return NO;
    return YES;
}

- (BOOL) areThereAnyRequestsForElevator:(Elevator *)elevator
{
    if ([self isEmptyUpwardFloorRequests] && 
        [self isEmptyDownwardFloorRequests] &&
        [self isEmptyElevatorFloorRequests:elevator]
        ) 
        return NO;
    
    return YES;
}
////////////////////////////////////////// highest
- (unsigned) highestUpwardFloorRequest
{
    for (int i=FLOORS_NUMBER-1; i>=0; i--)
        if ([[floorButtonPanels objectAtIndex:i] isUpButtonPressed])
            return i;
    return 0;
}
- (unsigned) highestDownwardFloorRequest 
{
    for (int i=FLOORS_NUMBER-1; i>=0; i--)
        if ([[floorButtonPanels objectAtIndex:i] isDownButtonPressed])
            return i;
    return 0;
}
- (unsigned) highestFloorRequestForElevator:(Elevator *)elevator
{
    for (int i=FLOORS_NUMBER-1; i>=0; i--)
        if ([[[[elevator buttonPanel] buttons] objectAtIndex:i] isPressed])
            return i;
    return 0;
}

- (unsigned) theHighestRequestForElevator:(Elevator *)elevator 
{
    if (! [self areThereAnyRequestsForElevator:elevator])
        return 0;
    
    unsigned highestUpwardFloorRequest = [self highestUpwardFloorRequest];
    unsigned highestDownwardFloorRequest = [self highestDownwardFloorRequest];
    unsigned highestFloorRequestForElevator = [self highestFloorRequestForElevator:elevator];
    
    unsigned highestFloorRequest = 
    (highestUpwardFloorRequest >= highestDownwardFloorRequest) ? highestUpwardFloorRequest : highestDownwardFloorRequest;
    
    if (highestFloorRequest >= highestFloorRequestForElevator)
        return highestFloorRequest;
    else
        return highestFloorRequestForElevator;
    
}

////////////////////////////////////////// lowest

- (unsigned) lowestUpwardFloorRequest
{
    for (int i=0; i<FLOORS_NUMBER; i++)
        if ([[floorButtonPanels objectAtIndex:i] isUpButtonPressed])
            return i;    
    return 0;
}
- (unsigned) lowestDownwardFloorRequest
{    
    for (int i=0; i<FLOORS_NUMBER; i++)
        if ([[floorButtonPanels objectAtIndex:i] isDownButtonPressed])
            return i;    
    return 0;
}
- (unsigned) lowestFloorRequestForElevator:(Elevator *)elevator
{
    for (int i=0; i<FLOORS_NUMBER; i++)
        if ([[[[elevator buttonPanel] buttons] objectAtIndex:i] isPressed])
            return i;
    return 0;
}

- (unsigned) theLowestRequestForElevator:(Elevator *)elevator
{
    if (! [self areThereAnyRequestsForElevator:elevator])
        return 0;
    
    /*
   |-------------------|
   |         el        |
   |-------------------|
   |u/d|     0|1       |
   |-------------------|
   | 00|  0   | El     |
   | 01|  D   | D?El   |
   | 11| U?D  | D?U?El |
   | 10|  U   | U?El   |
    -------------------
    */
    
    BOOL u  = !([self isEmptyUpwardFloorRequests]);
    BOOL d  = !([self isEmptyDownwardFloorRequests]);
    BOOL el = !([self isEmptyElevatorFloorRequests:elevator]);
    
    //NSLog(@"u=%i, d=%i, el=%i", u, d, el);
    
    unsigned lowestUpwardFloorRequest = [self lowestUpwardFloorRequest];
    unsigned lowestDownwardFloorRequest = [self lowestDownwardFloorRequest];
    unsigned lowestFloorRequestForElevator = [self lowestFloorRequestForElevator:elevator];
    
    // 010
    if (!u & d & !el)
        return lowestDownwardFloorRequest;
    // 110
    if (u & d & !el)
        return (lowestUpwardFloorRequest <= lowestDownwardFloorRequest) ? lowestUpwardFloorRequest : lowestDownwardFloorRequest;
    // 100
    if (u & !d & !el)
        return lowestUpwardFloorRequest;
    ////////////
    // 001
    if (!u & !d & el)
        return lowestFloorRequestForElevator;
    // 011
    if (!u & d & el)
        return (lowestDownwardFloorRequest <= lowestFloorRequestForElevator) ? lowestDownwardFloorRequest : lowestFloorRequestForElevator;
    // 101
    if (u & !d & el)
        return (lowestUpwardFloorRequest <= lowestFloorRequestForElevator) ? lowestUpwardFloorRequest : lowestFloorRequestForElevator;    
    // 111
    if (u & d & el) {
        unsigned lowestFloorRequest = 
        (lowestUpwardFloorRequest <= lowestDownwardFloorRequest) ? lowestUpwardFloorRequest : lowestDownwardFloorRequest;
        
        if (lowestFloorRequest <= lowestFloorRequestForElevator)
            return lowestFloorRequest;
        else
            return lowestFloorRequestForElevator;
    }
    
    return 0;    
}


//////////////////////////////////////////////////////////////////////////////

- (void) runElevators 
{
    //Building *building = [Building sharedBuilding];
    
    // getting just first elevator
    Elevator *elevator = [elevators objectAtIndex:0];
    
    if (! [self areThereAnyRequestsForElevator:elevator])
        elevator.currentDirection = IDLE;
    
    // MAIN ELEVATOR LOOP
    while ([self areThereAnyRequestsForElevator:elevator]) {
        
        // Pre analysation
        [self analyseRequestsForElevator:elevator];
        
        //tst
        //[building tstViewPeopleQueuesOnEachFloor];
        //[building tstViewfloorButtonPanels];
        
        if (UP == elevator.currentDirection) {
            int i=elevator.currentFloor;
            while (i<=[self theHighestRequestForElevator:elevator] && elevator.currentDirection != IDLE) {
                if ([[floorButtonPanels objectAtIndex:i] isUpButtonPressed] || [[[[elevator buttonPanel] buttons] objectAtIndex:i] isPressed])
                    [self moveElevator:elevator ToTheFloor:i];
                
                //////////////////////////////////////////////////////////////////
                // Check for highest downward request
                // Elevator on 8, but downward request on 9
                if ([self theHighestRequestForElevator:elevator] == i) {
                    // check isDownButtonPressed
                    NSLog(@"Checking for the highest downward request...");
                    if ([[floorButtonPanels objectAtIndex:i] isDownButtonPressed])
                        [self moveElevator:elevator ToTheFloor:i];
                }
                //////////////////////////////////////////////////////////////////
                 
                i++;
            }
        }
        
        //tst
        //[building tstViewPeopleQueuesOnEachFloor];
        //[building tstViewfloorButtonPanels];
        //[building tstViewPeopleInElevator];
        
        if (DOWN == elevator.currentDirection) {
            int i=elevator.currentFloor;
            while (i>=(int)[self theLowestRequestForElevator:elevator] && elevator.currentDirection != IDLE) {
                if ([[floorButtonPanels objectAtIndex:i] isDownButtonPressed] || [[[[elevator buttonPanel] buttons] objectAtIndex:i] isPressed])
                    [self moveElevator:elevator ToTheFloor:i];
                
                //////////////////////////////////////////////////////////////////
                // Check for lowest upward request
                // Elevator on 3, but upward request on 2
                if ([self theLowestRequestForElevator:elevator] == i) {
                    // check isUpButtonPressed
                    NSLog(@"Checking for the lowest upward request...");
                    if ([[floorButtonPanels objectAtIndex:i] isUpButtonPressed])
                        [self moveElevator:elevator ToTheFloor:i];
                }
                //////////////////////////////////////////////////////////////////
                 
                i--;
            }
            
        }
    }    
}


@end

@implementation BuildingElevatorsController(Tst)

- (void) tstBuildingElevatorsControllerHighestAndLowest:(Elevator *)elevator;
{
    // getting just first elevator
    
    NSLog(@"//////////////////////////////////////////////////////////////////////////////");
    NSLog(@"tstBuildingElevatorsControllerHighestAndLowest");
    
    NSLog(@"highestUpwardFloorRequest=%i", [self highestUpwardFloorRequest]);
    NSLog(@"highestDownwardFloorRequest=%i", [self highestDownwardFloorRequest]);
    NSLog(@"highestFloorRequestForElevator[0]=%i", [self highestFloorRequestForElevator:elevator]);
    NSLog(@"theHighestRequestForElevator[0]=%i", [self theHighestRequestForElevator:elevator]);
    
    NSLog(@"lowestUpwardFloorRequest=%i", [self lowestUpwardFloorRequest]);
    NSLog(@"lowestDownwardFloorRequest=%i", [self lowestDownwardFloorRequest]);
    NSLog(@"lowestFloorRequestForElevator[0]=%i", [self lowestFloorRequestForElevator:elevator]);
    NSLog(@"theLowestRequestForElevator[0]=%i", [self theLowestRequestForElevator:elevator]);
    NSLog(@"//////////////////////////////////////////////////////////////////////////////");
}

- (void) tstBuildingElevatorsController
{
    NSLog(@"//////////////////////////////////////////////////////////////////////////////");
    NSLog(@"tstBuildingElevatorsController RUN ELEVATORS");
    
    [self runElevators];
    NSLog(@"//////////////////////////////////////////////////////////////////////////////");    
}

@end


