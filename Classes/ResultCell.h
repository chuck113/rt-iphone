#import "RhymePart.h"
#import "HtmlBuilder.h"


@interface ResultCell : UITableViewCell {

	RhymePart* rhymePart;
	CGFloat calculatedHeight;
}

@property (nonatomic, retain, readonly) RhymePart* rhymePart;
@property (nonatomic, readonly) CGFloat calculatedHeight;


- (id)initWithPart:(RhymePart*)part htmlBuilder:(HtmlBuilder*)htmlBuilder;

@end





@interface ResultCellFactory : NSObject
{
	HtmlBuilder *htmlBuilder;
}

-(ResultCell*)build:(RhymePart*)part ;


@property (nonatomic, retain, readonly) HtmlBuilder *htmlBuilder;


@end

