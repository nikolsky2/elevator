//
//  FloorButtonPanelLayer.m
//  EducationUI2
//
//  Created by Sergey Nikolsky on 12.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FloorButtonPanelLayer.h"
#import "FloorButtonLayer.h"

@implementation FloorButtonPanelLayer


//- (id) initWithBounds:(CGRect)bounds

- (id) initWithBounds:(CGRect)bounds withUpButton:(BOOL)upButton andWithDownButton:(BOOL)downButton
{
    if (self = [super init]) {
        
        [CATransaction flush];
        [CATransaction begin];
        [CATransaction setDisableActions:NO];

    
        self.bounds = bounds;
        
        //self.backgroundColor = [[UIColor greenColor] CGColor];
        
        if (upButton) {
            upButtonLayer = [[FloorButtonLayer alloc] initWithUpOrientation:YES];
            upButtonLayer.position = CGPointMake(self.bounds.size.width/2.0f, (1/4.0f)*self.bounds.size.height);
            upButtonLayer.bounds = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height/2.0f);
            upButtonLayer.opacity = 1.0f;
            //upButtonLayer.backgroundColor = [[UIColor redColor] CGColor];
            [self addSublayer:upButtonLayer];
            
            [upButtonLayer setNeedsDisplay];
        }
        
        if (downButton) {
            downButtonLayer = [[FloorButtonLayer alloc] initWithUpOrientation:NO];
            downButtonLayer.position = CGPointMake(self.bounds.size.width/2.0f , (3/4.0f) * self.bounds.size.height);
            downButtonLayer.bounds = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height/2.0f);
            downButtonLayer.opacity = 1.0f;
            //downButtonLayer.backgroundColor = [[UIColor greenColor] CGColor];
            [self addSublayer:downButtonLayer];
            [downButtonLayer setNeedsDisplay];
        }
        
        [CATransaction commit];
    }    
    return self;
}



////////////////////////////////////////////////////////////
- (void)pressUpButton
{
    if (upButtonLayer) {
        [upButtonLayer press];
        [upButtonLayer setNeedsDisplay];
        
        [CATransaction flush];
        [CATransaction begin];
        upButtonLayer.shadowColor = [[UIColor greenColor] CGColor];
        upButtonLayer.shadowRadius = 5.0f;
        upButtonLayer.shadowOpacity = 1.0f;
        upButtonLayer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        [CATransaction commit];
    }
    
}
- (void)pressDownButton
{
    if (downButtonLayer) {
        [downButtonLayer press];
        [downButtonLayer setNeedsDisplay];
        
        [CATransaction flush];
        [CATransaction begin];
        downButtonLayer.shadowColor = [[UIColor greenColor] CGColor];
        downButtonLayer.shadowRadius = 5.0f;
        downButtonLayer.shadowOpacity = 1.0f;
        downButtonLayer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        [CATransaction commit];
    }
}
- (void)dropUpButton
{
    if (upButtonLayer) {
        [upButtonLayer drop];
        [upButtonLayer setNeedsDisplay];
        
        //[CATransaction flush];
        
        [CATransaction begin];
        [CATransaction setDisableActions:NO];
        upButtonLayer.shadowOpacity = 0.0f;
        [CATransaction commit];
    }
}
- (void)dropDownButton
{
    if (downButtonLayer) {
        [downButtonLayer drop];
        [downButtonLayer setNeedsDisplay];   
        
        //[CATransaction flush];
        
        [CATransaction begin];
        [CATransaction setDisableActions:NO];
        downButtonLayer.shadowOpacity = 0.0f;
        [CATransaction commit];
    }
}
////////////////////////////////////////////////////////////


@end
