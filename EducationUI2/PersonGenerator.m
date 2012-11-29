//
//  PersonGenerator.m
//  Education2
//
//  Created by Sergey Nikolsky on 07.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PersonGenerator.h"
#import "Building.h"
#import "Person.h"
#import "Defines.h"

//protocol
#import "PersonGeneratorDelegate.h"

////////////////////////////////////////////////////////////////////////////////////////

@interface PersonGenerator(Rush)
- (unsigned) iFloorWithZeroFloorProbability:(float)prob;
@end

////////////////////////////////////////////////////////////////////////////////////////

@interface PersonGenerator(Gauss)
- (double) gaussianPDFx: (double)x AndMu:(double)u AndSqrSigma:(double)sqSigma; 
- (void) fillArrays;
- (unsigned) generateWeightByGaussianPDF;
@end

@interface PersonGenerator(myPrivateMethods)
// These are private methods that outside classes need not use
- (void)setupSharedPersonGenerator;
@end

@implementation PersonGenerator

////////////////////// PersonGenerator is a SINGLETON ///////////////////////////////
static PersonGenerator *sharedPersonGeneratorInstance = nil;

+ (id) sharedPersonGenerator 
{
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ sharedPersonGeneratorInstance = [[self alloc] init]; });
    }
    return sharedPersonGeneratorInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    // The @synchronized directive is a convenient way to create mutex locks on the fly in Objective-C code.    
    @synchronized(self) {
        if (sharedPersonGeneratorInstance == nil) {
            sharedPersonGeneratorInstance = [super allocWithZone:zone];
            return sharedPersonGeneratorInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
 
/*
- (id)retain
{
    return self;
}
- (NSUInteger)retainCount
{
    return NSUIntegerMax; //denotes an object that cannot be released
}
- (oneway void)release {
    //do nothing
}
- (id)autorelease {
    return self;
}
*/ 

// setup the data
- (id) init {
	if (self = [super init]) {
        NSLog(@"SharedPersonGenerator initialization...");
		[self setupSharedPersonGenerator];
	}
	return self;
}

- (void) setupSharedPersonGenerator
{
    NSLog(@"setupSharedPersonGenerator...");
    
    [self fillArrays];
    building = [Building sharedBuilding];
    
}


//////////////////////////////////////////////////////////////////////////////


- (BOOL) generatePersonToQueue
{
    ////////////////////////////////////////////////////////////////////////////////////////////////
    //NSLog(@"generatePersonToQueue");    
    NSMutableArray *peopleQueueOnEachFloor;
    
    ////////////////////////////////////////////////////////////////////////////////////////
    // Simulate morning rush depends on time and FLOORS_NUMBER
    // and quantity people in the building
    // 5 floors 2 elevators and 500 people
    ////////////////////////////////////////////////////////////////////////////////////////
    
    // iFloorForMorningRush
    //unsigned iFloor = [self iFloorWithZeroFloorProbability:50]; //0-floor =50%
    //unsigned iFloor = [self iFloorWithZeroFloorProbability:5];  //0-floor = 5%
    
    //unsigned iFloor = [self iFloorWithZeroFloorProbability:0.5];
    
    unsigned iFloor = arc4random() % building.floorsNumber;
    unsigned dFloor = arc4random() % building.floorsNumber;
    
    // ONLY iFloor differ from dFloor
    while (iFloor==dFloor)
        dFloor = arc4random() % building.floorsNumber;
    
    //NSLog(@"iFloor=%u, dFloor=%u", iFloor, dFloor);
    
    unsigned pWeight = [self generateWeightByGaussianPDF];
    
    Person *person = [[Person alloc] initWithInitialFloor:iFloor AndDesiredFloor:dFloor AndWeight:pWeight];
    
    peopleQueueOnEachFloor = [building.peopleQueuesOnEachFloor objectAtIndex:person.initialFloor];
    if ([peopleQueueOnEachFloor count] >= MAX_PEOPLE_IN_EACH_QUEUE) {
        //exit
        return NO;
    }
    
    // In a managed memory environment, an object receives a retain message when it’s added // retain=+1
    [peopleQueueOnEachFloor addObject:person];
    
    
    //15.02.2012
    //Add to each person instance the same delegate object as PersonGenerator has.
    if (delegate) 
        person.delegate = self.delegate;
    
    [person pushFloorButton];
    ////////////////////////////////////////////////////////////////////////////////////////////////
        
    // Notify a delegate object
    // generatePersonToQueue method did successfully generate a person ////////////
    if ( [delegate respondsToSelector:@selector(personGeneratorDidGeneratePerson:)] ) {
        [delegate personGeneratorDidGeneratePerson:person];    
    }
    ///////////////////////////////////////////////////////////////////////////////
    
    // In a managed memory environment, when an object is removed from a mutable array it receives a release message

    return YES;
}


// Implement the accessor methods
- (id)delegate {
    return delegate;
}
- (void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}
//////////////////////////////////////

@end

////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PersonGenerator(Rush)

- (unsigned) iFloorWithZeroFloorProbability:(float)prob;
{
    unsigned iFloor=0;
    // iFloor maximum probability for morning time
    // 0.8% - 0 floor
    // 0.2% - else
    
    // 0-80   - 0 floor
    // 81-99 - 1--building.floorsNumber
    //0--100
    unsigned restFloors = building.floorsNumber - 1;
    float probabilityStep = (100-(prob*100)) / restFloors;
    float step = prob*100;
    
    int randArrIndx = arc4random() % 100;
    if (randArrIndx < (prob*100)) 
        iFloor = 0;
    else {        
        iFloor = 1;
        while (step<randArrIndx) {
            step += probabilityStep;
            iFloor++;
        }
        iFloor--;
    }

    return iFloor;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PersonGenerator(Gauss) 

// Probability Density Function (pdf)
- (double) gaussianPDFx: (double)x AndMu:(double)u AndSqrSigma:(double)sqSigma
{
    // Mu - mean (shift)
    // sqSigma - variance ()
    
    // Normal distribution
    // is known as the Gaussian function or bell curve
    
    sqSigma = fabs(sqSigma);
    
    double expr = pow((x-u),2)/sqSigma; 
    double p = (1/
                (sqrt(2*M_PI*sqSigma))) * exp(-expr/2);    
    return p;
}

- (void) fillArrays {
    double normalDistributionStartX = -3;
    double normalDistributionStopX  = 3;
    double step = 0.1; 
    
    gaussianElmts = (fabs(normalDistributionStartX) + fabs(normalDistributionStopX))/step;
    int personWeightStep = (MAX_PERSON_WEIGHT - MIN_PERSON_WEIGHT)/gaussianElmts;
        
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Fill Person weight array //
    weightArray = malloc((gaussianElmts)*sizeof(int));
    
    int weight=MIN_PERSON_WEIGHT;
    int i=0;
    while (weight<MAX_PERSON_WEIGHT) {
        weightArray[i] = weight;
        //NSLog(@"weight[%i] = %i", i, weightArray[i]);
        weight+=personWeightStep;
        i++;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    // PDF
    //NSLog(@"Normal distribution");
    
    double normalDistributionPDF;
    double normalPoint = normalDistributionStartX;
    i=0;
    
    occuranceArray = malloc((gaussianElmts)*sizeof(double));
    
    int occuranceSum = 0;
    while (normalPoint < normalDistributionStopX) {
        normalDistributionPDF = [self gaussianPDFx:normalPoint AndMu:0 AndSqrSigma:1];
        
        // Probability = integral
        double probability = step * normalDistributionPDF;
        // occurance
        occuranceArray[i] = probability * PEOPLE_GENERATION_CYCLE;
        occuranceSum += occuranceArray[i];
        
        //NSLog(@"weightArray[%i]=%i, occuranceArray[%i]=%i", i, weightArray[i], i, occuranceArray[i]);
        
        i++;
        normalPoint+=step;
    }
    
    // GENERATE NUMBERS 0--GENERATION_CYCLE but minus occuranceSum
    queueTail = PEOPLE_GENERATION_CYCLE - occuranceSum;
    //NSLog(@"array: 0--%i", GENERATION_CYCLE-queueTail);
}

- (unsigned) generateWeightByGaussianPDF 
{
    /*
    for(int i=0; i<gaussianElmts; i++)
        NSLog(@"weightArray[%i]=%i, occuranceArray[%i]=%i", i, weightArray[i], i, occuranceArray[i]);
    */
    
    int maxIndx = (PEOPLE_GENERATION_CYCLE - queueTail);
    //NSLog(@"Max indx = %i", maxIndx);
    int randomIndx = arc4random() % maxIndx;    
    //NSLog(@"Random indx = %i", randomIndx);
    
    // Find weight
    int weightIndx = 0;
    int i=0;
    while (weightIndx < randomIndx) {
        weightIndx += occuranceArray[i];        
        i++;
    }
    i--;
    
    //NSLog(@"Gaussian random weight = %i", weightArray[i]);
    
    return weightArray[i];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PersonGenerator(Tst)

- (void) tstGenerateWeight 
{
    NSLog(@"[PersonGenerator tstGenerateWeight]");
    
    // TEST weight generation.
    int tstArr[60] = {0};
    for (int i=0; i<1000; i++) {
        int indx = [self generateWeightByGaussianPDF]-60;
        //NSLog(@"indx=%i", indx);
        tstArr[indx]++; 
    }
    
    for (int i=0; i<60; i++) 
        NSLog(@"[%i]=%i", i, tstArr[i]);
    
}

- (void) tstIFloorForMorningRush
{
    NSLog(@"iFloorForMorningRush = %i", [self iFloorWithZeroFloorProbability:50]);
}

- (void) tstGenerateCustomPeople
{
    NSLog(@"Generate custom people set.");
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    /*
    // In a managed memory environment, an object receives a retain message when it’s added // retain=+1
    Person *person1 = [[Person alloc] initWithInitialFloor:5 AndDesiredFloor:9 AndWeight:81];
    Person *person2 = [[Person alloc] initWithInitialFloor:5 AndDesiredFloor:0 AndWeight:82];    
    NSMutableSet *peopleQueueOnEachFloor = [building.peopleQueuesOnEachFloor objectAtIndex:5];
     
    [peopleQueueOnEachFloor addObject:person1];
    [peopleQueueOnEachFloor addObject:person2];
    [person1 pushFloorButton];
    [person2 pushFloorButton];
    // In a managed memory environment, when an object is removed from a mutable array it receives a release message
    [person1 release];
    [person2 release];
     */
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    Person *person1 = [[Person alloc] initWithInitialFloor:0 AndDesiredFloor:8 AndWeight:81];
    Person *person2 = [[Person alloc] initWithInitialFloor:6 AndDesiredFloor:2 AndWeight:82];    
    Person *person3 = [[Person alloc] initWithInitialFloor:9 AndDesiredFloor:0 AndWeight:83];    
    Person *person4 = [[Person alloc] initWithInitialFloor:6 AndDesiredFloor:9 AndWeight:84];    
    
    
    NSMutableSet *peopleQueueOnEachFloor1 = [building.peopleQueuesOnEachFloor objectAtIndex:0];
    NSMutableSet *peopleQueueOnEachFloor2 = [building.peopleQueuesOnEachFloor objectAtIndex:6];
    NSMutableSet *peopleQueueOnEachFloor3 = [building.peopleQueuesOnEachFloor objectAtIndex:9];
    
    [peopleQueueOnEachFloor1 addObject:person1];
    [peopleQueueOnEachFloor2 addObject:person2];
    [peopleQueueOnEachFloor3 addObject:person3];
    [peopleQueueOnEachFloor2 addObject:person4];
    
    [person1 pushFloorButton];
    [person2 pushFloorButton];
    [person3 pushFloorButton];
    [person4 pushFloorButton];
    
     
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
}

@end

