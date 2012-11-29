//
//  RootViewController.m
//  EducationUI2
//
//  Created by Sergey Nikolsky on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

#import "Building.h"
#import "PersonGenerator.h"
#import "Elevator.h"

#import "Person.h"
#import "Defines.h"

//Custom Layers
#import "PersonLayer.h"
#import "BuildingGridLayer.h"
#import "FloorButtonPanelLayer.h"

@interface RootViewController(privateMethods)


- (void)addElevatorCustomAnimationForLayer:(CALayer *)layer 
                                   toPoint:(CGPoint)point
                              withUDuration:(CGFloat)duration;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Person animation
// Add anim
- (void) animationToAddPersonLayer:(CALayer *)layer 
                   toElevatorLayer:(CALayer *)superLayer
                           toPoint:(CGPoint)point 
                     withBeginTime:(CGFloat)beginTime
                      withUDuration:(CGFloat)duration;
// Remove anim
- (void) animationToRemovePersonLayer:(CALayer *)layer 
           andAddtoElevatorSuperLayer:(CALayer *)superLayer
                              toPoint:(CGPoint)point 
                        withBeginTime:(CGFloat)beginTime
                         withUDuration:(CGFloat)duration;

//dismiss layer
- (void) animationToDismissPersonLayer:(CALayer *)layer 
                          withDuration:(CGFloat)duration;

//appear
- (void) animationToAppearPersonLayer:(CALayer *)layer 
                         withDuration:(CGFloat)duration;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (UIColor *)randomColor;
- (void) runLogic;
- (void) runGenerator;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation RootViewController

@synthesize peopleLayersQueuesOnEachFloor;

/////////////////////////////////////////////////////////////////////////////////




///////////// for FloorButtonPanel /////////////////////////////////////////////

// in ElevatorDelegate
- (void) elevatorWillDropUpButtonOnFloor:(unsigned)floor
{
    //NSLog(@"\t\televatorWillDropUpButtonOnFloor: floor=%u", floor);
    if (floorButtonPanels) {
        FloorButtonPanelLayer *tmpPanel = [floorButtonPanels objectAtIndex:floor];
        [tmpPanel dropUpButton];
    }
}
- (void) elevatorWillDropDownButtonOnFloor:(unsigned)floor
{
    //NSLog(@"\t\televatorWillDropDownButtonOnFloor: floor=%u", floor);
    if (floorButtonPanels) {
        FloorButtonPanelLayer *tmpPanel = [floorButtonPanels objectAtIndex:floor];
        [tmpPanel dropDownButton];
    }
}
// in PersonDelegate
- (void) personWillPushUpButtonOnFloor:(unsigned)floor
{
    //NSLog(@"\t\tpersonWillPushUpButtonOnFloor: floor=%u", floor);
    if (floorButtonPanels) {
        FloorButtonPanelLayer *tmpPanel = [floorButtonPanels objectAtIndex:floor];
        [tmpPanel pressUpButton];
    }
}
- (void) personWillPushDownButtonOnFloor:(unsigned)floor
{
    //NSLog(@"\t\tpersonWillPushDownButtonOnFloor: floor=%u", floor);
    if (floorButtonPanels) {
        FloorButtonPanelLayer *tmpPanel = [floorButtonPanels objectAtIndex:floor];
        [tmpPanel pressDownButton];
    }
}
/////////////////////////////////////////////////////////////////////////////////




///////////// implementation of PersonGeneratorDelegate methods ////////////////////////////////////
-(void) personGeneratorDidGeneratePerson:(Person *)person
{
    NSLog(@"\tpersonGeneratorDidGeneratePerson: new Person (%u->%u)", person.initialFloor, person.desiredFloor);
    
    //draw PersonLayer
    PersonLayer *personLayer = [[PersonLayer alloc] 
                                initWithHeight:buildingGridLayer.oneFloorHeight 
                               andDesiredFloor:person.desiredFloor];
    
    [CATransaction flush];
    [CATransaction begin];
    
    [CATransaction setDisableActions:YES];
    [self.view.layer addSublayer:personLayer];
    personLayer.position = [buildingGridLayer randomPositionForPersonWithWidth:personLayer.bounds.size.width 
                                                                       onFloor:person.initialFloor]; 
    [CATransaction commit];
    
    //"fades in" and when you remove "fades out"
    // Person appears... //////////////////////////////////////////////////////////////////////////////////////////
    [self animationToAppearPersonLayer:personLayer 
                          withDuration:.2f];
    //personLayer.opacity = 1.0f;
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    

     //coping an object: person
    [peopleLayers setObject:personLayer forKey:person];   

}

///////////// implementation of ElevatorDelegate methods ////////////////////////////////////
- (void) elevatorWillOpenDoors
{
    //NSLog(@"elevatorWillOpenDoors");
}
- (void) elevatorWillCloseDoors
{
    //NSLog(@"elevatorWillCloseDoors");
}
- (void) elevatorWillMoveToTheFloor:(unsigned)floor
{
    //NSLog(@"\t\televatorWillMoveToTheFloor:%i (animate Elevator)", floor);
    
    //start elevator animation
    [self addElevatorCustomAnimationForLayer:elevatorLayer
                                     toPoint:[buildingGridLayer positionForElevatorOnFloor:floor]
                               withUDuration:ELEVATOR_TIME_TO_PASS_ONE_FLOOR];
}

///////////// implementation of BuildingDelegate methods ////////////////////////////////////
-(void)buildingWillAddPerson:(Person *)person toElevator:(Elevator *)elevator
{
    NSLog(@"buildingWillAddPerson:toElevator:\t\t\t [%u]+(%u->%u)", elevator.currentFloor, person.initialFloor, person.desiredFloor);
    
    PersonLayer *personLayer = [peopleLayers objectForKey:person];
    [self animationToAddPersonLayer:personLayer 
                    toElevatorLayer:elevatorLayer
                            toPoint:[buildingGridLayer randomPositionForPersonWithWidth:personLayer.frame.size.width
                                                                      inElevatorOnFloor:person.initialFloor]
                      withBeginTime:0.0f
                       withUDuration:TIME_TO_ADD_PERSON_TO_ELEVATOR];
}
-(void)buildingWillRemovePerson:(Person *)person fromElevator:(Elevator *)elevator
{
    NSLog(@"buildingWillRemovePerson:fromElevator:\t [%u]X(%u->%u)", elevator.currentFloor, person.initialFloor, person.desiredFloor);
    
    PersonLayer *personLayer = [peopleLayers objectForKey:person];
    //Removes a given key and its associated value from the dictionary
    [peopleLayers removeObjectForKey:person];
    
    [self animationToRemovePersonLayer:personLayer
            andAddtoElevatorSuperLayer:elevatorLayer.superlayer
                               toPoint:[buildingGridLayer randomPositionForPersonWithWidth:personLayer.frame.size.width 
                                                                                   onFloor:person.desiredFloor]
                         withBeginTime:0.0f
                          withUDuration:TIME_TO_REMOVE_PERSON_FROM_ELEVATOR];
}
/////////////////////////////////////////////////////////////////////////////////

+ (UIColor *)randomColor
{
    int red = arc4random() % 255;
    int green = arc4random() % 255;
    int blue = arc4random() % 255;
    //NSLog(@"R,G,B = (%i,%i,%i)", red, green, blue);
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

#pragma mark - runLogic
- (void) runLogic
{
    NSLog(@"---Logic started in thread -(void)runLogic ---");
    [building runElevators];
    NSLog(@"---Thread runLogic stopped.---");
    
    
}

#pragma mark - runGenerator
- (void) runGenerator
{
    
    //replace it !!!!
    //[self performSelector:@selector(runGenerator) withObject:nil afterDelay:TIME_BEFORE_GENERATE_5_PEOPLE/1000000];
    
    while (YES) {
        [CATransaction flush];
        [CATransaction begin];
        for (int i=0; i<4; i++) 
            [personGenerator generatePersonToQueue];
        [CATransaction commit];
        
        usleep(TIME_TO_GENERATE_5_PEOPLE);
    }
    
}

+ (NSString *)classTitle {
    return @"This is my Elevator animation RootViewController";
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Animations



- (void)addElevatorCustomAnimationForLayer:(CALayer *)layer 
                                   toPoint:(CGPoint)point
                              withUDuration:(CGFloat)duration
{
    if (nil == layer)
        return;
    
    NSLog(@"addElevatorCustomAnimationForLayer:toPoint:withUDuration:");
    
    // Is this background or main thread ?
    
    CGPoint currentPosition = layer.position;
	CGPoint newPosition = point;
    
    [CATransaction flush];
    [CATransaction begin];
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    layer.position = point;
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = (CGFloat)duration / 1000000;
    positionAnimation.fromValue = [NSValue valueWithCGPoint:currentPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    //performSelectorOnMainThread:withObject:waitUntilDone:modes:
    //[self performSelectorOnMainThread:@"test" withObject:nil waitUntilDone:NO];
    
    // NOT A MAIN THREAD
    [layer addAnimation:positionAnimation forKey:@"position"];
    
    
    [CATransaction commit];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) animationToAddPersonLayer:(CALayer *)layer
                   toElevatorLayer:(CALayer *)superLayer
                           toPoint:(CGPoint)point
                     withBeginTime:(CGFloat)beginTime
                      withUDuration:(CGFloat)duration
{
    if (nil == layer)
        return;
    if (nil == superLayer)
        return;
    
    duration = (CGFloat)duration / 1000000;
    
    [CATransaction flush];
    [CATransaction begin];
    
    ////////// CompletionBlock ////////////////////////////////
    [CATransaction setCompletionBlock:^{
        //10.02.2012 new logic by "QuarzUtils.h"
        RemoveImmediately(layer);
        ChangeSuperlayer(layer, superLayer, 0);
        
        [CATransaction setDisableActions:YES];
        //Converts the point from the receiver’s coordinate system to the specified layer’s coordinate system.
        layer.position = [self.view.layer convertPoint:point toLayer:superLayer];
    }];
    ///////////////////////////////////////////////////////////
    
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.beginTime = beginTime;
    moveAnimation.duration  = duration;    
	moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:layer.position];
    moveAnimation.toValue = [NSValue valueWithCGPoint:point];
        
    ////////////////////////////////////////////////////////////
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:moveAnimation, nil];
    group.duration  = moveAnimation.beginTime + moveAnimation.duration;
    ////////////////////////////////////////////////////////////
    
    [layer addAnimation:group forKey:nil];
    [CATransaction commit];
}

///////////////////////////////////////////////////////////////
- (void) animationToRemovePersonLayer:(CALayer *)layer
           andAddtoElevatorSuperLayer:(CALayer *)superLayer
                              toPoint:(CGPoint)point
                        withBeginTime:(CGFloat)beginTime
                         withUDuration:(CGFloat)duration
{
    if (nil == layer)
        return;
    
    duration = (CGFloat)duration / 1000000;
    
    //inside Elevator
    CGPoint currentPosition = layer.position;
    //inside superLayer
    
    
    //transoform newPosition to layer.superlayer coords
	CGPoint newPosition = point;
    newPosition = CGPointMake(newPosition.x - layer.superlayer.position.x + layer.superlayer.bounds.size.width / 2.0,
                              newPosition.y - layer.superlayer.position.y + layer.superlayer.bounds.size.height / 2.0);
    
    
    [CATransaction flush];
    [CATransaction begin];
    ////////// CompletionBlock ////////////////////////////////
    [CATransaction setCompletionBlock:^{     
        
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        [layer removeFromSuperlayer];
        [CATransaction commit];
        

        //////
        [CATransaction setDisableActions:YES];
        layer.position = point;
        ///
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        [superLayer addSublayer:layer];
        [CATransaction commit];
        
        //opacity
        [self animationToDismissPersonLayer:layer
                              withDuration:2.0f];
        
    }];
    ///////////////////////////////////////////////////////////
    
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.beginTime = beginTime;
    moveAnimation.duration  = duration;    
	moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:currentPosition];
    moveAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
    
    ////////////////////////////////////////////////////////////
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:moveAnimation, nil];
    group.duration  = moveAnimation.beginTime + moveAnimation.duration;
    ////////////////////////////////////////////////////////////
    
    [layer addAnimation:group forKey:nil];
    [CATransaction commit];
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) animationToDismissPersonLayer:(CALayer *)layer 
                         withDuration:(CGFloat)duration
{
    //used by animationToRemovePersonLayeropacity

    [CATransaction flush];
    [CATransaction begin];
    ////////// CompletionBlock ////////////////////////////////
    [CATransaction setCompletionBlock:^{
        RemoveImmediately(layer);
    }];
    ///////////////////////////////////////////////////////////

    
    [CATransaction setDisableActions:NO];
    [CATransaction setValue:[NSNumber numberWithFloat:duration]
                     forKey:kCATransactionAnimationDuration];
    layer.opacity = 0.0f;
    [CATransaction commit];
    
    //[self performSelector: @selector(removeFromSuperlayer) withObject: nil afterDelay: 1.0];
}

- (void) animationToAppearPersonLayer:(CALayer *)layer 
                          withDuration:(CGFloat)duration
{
    
    [CATransaction flush];
    [CATransaction begin];
    // Person appears... //////////////////////////////////////////////////////////////////////////////////////////
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = duration;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    opacityAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:opacityAnimation forKey:nil];
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    [CATransaction commit];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = [[self class] classTitle];
                
        peopleLayers = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    NSLog(@"loadView");
    
    UIView* view =
    [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
    
   
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    
    
    //////// Elevator model ///////////////////////////////////////////////////////////
    building = [Building sharedBuilding];
    building.delegate = self;
    //[building tstInit];
    
    personGenerator = [PersonGenerator sharedPersonGenerator];
    personGenerator.delegate = self;
    
    //retain elevator
    NSArray *elevators = [building.elevators copyWithZone:nil];
    Elevator *elevator = [elevators objectAtIndex:0];
    elevator.delegate = self;
    ///////////////////////////////////////////////////////////////////////////////////
    
    
    ///////////////////////////////////////////////////////////////////////////////////
    buildingGridLayer = [BuildingGridLayer layer];
    buildingGridLayer.bounds = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    buildingGridLayer.position = self.view.layer.position;
    [self.view.layer addSublayer:buildingGridLayer];
    
    
    /////////////////////////////////////////////////////////////////////////////
    //*
    NSMutableArray *mutableFloorButtonPanels = [[NSMutableArray alloc] init];
    CGRect panelBounds = CGRectMake(0, 0, buildingGridLayer.floorButtonPanelsWidth, buildingGridLayer.oneFloorHeight);
    
    FloorButtonPanelLayer *lowestPanel = 
    [[FloorButtonPanelLayer alloc] initWithBounds:panelBounds 
                                     withUpButton:YES 
                                andWithDownButton:NO];
    lowestPanel.position = [buildingGridLayer positionForFloorButtonPanelOnFloor:0];
    [mutableFloorButtonPanels addObject:lowestPanel];
    [buildingGridLayer addSublayer:lowestPanel];
    
    for (int i=1; i<FLOORS_NUMBER-1; i++) {
        FloorButtonPanelLayer *panel = 
        [[FloorButtonPanelLayer alloc] initWithBounds:panelBounds 
                                         withUpButton:YES 
                                    andWithDownButton:YES];
        panel.position = [buildingGridLayer positionForFloorButtonPanelOnFloor:i];
    
        [mutableFloorButtonPanels addObject:panel];
        [buildingGridLayer addSublayer:panel];
    }
    FloorButtonPanelLayer *highestPanel = 
    [[FloorButtonPanelLayer alloc] initWithBounds:panelBounds 
                                     withUpButton:NO 
                                andWithDownButton:YES];
    highestPanel.position = [buildingGridLayer positionForFloorButtonPanelOnFloor:FLOORS_NUMBER-1];
    [mutableFloorButtonPanels addObject:highestPanel];
    [buildingGridLayer addSublayer:highestPanel];
    
    
    
    
    floorButtonPanels = [[NSArray alloc] initWithArray:mutableFloorButtonPanels];
    //*/
     
    [buildingGridLayer setNeedsDisplay];
    ///////////////////////////////////////////////////////////////////////////////////
        
    //// retain to use it later ///////////////////////////////////////////////////////
    elevatorLayer = [CALayer layer];
    elevatorLayer.bounds = buildingGridLayer.elevatorBounds;
    elevatorLayer.cornerRadius = 10.0f;
    elevatorLayer.position = [buildingGridLayer positionForElevatorOnFloor:0];
    elevatorLayer.backgroundColor = [[UIColor redColor] CGColor];
    elevatorLayer.opacity = 1.0f;

    //Elevator shadow
    //*
    elevatorLayer.shadowColor = [[UIColor blackColor] CGColor];
    elevatorLayer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    elevatorLayer.shadowOpacity = 1.0;
    elevatorLayer.shadowRadius = 5.0f;
    //*/
    
    
    //CALayer *elevatorUpDoor = [CALayer layer];
    
    
    
    [self.view.layer addSublayer:elevatorLayer];
    ///////////////////////////////////////////////////////////////////////////////////
    
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear:");
    
   
    //RUN FOREST RUN
    [self performSelectorInBackground:@selector(runGenerator) withObject:nil];
    [self performSelectorInBackground:@selector(runLogic) withObject:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear:");
    
#if MYDEBUG
    NSLog(@"MYDEBUG=1");
#else
    NSLog(@"MYDEBUG=...");
#endif
    
}

- (void)viewWillDisappear:(BOOL)animated 
{
    elevatorLayer.delegate = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc {

     elevatorLayer = nil;
     buildingGridLayer = nil;
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
