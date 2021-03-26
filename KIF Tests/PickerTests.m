#import <KIF/KIF.h>

@interface PickerTests : KIFTestCase
@end

@implementation PickerTests

- (void)beforeEach
{
    [tester tapViewWithAccessibilityLabel:@"Pickers"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testSelectingDateInPast
{
    [tester tapViewWithAccessibilityLabel:@"Date Selection"];
    NSArray *date = @[@"June", @"17", @"1965"];
    // If the UIDatePicker LocaleIdentifier would be de_DE then the date to set
    // would look like this: NSArray *date = @[@"17.", @"Juni", @"1965"
    [tester selectDatePickerValue:date];
    [tester waitForViewWithAccessibilityLabel:@"Date Selection" value:@"Jun 17, 1965" traits:UIAccessibilityTraitNone];
}

- (void)testSelectingDateInFuture
{
    [tester tapViewWithAccessibilityLabel:@"Date Selection"];
    NSArray *date = @[@"December", @"31", @"2030"];
    [tester selectDatePickerValue:date];
    [tester waitForViewWithAccessibilityLabel:@"Date Selection" value:@"Dec 31, 2030" traits:UIAccessibilityTraitNone];
}

- (void)testSelectingDateTime
{
    [tester tapViewWithAccessibilityLabel:@"Date Time Selection"];
    NSArray *dateTime = @[@"Jun 17", @"6", @"43", @"AM"];
    [tester selectDatePickerValue:dateTime];
    [tester waitForViewWithAccessibilityLabel:@"Date Time Selection" value:@"Jun 17, 06:43 AM" traits:UIAccessibilityTraitNone];
}

- (void)testSelectingDateTimeBackwards
{
    [tester tapViewWithAccessibilityLabel:@"Date Time Selection"];
    NSArray *dateTime = @[@"Jun 17", @"6", @"43", @"AM"];
    [tester selectDatePickerValue:dateTime withSearchOrder:KIFPickerSearchBackwardFromEnd];
    [tester waitForViewWithAccessibilityLabel:@"Date Time Selection" value:@"Jun 17, 06:43 AM" traits:UIAccessibilityTraitNone];
}

- (void)testSelectingDateTimeFromCurrentBackwards
{
    [tester tapViewWithAccessibilityLabel:@"Limited Date Time Selection"];
    NSArray *dateTime = @[@"Jun 17", @"6", @"43", @"AM"];
    // Since Limited Date Picker Time had a minimum date, default search order from start will fail.
    [tester selectDatePickerValue:dateTime withSearchOrder:KIFPickerSearchBackwardFromCurrentValue];
    [tester waitForViewWithAccessibilityLabel:@"Limited Date Time Selection" value:@"Jun 17, 06:43 AM" traits:UIAccessibilityTraitNone];
}

- (void)testSelectingDateTimeFromCurrentForwards
{
    [tester tapViewWithAccessibilityLabel:@"Limited Date Time Selection"];
    NSArray *dateTime = @[@"Jun 17", @"6", @"43", @"AM"];
    // Since Limited Date Picker Time had a maximum date, From End Backwards will fail too.
    [tester selectDatePickerValue:dateTime withSearchOrder:KIFPickerSearchForwardFromCurrentValue];
    [tester waitForViewWithAccessibilityLabel:@"Limited Date Time Selection" value:@"Jun 17, 06:43 AM" traits:UIAccessibilityTraitNone];
}

- (void)testSelectingCurrentDateTime
{
    [tester tapViewWithAccessibilityLabel:@"Date Time Selection"];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-360];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh mm a";
    NSArray *dateValues = [@[@"Today"] arrayByAddingObjectsFromArray:[[dateFormatter stringFromDate:date] componentsSeparatedByString:@" "]];
    dateFormatter.dateFormat = @"MMM d, hh:mm a";
    NSString *expectedDate = [dateFormatter stringFromDate:date];
    [tester selectDatePickerValue:dateValues];
    [tester waitForViewWithAccessibilityLabel:@"Date Time Selection" value:expectedDate traits:UIAccessibilityTraitNone];
}

- (void)testSelectingTodayAt12pm
{
    [tester tapViewWithAccessibilityLabel:@"Date Time Selection"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: [NSDate date]];
    [components setHour: 12];
    NSDate *date = [gregorian dateFromComponents: components];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh mm a";
    NSArray *dateValues = [@[@"Today"] arrayByAddingObjectsFromArray:[[dateFormatter stringFromDate:date] componentsSeparatedByString:@" "]];
    dateFormatter.dateFormat = @"MMM d, hh:mm a";
    NSString *expectedDate = [dateFormatter stringFromDate:date];
    [tester selectDatePickerValue:dateValues];
    [tester waitForViewWithAccessibilityLabel:@"Date Time Selection" value:expectedDate traits:UIAccessibilityTraitNone];
}

- (void)testSelectingTime
{
    [tester tapViewWithAccessibilityLabel:@"Time Selection"];
    NSArray *time = @[@"7", @"44", @"AM"];
    [tester selectDatePickerValue:time];
    [tester waitForViewWithAccessibilityLabel:@"Time Selection" value:@"7:44 AM" traits:UIAccessibilityTraitNone];
}


- (void)testSelectingCountdown
{
    [tester tapViewWithAccessibilityLabel:@"Countdown Selection"];
    NSArray *countdown = @[@"4", @"10"];
    [tester selectDatePickerValue:countdown];
    [tester waitForViewWithAccessibilityLabel:@"Countdown Selection" value:@"15000.000000" traits:UIAccessibilityTraitNone];
}

- (void)testSelectingAPickerRow
{
    [tester selectPickerViewRowWithTitle:@"Echo"];
    
    NSOperatingSystemVersion iOS8 = {8, 0, 0};
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS8]) {
        [tester waitForViewWithAccessibilityLabel:@"Call Sign" value:@"Echo" traits:UIAccessibilityTraitNone];
    } else {
        [tester waitForViewWithAccessibilityLabel:@"Call Sign" value:@"Echo. 5 of 14" traits:UIAccessibilityTraitNone];
    }

    [tester selectPickerViewRowWithTitle:@"Golf"];

    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS8]) {
        [tester waitForViewWithAccessibilityLabel:@"Call Sign" value:@"Golf" traits:UIAccessibilityTraitNone];
    } else {
        [tester waitForViewWithAccessibilityLabel:@"Call Sign" value:@"Golf. 7 of 14" traits:UIAccessibilityTraitNone];
    }

    [tester selectPickerViewRowWithTitle:@"Alpha"];

    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS8]) {
        [tester waitForViewWithAccessibilityLabel:@"Call Sign" value:@"Alpha" traits:UIAccessibilityTraitNone];
    } else {
        [tester waitForViewWithAccessibilityLabel:@"Call Sign" value:@"Alpha. 1 of 14" traits:UIAccessibilityTraitNone];
    }

    [tester selectPickerViewRowWithTitle:@"N8117U"];

    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS8]) {
        [tester waitForViewWithAccessibilityLabel:@"Call Sign" value:@"N8117U" traits:UIAccessibilityTraitNone];
    } else {
        [tester waitForViewWithAccessibilityLabel:@"Call Sign" value:@"N8117U. 14 of 14" traits:UIAccessibilityTraitNone];
    }

}

- (void)testSelectingRowInComponent
{
    [tester tapViewWithAccessibilityLabel:@"Date Selection"];
    NSArray *date = @[@"December", @"31", @"2030"];
    [tester selectDatePickerValue:date];
    [tester selectPickerViewRowWithTitle:@"17" inComponent:1];
    [tester waitForViewWithAccessibilityLabel:@"Date Selection" value:@"Dec 17, 2030" traits:UIAccessibilityTraitNone];
}

@end
