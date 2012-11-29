//
//  FloorButtonPanel.h
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FloorButton;

@interface FloorButtonPanel : NSObject {

@private
    FloorButton *upButton;
    FloorButton *downButton;
}

- (BOOL) isUpButtonPressed;
- (BOOL) isDownButtonPressed;

- (void)pressUpButton;
- (void)pressDownButton;

- (void)dropUpButton;
- (void)dropDownButton;


@end
