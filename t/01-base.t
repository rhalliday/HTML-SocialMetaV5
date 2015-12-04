#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Test::Exception;
   
use_ok( 'HTML::SocialMeta' );
use_ok( 'HTML::SocialMeta::Base' );

# Build Some Test Data With a Missing Field - No title !!
my $bad_meta_tags = HTML::SocialMeta->new(
    card => 'summary',
    site => '@example_twitter',
    site_name => 'Example Site, anything',
    description => 'Description goes here may have to do a little validation',
    image => 'www.urltoimage.com/blah.jpg',
    url	 => 'www.someurl.com',
);

# it will run schema first so it won't have a name!! which is equivelant to title
throws_ok{$bad_meta_tags->twitter->create_summary_card} qr/you have not set this field value title/;
throws_ok{$bad_meta_tags->opengraph->create_article_card} qr/you have not set this field value title/;

done_testing;

1;
