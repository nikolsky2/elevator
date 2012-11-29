//
//  FloorButtonLayer.h
//  EducationUI2
//
//  Created by Sergey Nikolsky on 12.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface FloorButtonLayer : CALayer {
    @private
    BOOL isPressed;
    BOOL isUp;
}


//- (CGFloat) floorButtonWidth

- (id) initWithUpOrientation:(BOOL)up;

-(void) press;
-(void) drop;


@end
