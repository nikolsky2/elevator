//
//  BuildingElevatorsController.h
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Elevator;

@interface BuildingElevatorsController : NSObject {
@private
    NSArray *elevators;
    NSArray *floorButtonPanels;
}

+ (id) sharedBuildingElevatorsController;
- (id) initWithElevators:(NSArray *)elevators AndFloorButtonPanels:(NSArray *)floorButtonPanels;

- (void) runElevators;
- (void) moveElevator:(Elevator *)elevator ToTheFloor:(unsigned)floor;

@end

////////////////////////////////////////////////////////

@interface BuildingElevatorsController(Tst)

- (void) tstBuildingElevatorsControllerHighestAndLowest:(Elevator *)elevator;
- (void) tstBuildingElevatorsController;

@end

