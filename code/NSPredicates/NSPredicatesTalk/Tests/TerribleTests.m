//
//  TerribleTests.m
//  NSPredicatesTalk
//
//  Created by Josh Smith on 10/26/12.
//  Copyright (c) 2012 Josh Smith. All rights reserved.
//

#import "TerribleTests.h"
#import "ThisIsReallyTerrible.h"
#import "NotReallyTerrible.h"

@interface TerribleTests ()
@property (strong) ThisIsReallyTerrible *terrible;
@property (strong) NotReallyTerrible *notterrible;
@property (strong) NSArray *truestrings;
@property (strong) NSArray *falsestrings;
@end

@implementation TerribleTests

- (void)setUp
{
    [super setUp];
    self.terrible = [[ThisIsReallyTerrible alloc] init];
    self.notterrible = [[NotReallyTerrible alloc] init];
    self.truestrings = @[ @"CH1hello",@"CH00"];
    self.falsestrings = @[ @"CH1hello ",@"HH1hello", @"CH", @"CHbroken1",
                                    @"CHaaafdddddddsssajjajjajfjfjjajfjajjf1"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testIsThisTerrible
{
    [self.truestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertTrue([self.terrible thisIsTerrible:obj], @"This should be true");
         XCTAssertTrue([self.notterrible predicatesTIT:obj], @"This is better");
         XCTAssertTrue([self.notterrible predicatesTITshort:obj], @"This is better");
     }
     ];

    [self.falsestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertFalse([self.terrible thisIsTerrible:obj], @"This should be false");
         XCTAssertFalse([self.notterrible predicatesTIT:obj], @"This should be false");
         XCTAssertFalse([self.notterrible predicatesTITshort:obj], @"This should be false");
     }
     ];
}

- (void) testIsThisReallyTerrible {
    [self.truestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertTrue([self.terrible thisIsReallyTerrible:obj], @"This should be true");
         XCTAssertTrue([self.notterrible predicatesTIRT:obj], @"This should be true");
     }
     ];
    
    [self.falsestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertFalse([self.terrible thisIsReallyTerrible:obj], @"This should be false");
         XCTAssertFalse([self.notterrible predicatesTIRT:obj], @"This should be false");
     }
     ];
    
    XCTAssertTrue([self.terrible thisIsReallyTerrible:@"HCbroken1"], @"Yep, it works");
    XCTAssertTrue([self.notterrible predicatesTIRT:@"HCbroken1"], @"This should be true");
    XCTAssertFalse([self.terrible thisIsReallyTerrible:@"HCbroken"], @"Yep, it works");
    XCTAssertFalse([self.notterrible predicatesTIRT:@"HCbroken"], @"This should be false");
}
@end
