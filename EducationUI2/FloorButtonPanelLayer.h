//
//  FloorButtonPanelLayer.h
//  EducationUI2
//
//  Created by Sergey Nikolsky on 12.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class FloorButtonLayer;

@interface FloorButtonPanelLayer : CALayer {
@private
    FloorButtonLayer *upButtonLayer;
    FloorButtonLayer *downButtonLayer;
}


- (id) initWithBounds:(CGRect)bounds withUpButton:(BOOL)upButton andWithDownButton:(BOOL)downButton;

- (void)pressUpButton;
- (void)pressDownButton;
- (void)dropUpButton;
- (void)dropDownButton;


@end
