//
//  ElevatorButtonsPanel.m
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ElevatorButtonsPanel.h"
#import "Building.h"
#import "FloorButton.h"
#import "Defines.h"

@implementation ElevatorButtonsPanel

- (id)init
{
    self = [super init];
    if (self) {
        
        NSMutableArray *tmpArray;
        tmpArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<FLOORS_NUMBER; i++) {
            FloorButton *floorButton = [[FloorButton alloc] init];
            [tmpArray addObject:floorButton];
        }
        
        buttons = [[NSArray alloc] initWithArray:tmpArray];
    }
    
    return self;
}

@synthesize buttons;

@end
