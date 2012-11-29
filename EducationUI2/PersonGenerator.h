//
//  PersonGenerator.h
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Building;

@interface PersonGenerator : NSObject {
@private
    unsigned *weightArray;
    unsigned *occuranceArray;
    unsigned queueTail;
    unsigned gaussianElmts;
    
    //NSTimer *myTimer;
        
    // weak reference
    Building __weak *building;
    
    //delegate object
    id delegate;
}

+ (id) sharedPersonGenerator;
- (BOOL) generatePersonToQueue;

// Declare the delegate accessor methods in your class header file
- (id)delegate;
- (void)setDelegate:(id)newDelegate;
//////////////////////////////////////////////////////////////////////

@end

@interface PersonGenerator(Tst)
- (void) tstGenerateWeight;
- (void) tstIFloorForMorningRush;
- (void) tstGenerateCustomPeople;
@end


