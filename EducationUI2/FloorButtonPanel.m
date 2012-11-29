//
//  FloorButtonPanel.m
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FloorButtonPanel.h"
#import "FloorButton.h"
#import "Building.h"

@implementation FloorButtonPanel

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        upButton = [[FloorButton alloc] init];
        downButton = [[FloorButton alloc] init];
        
    }
    
    return self;
}

- (BOOL) isUpButtonPressed {
    return upButton.isPressed;
}
- (BOOL) isDownButtonPressed {
    return downButton.isPressed;
}

- (void)pressUpButton
{
    [upButton press];
    // Add up queue request
    
    //Building Building
    //Building *building = [Building sharedBuilding];
    
    
}
- (void)pressDownButton
{
    [downButton press];
    // Add down queue request
    
    
    
}

- (void)dropUpButton
{
    [upButton drop];
}
- (void)dropDownButton
{
    [downButton drop];
}




@end
