//
//  Defines.h
//  EducationUI2
//
//  Created by Sergey Nikolsky on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef EducationUI2_Defines_h
#define EducationUI2_Defines_h


#endif

//#define DEBUG_ELEVATOR 1

#define MYDEBUG 0



///// Building size /////////////////////
//gap + ElevatorShaft + FloorButtonPanels + Floors + gap = 1.0f
#define FRAME_GAP_PERC .02f
#define ELEVATOR_SHAFT_PERC .47f
#define FLOOR_BUTTON_PANELS_PERC .08f
#define FLOOR_PERC .43f
/////////////////////////////////////////

#define ELEVATORS_NUMBER 1
#define FLOORS_NUMBER 15
#define MAX_PEOPLE_IN_EACH_QUEUE 10
#define MIN_PERSON_WEIGHT 60
#define MAX_PERSON_WEIGHT 120
#define PEOPLE_GENERATION_CYCLE 10000

#define TIME_BEFORE_RUN_ELEVATORS 1000000
#define TIME_BETWEEN_PEOPLE_GENERATIONG 4000000

#define DIVISOR 1
#define ELEVATOR_TIME_TO_PASS_ONE_FLOOR 500000/DIVISOR
#define ELEVATOR_TIME_TO_OPEN_THE_DOORS 200000/DIVISOR
#define ELEVATOR_TIME_TO_CLOSE_THE_DOORS 200000/DIVISOR
#define TIME_TO_ADD_PERSON_TO_ELEVATOR 200000/DIVISOR
#define TIME_TO_REMOVE_PERSON_FROM_ELEVATOR 200000/DIVISOR
#define TIME_TO_GENERATE_5_PEOPLE 5000000/DIVISOR


