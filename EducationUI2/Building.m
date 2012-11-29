//
//  Building.m
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  Use a mutable variant of an object when you need to modify its contents frequently and incrementally after it has been created.
//

#import "Building.h"
#import "BuildingElevatorsController.h"
#import "Elevator.h"
#import "ElevatorButtonsPanel.h"
#import "FloorButtonPanel.h"
#import "FloorButton.h"
#import "Person.h"
#import "PersonGenerator.h"
#import "Defines.h"

#import "BuildingDelegate.h"

@interface Building(myPrivateMethods)
// These are private methods that outside classes need not use
- (void)setupSharedBuilding; 
 
@end

@implementation Building

@synthesize elevatorsNumber, floorsNumber;
@synthesize peopleQueuesOnEachFloor;
@synthesize floorButtonPanels;
@synthesize elevators;

////////////////////// Building is a SINGLETON ///////////////////////////////

// @synchronized - mutex lock is expensive!

// I use the singleton approach, one Building for the entire application
static Building *sharedBuildingInstance = nil;

+ (id) sharedBuilding 
{
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ sharedBuildingInstance = [[self alloc] init]; });
    }    
    return sharedBuildingInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
// The @synchronized directive is a convenient way to create mutex locks on the fly in Objective-C code.    
    @synchronized(self) {
        if (sharedBuildingInstance == nil) {
            sharedBuildingInstance = [super allocWithZone:zone];
            return sharedBuildingInstance;  // assignment and return on first allocation
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
        NSLog(@"SharedBuilding initialization...");
		[self setupSharedBuilding];
	}
	return self;
}

- (void) setupSharedBuilding 
{
    NSLog(@"setupSharedBuilding...");
    
    elevatorsNumber = ELEVATORS_NUMBER;
    floorsNumber    = FLOORS_NUMBER;
    
    ///////////////////////  Init all elevators //////////////////////////////////////
    NSMutableArray *tmpArray;
    tmpArray = [[NSMutableArray alloc] init];
    for (int i=0; i<elevatorsNumber; i++) {
        Elevator *elevator = [[Elevator alloc] init];
        [tmpArray addObject:elevator];
        
    }
    elevators = [[NSArray alloc] initWithArray:tmpArray];
        
    //////////////////////////////////////////////////////////////////////////////
    [tmpArray removeAllObjects];
    
    ///////////////////////  Init all floor button panels  ///////////////////////////
    for (int i=0; i<floorsNumber; i++) {
        FloorButtonPanel *floorButtonPanel = [[FloorButtonPanel alloc] init];
        [tmpArray addObject:floorButtonPanel];
        
    }
    floorButtonPanels = [[NSArray alloc] initWithArray:tmpArray];
    
    //////////////////////////////////////////////////////////////////////////////
    
    // BuildingElevatorsController init
    buildingElevatorsController = [[BuildingElevatorsController sharedBuildingElevatorsController] initWithElevators:elevators 
                                                                                                AndFloorButtonPanels:floorButtonPanels];
    
    //////////////////////////////////////////////////////////////////////////////
    // Array of people queues on each floor
    [tmpArray removeAllObjects];
    for (int i=0; i<floorsNumber; i++) {
        
        //replace with NSMutableArray for .count
        //NSMutableSet *peopleQueueOnEachFloor = [[NSMutableSet alloc] init];
        NSMutableArray *peopleQueueOnEachFloor = [[NSMutableArray alloc] init];
        [tmpArray addObject:peopleQueueOnEachFloor];
    }
    peopleQueuesOnEachFloor = [[NSArray alloc] initWithArray:tmpArray];
    //////////////////////////////////////////////////////////////////////////////
    
}    

//////////////////////////////////////////////////////////////////////////////

- (BOOL) addPeopleToElevator:(Elevator *)elevator
{
    
    //Thread-Unsafe Class - NSMutableSet
    // WEAK PLACE!!!
        
    //NSMutableSet *peopleQueueOnEachFloor = [[self peopleQueuesOnEachFloor] objectAtIndex:[elevator currentFloor]];
    NSMutableArray *peopleQueueOnEachFloor = [[self peopleQueuesOnEachFloor] objectAtIndex:[elevator currentFloor]];
    
    //!!! Could be an error while iteratting a peopleQueueOnEachFloor.
    // was mutated while being enumerated
    
    if (0 == [peopleQueueOnEachFloor count])
        return NO;
        
    //NSMutableSet *peopleToBeAdded;
    if ([elevator areDoorsOpened]) {
        //peopleToBeAdded = [[NSMutableSet alloc] init];
        
        // You cannot modify collection while being enumerated !!!
        // if you attempt to modify the collection during enumeration, an exception is raised.
        // you should NEVER modify a collection while enumerating through it.
        
        //for (Person *person in peopleQueueOnEachFloor) {
        //replace with
        for (int i=0; i<peopleQueueOnEachFloor.count; i++) {
            //NSLog(@"peopleQueueOnEachFloor.count=%u", peopleQueueOnEachFloor.count);
            
            Person *person = [peopleQueueOnEachFloor objectAtIndex:i];

            //while You add a person, Generator could add another person to the floor!
            
            
            if (person.currentDirection == elevator.currentDirection) {
                
                // Elevator is NOT overload
                if (!elevator.isOverload) {
                    [[elevator peopleInside] addObject:person];
                    
                    if (!elevator.isOverload) {
                        
                        //after getting rid of fast enumeration I can remove
                        [peopleQueueOnEachFloor removeObject:person];
                        i--;
                        
                        // you can't do this while iteration
                        //[peopleToBeAdded addObject:person];
                        
                        
                        ////////////////////////////////////////////////////////////////////////////////////////////////
                        //ONE Person is added to Elevator
                        if ( [delegate respondsToSelector:@selector(buildingWillAddPerson:toElevator:)] ) {
                            [delegate buildingWillAddPerson:person toElevator:elevator]; 
                        }
                        ////////////////////////////////////////////////////////////////////////////////////////////////
                        usleep(TIME_TO_ADD_PERSON_TO_ELEVATOR);
                        
                        [person pushElevatorButton:elevator];
                    }
                    else {
                        NSLog(@"Elevator is overloaded.");
                        [[elevator peopleInside] removeObject:person];
                        [person pushFloorButton];
                        
                        //exit from the loop
                        break;
                    }
                    
                }
                else
                    NSLog(@"Elevator is overloaded.");
            }
        }
    }
    else
        return NO;
    /*
    if ([peopleToBeAdded count]) {
        [peopleQueueOnEachFloor minusSet:peopleToBeAdded];
        
        [peopleToBeAdded release];
        return YES;
    }
    else {
        [peopleToBeAdded release];
        return NO;
    }
    */
    
    return YES;
}

- (BOOL) removePeopleFromElevator:(Elevator *)elevator
{
    NSMutableSet *peopleToBeRemoved = [[NSMutableSet alloc] init];
    
    if ([elevator areDoorsOpened])
        for (Person *person in [elevator peopleInside]) 
            if (person.desiredFloor == elevator.currentFloor) {
                
                if ([delegate respondsToSelector:@selector(buildingWillRemovePerson:fromElevator:)] ) {
                    [delegate buildingWillRemovePerson:person fromElevator:elevator]; 
                }

                //time to remove
                usleep(TIME_TO_REMOVE_PERSON_FROM_ELEVATOR);
                
                [peopleToBeRemoved addObject:person];
            }

    if ([peopleToBeRemoved count]) {
    //if ([peopleToBeRemoved count] > 0) {
        [[elevator peopleInside] minusSet:peopleToBeRemoved];
        
        //[peopleToBeRemoved removeAllObjects];
                
        return YES;
    }
    else {
        return NO;
    }
        
    // stop each timer
    // peopleInside
    
}

- (NSString *) description
{
    return @"sharedBuilding instance";
}


- (void) generatePeople
{
    // generate thread
    [self performSelectorInBackground:@selector(switchOnPersonGenerator) withObject:nil];
}
     
- (void) switchOnPersonGenerator
{
    NSLog(@"PersonGenerator in Building...");
    PersonGenerator *personGenerator = [PersonGenerator sharedPersonGenerator];
    
    
    //before start wait 1 sec
    sleep(0.5); 
    
    
    //int i=0;
    while (YES) {
        //i++;
        
        
        //NSLog(@"PersonGenerator is generating 5 new random people...");
        for (int i=0; i<2; i++)
            [personGenerator generatePersonToQueue];
        usleep(TIME_BETWEEN_PEOPLE_GENERATIONG); 
         
        //NSLog(@"PersonGenerator is generating 1 new person.");
        /*
        [personGenerator generatePersonToQueue];
        sleep(2);
        */
        //usleep(2000000);
    }
}


- (void) runElevators 
{
    usleep(TIME_BEFORE_RUN_ELEVATORS);
    NSLog(@"Waiting for BuildingElevatorsController...");
    [buildingElevatorsController runElevators];
}


// Implement the accessor methods
- (id)delegate {
    return delegate;
}
- (void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

@end

//////////////////////////////////////////////////////////////////////////////

@implementation Building(Tst)

- (void) tstViewPeopleInElevator
{
    unsigned elevatorIndx = 0;
    NSLog(@"tstViewPeopleInElevator");
    Elevator *elevator = [elevators objectAtIndex:elevatorIndx];
    NSLog(@"people in Elevator[%i]=%u, currentFloor=%i", elevatorIndx, [[elevator peopleInside] count], [elevator currentFloor]);
    
    // view elevator buttons
    NSUInteger count=[[[elevator buttonPanel] buttons] count];
    for(int i=(int)count-1; i<count; i--) {
        FloorButton *floorButton = [[[elevator buttonPanel] buttons] objectAtIndex:i];
        NSLog(@"Elevator floorButton[%i] %@", i, [floorButton isPressed] ? @"is pressed" : @"-");

    }
}

- (void) tstViewPeopleQueuesOnEachFloor
{ 
    NSLog(@"tstViewPeopleQueuesOnEachFloor:");
    
    NSUInteger count=[peopleQueuesOnEachFloor count];
    for(int i=(int)count-1; i<count; i--) {
        NSMutableSet *peopleQueueOnEachFloor = [peopleQueuesOnEachFloor objectAtIndex:i];
        NSLog(@"peopleQueueOn[%i]Floor=%u", i, [peopleQueueOnEachFloor count]);
        //view each Person
        for (Person *person in peopleQueueOnEachFloor)
            NSLog(@"\tperson(%i->%i)", [person initialFloor], [person desiredFloor]);   
    }
    NSLog(@"//////////////////////////////////////////////////////////");
}

- (void) tstViewfloorButtonPanels
{
    NSLog(@"tstViewfloorButtonPanels:");
    
    NSUInteger count=[floorButtonPanels count];
    for(int i=(int)count-1; i<count; i--) {
    //for(int i=0; i<[floorButtonPanels count]; i++) {
        FloorButtonPanel *floorButtonPanel = [floorButtonPanels objectAtIndex:i];
        
        NSString *buttons;
        
        if (YES==[floorButtonPanel isUpButtonPressed] && YES==[floorButtonPanel isDownButtonPressed])
            buttons = @"Up&Down";
        else if (YES==[floorButtonPanel isUpButtonPressed] && NO==[floorButtonPanel isDownButtonPressed])
            buttons = @"Up";
        else if (NO==[floorButtonPanel isUpButtonPressed] && YES==[floorButtonPanel isDownButtonPressed])
            buttons = @"Down";
        else
            buttons = @"-";
        
        NSLog(@"floorButtonPanel[%i]=%@", i, buttons);
    }
    NSLog(@"//////////////////////////////////////////////////////////");
}

- (void) tstInit
{
    NSLog(@"Building(Tst) tstObjcts...");
    
    NSLog(@"floorsNumber = %u", floorsNumber);
    NSLog(@"elevatorsNumber = %u", elevatorsNumber);
    
    NSLog(@"[peopleQueuesOnEachFloor count] = %u", [peopleQueuesOnEachFloor count]);
    NSLog(@"[elevators count] = %u", [elevators count]);

    [self tstViewPeopleQueuesOnEachFloor];
}

@end
