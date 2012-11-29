//
//  FloorButton.h
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloorButton : NSObject {
@private
    BOOL isPressed;
    
}

@property (nonatomic, readonly) BOOL isPressed;

-(void) press;
-(void) drop;



@end
