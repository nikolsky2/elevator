//
//  BuildingDelegate.h
//  EducationUI2
//
//  Created by Sergey Nikolsky on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "Elevator.h"

@protocol BuildingDelegate <NSObject>

@optional
-(void)buildingWillAddPerson:(Person *)person toElevator:(Elevator *)elevator;
-(void)buildingWillRemovePerson:(Person *)person fromElevator:(Elevator *)elevator;



@end
