//
//  ResultCell.m
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 14/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResultCell.h"
#import "HtmlBuilder.h"
#import <QuartzCore/QuartzCore.h>
#import "Three20/Three20.h"
#import "RhymeTimeTTStyleSheet.h"
#import "Constants.h"
#import "Rhyme.h"



@interface ResultCellFactory()
//- (CAGradientLayer*)buildGradient;

@end

@implementation ResultCellFactory

@synthesize htmlBuilder;

-(id)init{
	if (self = [super init]) {
		htmlBuilder = [HtmlBuilder alloc];
	}
	return self;
}

-(ResultCell*)build:(RhymePart*)part{
	ResultCell *cell = [[ResultCell alloc] initWithPart:part htmlBuilder:htmlBuilder];
	
	cell.accessoryView = [[ UIImageView alloc ]  initWithImage:[UIImage imageNamed:@"AccDisclosure.png" ]];
	
	return cell;
}


@end

@interface ResultCell()

-(UILabel*)titleLabel:(CGRect)frame;
-(CAGradientLayer*)gradient:(CGFloat)cellHeight;
-(TTStyledTextLabel*)linesLabel:(CGRect)frame  linesHtml:(NSString*)linesHtml;
-(CGFloat)heightOfLinesString;
-(NSString *)replaceAmpersands:(NSString*)htmlString;


@end


@implementation ResultCell

@synthesize rhymePart, calculatedHeight;


- (id)initWithPart:(RhymePart*)part htmlBuilder:(HtmlBuilder*)htmlBuilder{
	if (self = [super initWithFrame:CGRectMake(0, 0, 320, 0)]) {
		rhymePart = part;
		NSString *linesHtml = [htmlBuilder buildHtmlLines320:part];
		
		CGFloat linesHeight = [self heightOfLinesString];
		CGFloat titleHeight = 30.0f;
		CGFloat xMargin = 10.0f;
		CGFloat yMargin = 15.0f;
		calculatedHeight= linesHeight + titleHeight + (yMargin * 2);
		
		
		TTStyledTextLabel *linesLabel = [self linesLabel:CGRectMake(xMargin, yMargin, kLinesWidth, linesHeight) linesHtml:linesHtml];
		UILabel *titlelabel = [self titleLabel:CGRectMake(xMargin, (linesHeight + (yMargin +(5.0f))), kLinesWidth, titleHeight)];
		CAGradientLayer *gradient = [self gradient:calculatedHeight];

		[self addSubview:linesLabel];
		[self addSubview:titlelabel];
		[self.layer insertSublayer:gradient atIndex:0];
	}
	
	return self;
}

-(TTStyledTextLabel*)linesLabel:(CGRect)frame  linesHtml:(NSString*)linesHtml{
	TTStyledTextLabel *linesLabel = [[[TTStyledTextLabel alloc] initWithFrame:frame] autorelease];
	linesLabel.backgroundColor = [UIColor clearColor];
	NSLog(@"lines html: %@", linesHtml);
		
	linesLabel.text = [TTStyledText textFromXHTML:[self replaceAmpersands:linesHtml]];
	NSLog(@"lines text: %@", linesLabel.text);
	return linesLabel;
}

-(NSString *)replaceAmpersands:(NSString*)htmlString{
	return [htmlString stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
}

-(CAGradientLayer*)gradient:(CGFloat)cellHeight{
	UIColor* darkterGrey = [UIColor colorWithRed:.15 green:.15 blue:.15 alpha:1];
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = CGRectMake(0, 0, 320, cellHeight);
	gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[darkterGrey CGColor], nil];
	return gradient;
}

-(UILabel*)titleLabel:(CGRect)frame{
	UILabel *titlelabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
	
	titlelabel.text = [NSString stringWithFormat:@"%@ - %@", [rhymePart.song.album.artist.name uppercaseString], rhymePart.song.title];
	titlelabel.textColor = [UIColor lightGrayColor];
	titlelabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	titlelabel.textAlignment = UITextAlignmentRight;
	titlelabel.backgroundColor = [UIColor clearColor];
 	
	return titlelabel;
}

- (CGFloat)heightOfLinesString{
	struct CGSize size;
	size = [rhymePart.rhyme.lines sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:15] constrainedToSize:CGSizeMake(kLinesWidth, 10000) lineBreakMode:UILineBreakModeCharacterWrap];
	return size.height;
}

@end
