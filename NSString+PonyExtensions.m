#import "NSString+PonyExtensions.h"

@implementation NSString (PonyExtensions)

- (NSString*)stringByEscapingForURLQuery
{
  NSString *result = self;
  
  CFStringRef originalAsCFString = (CFStringRef) self;
  CFStringRef leaveAlone = CFSTR(" ");
  CFStringRef toEscape = CFSTR("\n\r?[]()$,!'*;:@&=#%+/");
  
  CFStringRef escapedStr;
  escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, originalAsCFString, leaveAlone, toEscape, kCFStringEncodingUTF8);
  
  if (escapedStr) {
    NSMutableString *mutable = [NSMutableString stringWithString:(NSString *)escapedStr];
    CFRelease(escapedStr);
    
    [mutable replaceOccurrencesOfString:@" " withString:@"+" options:0 range:NSMakeRange(0, [mutable length])];
    result = mutable;
  }
  return result;  
}

- (NSString*)stringByUnescapingFromURLQuery
{
  return [[self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

@end
