//
//  BuildingGridLayer.h
//  EducationUI2
//
//  Created by Sergey Nikolsky on 25.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface BuildingGridLayer : CALayer {
    
@private
    //NSArray *floorButtonPanels;
}


+ (CGFloat) randomValueWithinIntervalFrom:(int)from to:(int)to;

- (CGPoint) positionForElevatorOnFloor:(unsigned) floor;
- (CGPoint) positionForFloorButtonPanelOnFloor:(unsigned) floor;
- (CGPoint) randomPositionForPersonWithWidth:(CGFloat)width onFloor:(unsigned)floor;
- (CGPoint) randomPositionForPersonWithWidth:(CGFloat)width inElevatorOnFloor:(unsigned)floor;


// DO NOT USE THESE //
-(void) drawUpButtonInContext:(CGContextRef)ctx andPressed:(BOOL)pressed onFloor:(unsigned)floor;
-(void) drawDownButtonInContext:(CGContextRef)ctx andPressed:(BOOL)pressed onFloor:(unsigned)floor;
//////////////////////


@property (readonly) CGRect elevatorBounds;
@property (readonly) CGFloat buildingHeight;
@property (readonly) CGFloat oneFloorHeight;
@property (readonly) CGFloat frameGap;
@property (readonly) CGFloat floorButtonPanelsWidth;
@property (readonly) CGFloat elevatorShaftWidth;
@property (readonly) CGFloat floorsWidth;
@property (readonly) CGFloat floorButtonWidth;


@end
