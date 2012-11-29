//
//  PersonGeneratorDelegate.h
//  EducationUI2
//
//  Created by Sergey Nikolsky on 30.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"

@protocol PersonGeneratorDelegate <NSObject>

@optional
-(void) personGeneratorDidGeneratePerson: (Person *)person;

@end

