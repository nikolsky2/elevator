//
//  Person.h
//  EducationUI2
//
//  Created by Sergey Nikolsky on 23.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PersonLayer : CALayer {
    @private
    CALayer *body, *textLabel;
    CGFloat layerHeight;
    unsigned dFloor;
}


- (id) initWithHeight:(CGFloat)height andDesiredFloor:(unsigned)desiredFloor;

- (CALayer*) createBody;
- (CALayer*) createLabel;


@end
