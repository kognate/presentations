//
//  CFTree.m
//  NSCollectionsTalk
//
//  Created by Josh Smith on 9/26/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CFTree : XCTestCase

@end

@implementation CFTree

- (void)testExample
{
    CFTreeContext ctx;
    ctx.version = 0;
    ctx.info = (void *)"Hello Tree!";
    
    CFTreeRef tree = CFTreeCreate(CFAllocatorGetDefault(), &ctx);
    
    CFTreeContext fc_ctx;
    fc_ctx.version = 0;
    fc_ctx.info = (void *)"First Child";
    CFTreeRef first_child = CFTreeCreate(CFAllocatorGetDefault(), &fc_ctx);
    
    CFTreeAppendChild(tree, first_child);
    XCTAssertTrue(CFTreeGetChildCount(tree) == 1, @"should have one child");
    
    CFTreeContext sc_ctx;
    sc_ctx.version = 0;
    sc_ctx.info = (void *)"Second Child, Sibling";
    
    CFTreeRef second_child = CFTreeCreate(CFAllocatorGetDefault(), &sc_ctx);
    CFTreeAppendChild(tree, second_child);

    CFTreeRef found_child;
    CFTreeContext find_ctx;
    
    found_child = CFTreeGetFirstChild(tree);
    CFTreeGetContext(found_child, &find_ctx);
    
    XCTAssert(strcmp("First Child", find_ctx.info) == 0, @"Correct String");
    
    CFTreeRef second_found_child;
    CFTreeContext sfc_ctx;
    
    second_found_child = CFTreeGetNextSibling(found_child);
    CFTreeGetContext(second_found_child, &sfc_ctx);
    
    XCTAssert(strcmp("Second Child, Sibling", sfc_ctx.info) == 0, @"Correct String");
    
    CFTreeRef not_found;
    not_found = CFTreeGetNextSibling(second_found_child);
    XCTAssertTrue(not_found == NULL, @"There is no next child");
    CFRelease(tree);
}

@end
