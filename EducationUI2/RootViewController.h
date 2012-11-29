//
//  RootViewController.h
//  EducationUI2
//
//  Created by Sergey Nikolsky on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "Defines.h"
#import "QuartzUtils.h"

#import "PersonDelegate.h"
#import "PersonGeneratorDelegate.h"
#import "ElevatorDelegate.h"
#import "BuildingDelegate.h"

@class Building;
@class BuildingGridLayer;
@class PersonGenerator;

@interface RootViewController : UIViewController <PersonDelegate, PersonGeneratorDelegate, ElevatorDelegate, BuildingDelegate> {
@private
    
    BuildingGridLayer *buildingGridLayer;
    NSArray *floorButtonPanels;
    CALayer *elevatorLayer;
    
    NSMutableDictionary *peopleLayers;
    
    NSArray *peopleLayersQueuesOnEachFloor;
    
    Building *building;
    PersonGenerator *personGenerator;
}

@property  NSArray *peopleLayersQueuesOnEachFloor;


@end
