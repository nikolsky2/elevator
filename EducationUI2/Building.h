//
//  Building.h
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BuildingElevatorsController;
@class Elevator;

enum direction { UP=0, DOWN, IDLE };

// Building is a Singleton

@interface Building : NSObject {

@private
    unsigned elevatorsNumber;
    unsigned floorsNumber;
    
    NSArray *elevators;
    NSArray *floorButtonPanels;
    /*
     Array of people queues on each floor
     ________________________
     Elevator | People set
             <-
              | 0 1 2
            0 | 1 2
          0 1 | 2
        0 1 2 |
     ________________________
     */
  
    NSArray *peopleQueuesOnEachFloor;
    
    //Singleton
    BuildingElevatorsController *buildingElevatorsController;
    
    //delegate object
    id delegate;
}

@property (nonatomic, readonly) unsigned elevatorsNumber, floorsNumber;
@property  NSArray *peopleQueuesOnEachFloor;

@property (nonatomic, readonly) NSArray *floorButtonPanels;
@property (nonatomic, readonly) NSArray *elevators;

// For Singleton // MotherShip class method
+ (id) sharedBuilding;

// used by BuildingElevatorsController
- (BOOL) addPeopleToElevator:(Elevator *)elevator;
- (BOOL) removePeopleFromElevator:(Elevator *)elevator;

- (void) generatePeople;
- (void) runElevators;


// Declare the delegate accessor methods in your class header file
- (id)delegate;
- (void)setDelegate:(id)newDelegate;

@end

@interface Building(Tst)
- (void) tstViewPeopleInElevator;
- (void) tstViewPeopleQueuesOnEachFloor;
- (void) tstViewfloorButtonPanels;

- (void) tstInit;
@end
