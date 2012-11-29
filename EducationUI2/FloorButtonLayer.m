//
//  FloorButtonLayer.m
//  EducationUI2
//
//  Created by Sergey Nikolsky on 12.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FloorButtonLayer.h"

@implementation FloorButtonLayer

- (id) initWithUpOrientation:(BOOL)up
{
    if (self = [super init]) {
        isUp = up;
        isPressed = NO;
    }    
    return self;   
}


- (void)drawInContext:(CGContextRef)ctx 
{
    //The context may be clipped to protect valid layer content
    
    // Next we set the text matrix to flip our text upside down. We do this because the context itself
	// is flipped upside down relative to the expected orientation for drawing text
	CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0, -1.0));
    CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
    
    CGContextSetLineWidth(ctx, 1.0f);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    CGContextSetFillColorWithColor(ctx, [[UIColor greenColor] CGColor]);
    
    //CGGeometry
    
    //Returns the bounding box of a clipping path
    //CGRect myRect = CGContextGetClipBoundingBox(ctx);
    
    
    // new bounds!
    // Encompassing rectangle, specify a negative value.
    CGRect newBounds = CGRectInset(self.bounds, 4.0f, 4.0f);
    
    CGFloat newHeight = newBounds.size.height;
    CGFloat newWidth = newBounds.size.width;
    
    
    CGFloat someSide = newWidth < newHeight ? newWidth : newHeight;
    CGFloat circleRadius = someSide / 2.0f;
    CGFloat triangleSide = sqrt(3) * circleRadius;
    
    CGPoint pointT;
    CGPoint pointR;
    CGPoint pointL;
    
    CGFloat heightCorrection = (1/4.0f)*someSide;
    //heightCorrection = 0.0f;
    

    if (isUp) {
        //NSLog(@"ok, we're here - UP Button!");
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        //top point
        //CGRectGetMidX(newBounds)
        //CGRectGetMidY(newBounds)
        
        pointT = CGPointMake(CGRectGetMidX(newBounds), 
                             CGRectGetMinY(newBounds) + heightCorrection);
        //right point
        pointR = CGPointMake(CGRectGetMidX(newBounds) + triangleSide/2.0f, 
                                     CGRectGetMidY(newBounds) + circleRadius/2.0f + heightCorrection);
        //left point
        pointL = CGPointMake(CGRectGetMidX(newBounds) - triangleSide/2.0f,
                                     CGRectGetMidY(newBounds) + circleRadius/2.0f + heightCorrection);
        
        
        /////////////////////////////////////////////////////////
        CGPathMoveToPoint(path, NULL, pointT.x, pointT.y);
        CGPathAddLineToPoint(path, NULL, pointR.x, pointR.y);
        CGPathAddLineToPoint(path, NULL, pointL.x, pointL.y);
        CGPathCloseSubpath(path);
        /////////////////////////////////////////////////////////
        
        if (isPressed) {
            CGContextAddPath(ctx, path);
            CGContextFillPath(ctx);
        }
        
        CGContextAddPath(ctx, path);
        CGContextStrokePath(ctx);
        
        CGPathRelease(path);
 
    }
    
    if (!isUp) {
        //NSLog(@"ok, we're here - DOWN Button!");
        
        heightCorrection *= -1;

        CGMutablePathRef path = CGPathCreateMutable();
        
        //bottom point
        pointT = CGPointMake(CGRectGetMidX(newBounds), 
                             CGRectGetMinY(newBounds) + someSide + heightCorrection);
        //right point
        pointR = CGPointMake(CGRectGetMidX(newBounds) + triangleSide/2.0f, 
                                     CGRectGetMidY(newBounds) - circleRadius/2.0f + heightCorrection);
        //left point
        pointL = CGPointMake(CGRectGetMidX(newBounds) - triangleSide/2.0f,
                                     CGRectGetMidY(newBounds) - circleRadius/2.0f + heightCorrection);
        
        /////////////////////////////////////////////////////////
        CGPathMoveToPoint(path, NULL, pointT.x, pointT.y);
        CGPathAddLineToPoint(path, NULL, pointR.x, pointR.y);
        CGPathAddLineToPoint(path, NULL, pointL.x, pointL.y);
        CGPathCloseSubpath(path);
        /////////////////////////////////////////////////////////
        
        if (isPressed) {
            CGContextAddPath(ctx, path);
            CGContextFillPath(ctx);
        }
        
        CGContextAddPath(ctx, path);
        CGContextStrokePath(ctx);
        
        CGPathRelease(path);
        
        
    }
}

-(void) press
{
    isPressed = YES;
}
-(void) drop
{
    isPressed = NO;
}

@end
