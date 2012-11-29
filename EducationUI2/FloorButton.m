//
//  FloorButton.m
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FloorButton.h"

@implementation FloorButton

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        isPressed = NO;
    }
    
    return self;
}

@synthesize isPressed;

-(void) press 
{
    isPressed = YES;    
}

-(void) drop 
{
    isPressed = NO;
    
}




@end
