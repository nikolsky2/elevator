//
//  BuildingGridLayer.m
//  EducationUI2
//
//  Created by Sergey Nikolsky on 25.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BuildingGridLayer.h"

#import "Defines.h"
#import "FloorButtonPanelLayer.h"

@implementation BuildingGridLayer


/*
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        NSLog(@"This is BuildingGridLayer initializer!");
        
        NSMutableArray *mutableFloorButtonPanels = [[NSMutableArray alloc] init];
        for (int i=0; i<FLOORS_NUMBER; i++) {
            CGRect panelBounds = CGRectMake(0, 0, self.floorButtonPanelsWidth, self.oneFloorHeight);
            FloorButtonPanelLayer *panel = 
            [[FloorButtonPanelLayer alloc] initWithBounds:panelBounds];
            panel.position = [self positionForFloorButtonPanelOnFloor:0];
            panel.backgroundColor = [[UIColor redColor] CGColor];
            
            [mutableFloorButtonPanels addObject:panel];
            [self addSublayer:panel];
            [panel release];
        }
        floorButtonPanels = [[NSArray alloc] initWithArray:mutableFloorButtonPanels];
        [mutableFloorButtonPanels release];
        
 
    }
    return self;
}
*/


- (CGPoint) positionForElevatorOnFloor:(unsigned) floor
{
    floor+=1;
    return CGPointMake(0.5*self.elevatorShaftWidth + self.frameGap,
                       self.buildingHeight - (self.oneFloorHeight * floor) + 0.5f * self.oneFloorHeight + self.frameGap);    
}

- (CGPoint) positionForFloorButtonPanelOnFloor:(unsigned) floor
{
    floor+=1;
    return CGPointMake(0.5*self.floorButtonPanelsWidth + self.elevatorShaftWidth + self.frameGap,
                       self.buildingHeight - (self.oneFloorHeight * floor) + 0.5f * self.oneFloorHeight + self.frameGap);
}


- (CGPoint) randomPositionForPersonWithWidth:(CGFloat)width onFloor:(unsigned)floor;
{
    
    floor+=1;
    return CGPointMake([BuildingGridLayer randomValueWithinIntervalFrom:(self.frameGap + self.elevatorShaftWidth + self.floorButtonPanelsWidth) + width/2 
                                                                     to:(self.frameGap + self.elevatorShaftWidth + self.floorButtonPanelsWidth + self.floorsWidth) - width/2], 
                       self.buildingHeight - (self.oneFloorHeight * floor) + 0.5f * self.oneFloorHeight + self.frameGap);
    
}
- (CGPoint) randomPositionForPersonWithWidth:(CGFloat)width inElevatorOnFloor:(unsigned)floor
{
    floor+=1;
    return CGPointMake([BuildingGridLayer randomValueWithinIntervalFrom:(self.frameGap) + width/2 
                                                                     to:(self.frameGap + self.elevatorShaftWidth) - width/2], 
                       self.buildingHeight - (self.oneFloorHeight * floor) + 0.5f * self.oneFloorHeight + self.frameGap);
    
}

//////////////////////////////////////////////////////////////////////////////////////////

-(void) drawUpButtonInContext:(CGContextRef)ctx andPressed:(BOOL)pressed onFloor:(unsigned)floor
{
    floor+=1;
    
    CGFloat arrowWidth = self.floorButtonWidth;
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat floorButtonPanelsOriginX = self.frameGap + self.elevatorShaftWidth;

    CGFloat floorButtonPanelsOriginY = self.buildingHeight - (self.oneFloorHeight * floor) + (1/3.0f) * self.oneFloorHeight + self.frameGap;
        
    CGPoint point = CGPointMake(floorButtonPanelsOriginX + self.floorButtonPanelsWidth / 2.0f,
                        floorButtonPanelsOriginY - arrowWidth / sqrt(3));
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    
    point = CGPointMake(floorButtonPanelsOriginX + self.floorButtonPanelsWidth / 4.0f, 
                        floorButtonPanelsOriginY + arrowWidth / (2*sqrt(3)));
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    
    point = CGPointMake(floorButtonPanelsOriginX + (3*self.floorButtonPanelsWidth) / 4.0f, 
                        floorButtonPanelsOriginY + arrowWidth / (2*sqrt(3)));
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    CGPathCloseSubpath(path);
    
    
    ////////////////////////////////////////////////////////////////////////
    CGContextSetLineWidth(ctx, 2.0f);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    
    if (pressed) {
        CGContextSetFillColorWithColor(ctx, [[UIColor greenColor] CGColor]);
        CGContextAddPath(ctx, path);
        CGContextFillPath(ctx);
    }
    
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
    
    CGPathRelease(path);
    
    
    
}
-(void) drawDownButtonInContext:(CGContextRef)ctx andPressed:(BOOL)pressed onFloor:(unsigned)floor
{
        
    floor+=1;
    
    CGFloat arrowWidth = self.floorButtonWidth;
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat floorButtonPanelsOriginX = self.frameGap + self.elevatorShaftWidth;
    
    CGFloat floorButtonPanelsOriginY = self.buildingHeight - (self.oneFloorHeight * floor) + (2/3.0f) * self.oneFloorHeight + self.frameGap;
    
    CGPoint point = CGPointMake(floorButtonPanelsOriginX + self.floorButtonPanelsWidth / 2.0f,
                        floorButtonPanelsOriginY + arrowWidth / sqrt(3));
    
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    
    point = CGPointMake(floorButtonPanelsOriginX + self.floorButtonPanelsWidth / 4.0f, 
                        floorButtonPanelsOriginY - arrowWidth / (2*sqrt(3)));
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(floorButtonPanelsOriginX + (3*self.floorButtonPanelsWidth) / 4.0f, 
                        floorButtonPanelsOriginY - arrowWidth / (2*sqrt(3)));
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    CGPathCloseSubpath(path);
    
    
    ////////////////////////////////////////////////////////////////////////
    CGContextSetLineWidth(ctx, 2.0f);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    
    if (pressed) {
        CGContextSetFillColorWithColor(ctx, [[UIColor greenColor] CGColor]);
        CGContextAddPath(ctx, path);
        CGContextFillPath(ctx);
    }
    
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
    
    CGPathRelease(path);
    
}

//////////////////////////////////////////////////////////////////////////////////////////
- (CGRect) elevatorBounds
{
    return CGRectMake(0.0f, 0.0f, self.elevatorShaftWidth, self.oneFloorHeight);
}
//////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat) buildingHeight
{
    return (self.bounds.size.height - 2*self.frameGap);
}
- (CGFloat) oneFloorHeight
{
    return (self.buildingHeight/FLOORS_NUMBER);
}
- (CGFloat) frameGap
{
    return (FRAME_GAP_PERC * self.bounds.size.width / 2.0f);
}
- (CGFloat) floorButtonPanelsWidth 
{
    return (FLOOR_BUTTON_PANELS_PERC * self.bounds.size.width);
}
- (CGFloat) elevatorShaftWidth
{
    return (ELEVATOR_SHAFT_PERC * self.bounds.size.width);
}
- (CGFloat) floorsWidth
{
    return (FLOOR_PERC * self.bounds.size.width);
}
- (CGFloat) floorButtonWidth
{
    return self.floorButtonPanelsWidth / 2.0f;
}


//////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat) randomValueWithinIntervalFrom:(int)from to:(int)to
{
    return (CGFloat) (arc4random() % (to - from) + from);
}
//////////////////////////////////////////////////////////////////////////////////////////


- (void)drawInContext:(CGContextRef)ctx 
{
    
    NSLog(@"- (void)drawInContext:(CGContextRef)ctx for BuildingGridLayer");
        
    // Drawing with a white stroke color
	CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
	// And draw with a blue fill color
	CGContextSetRGBFillColor(ctx, 0.0, 0.0, 1.0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(ctx, 2.0);
    
    
    //////////////////// 1. Building levels ////////////////////
    // actual width in points
    CGFloat frameGap = self.frameGap;
    CGFloat floorButtonPanelsWidth = self.floorButtonPanelsWidth;
    CGFloat elevatorShaftWidth = self.elevatorShaftWidth;
    CGFloat floorsWidth = self.floorsWidth;
    CGFloat oneFloorHeight = self.oneFloorHeight;
    
    //NSLog(@"building frame W,H = (%0.0f, %0.0f)", self.bounds.size.width, self.bounds.size.height);
    
    //////////////////// 1. Elevator shaft ////////////////////
    //CGContextStrokeRect(ctx, CGRectMake(frameGap, frameGap, elevatorShaftWidth, buildingHeight));
    CGFloat floorY = frameGap;
    for (int i=0; i<FLOORS_NUMBER; i++) {
        CGRect floor = {frameGap, floorY, elevatorShaftWidth, oneFloorHeight};
        floorY += oneFloorHeight;
        CGContextStrokeRect(ctx, floor);
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //////////////////// 2. FloorButtonPanels ////////////////////
    floorY = self.frameGap;
    for (int i=0; i<FLOORS_NUMBER; i++) {
        CGRect floor = {self.frameGap + self.elevatorShaftWidth,  floorY, self.floorButtonPanelsWidth, self.oneFloorHeight};
        floorY += self.oneFloorHeight;
        CGContextStrokeRect(ctx, floor);
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //////////////////// 3. Floors ////////////////////
    floorY = frameGap;
    for (int i=0; i<FLOORS_NUMBER; i++) {
        CGRect floor = {frameGap + elevatorShaftWidth + floorButtonPanelsWidth, floorY, floorsWidth, oneFloorHeight};
        floorY += oneFloorHeight;
        CGContextStrokeRect(ctx, floor);
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    //////////////////// 4. Floor buttons ////////////////////
    //highest
    //lowest triangle DO NOT DRAW!

    /*
    [self drawUpButtonInContext:ctx andPressed:NO onFloor:0];
    for (int i=1; i<FLOORS_NUMBER-1; i++) {    
        [self drawUpButtonInContext:ctx andPressed:NO onFloor:i];
        [self drawDownButtonInContext:ctx andPressed:NO onFloor:i];
        
        //[self drawUpButtonInContext:ctx andPressed:YES onFloor:i];
        //[self drawDownButtonInContext:ctx andPressed:YES onFloor:i];
        
    }
    [self drawDownButtonInContext:ctx andPressed:NO onFloor:FLOORS_NUMBER-1];
    */
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    //////////////////// 5. Floor numbers ////////////////////
    CGContextSetAlpha(ctx, 0.5f);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    
    CGContextSelectFont(ctx, "Helvetica", 0.7f*oneFloorHeight, kCGEncodingMacRoman);
    
    // Next we set the text matrix to flip our text upside down. We do this because the context itself
	// is flipped upside down relative to the expected orientation for drawing text
	CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0, -1.0));
    CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);

    /*
     // Objects treated as single shape
     CGContextBeginTransparencyLayer (myContext, NULL);// 4
     // Your drawing code here// 5
     CGContextEndTransparencyLayer (myContext);
     */
    
    //set Shadow
    CGSize shadowOffset = CGSizeMake (0.0f,  0.0f);
    CGColorRef shadowColor = [[UIColor redColor] CGColor];
    CGContextSetShadowWithColor (ctx, shadowOffset, 5, shadowColor);
    
    for (int i=0; i<FLOORS_NUMBER; i++) {
        NSString *floorNumbers = [NSString stringWithFormat:@"%i",i];

        CGContextShowTextAtPoint(ctx, 
                                 self.frameGap + self.elevatorShaftWidth - self.floorButtonPanelsWidth, 
                                 self.buildingHeight - (self.oneFloorHeight * (i+1)) + 0.7f * self.oneFloorHeight + self.frameGap, 
                                 [floorNumbers UTF8String], 
                                 strlen([floorNumbers UTF8String]));
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
}


@end
