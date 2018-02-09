//
//  AutocorrectTests.m
//  KIF Tests
//
//  Created by Harley Cooper on 2/7/18.
//

#import <KIF/KIF.h>

#import "KIFTextInputTraitsOverrides.h"

@interface AutocorrectTests : KIFTestCase
@end

@implementation AutocorrectTests

+ (void)setUp
{
    [super setUp];

    KIFTextInputTraitsOverrides.allowDefaultAutocorrectBehavior = YES;
    KIFTextInputTraitsOverrides.allowDefaultSmartDashesBehavior = YES;
    KIFTextInputTraitsOverrides.allowDefaultSmartQuotesBehavior = YES;
}

+ (void)tearDown
{
    [super tearDown];

    KIFTextInputTraitsOverrides.allowDefaultAutocorrectBehavior = NO;
    KIFTextInputTraitsOverrides.allowDefaultSmartDashesBehavior = NO;
    KIFTextInputTraitsOverrides.allowDefaultSmartQuotesBehavior = NO;
}

- (void)beforeEach
{
    [tester tapViewWithAccessibilityLabel:@"Tapping"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testClearingAndEnteringTypoIntoViewWithAccessibilityLabel
{
    [[tester validateEnteredText:NO] clearTextFromAndThenEnterText:@" jkasd " intoViewWithAccessibilityLabel:@"Greeting"];
    [tester waitForAbsenceOfViewWithValue:@" jkasd "];
}

// These tests won't work on any version of iOS before iOS 11.
#ifdef __IPHONE_11_0
- (void)testClearingAndEnteringQuotesIntoViewWithAccessibilityLabel
{
    [tester clearTextFromAndThenEnterText:@"'\"'," intoViewWithAccessibilityLabel:@"Greeting" traits:UIAccessibilityTraitNone expectedResult:@"’”’,"];
}

- (void)testClearingAndEnteringDashesIntoViewWithAccessibilityLabel
{
    [tester clearTextFromAndThenEnterText:@"--a" intoViewWithAccessibilityLabel:@"Greeting" traits:UIAccessibilityTraitNone expectedResult:@"—a"];
}
#endif
@end
