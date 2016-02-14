#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Test::Exception;
   
use_ok( 'HTML::SocialMeta' );
use_ok( 'HTML::SocialMeta::Base' );

my $bad_meta_tags = HTML::SocialMeta->new(
    name => 'dfgfjfgdd',
    title => 'hellllpp',
    site => '@example_twitter',
    site_name => 'Example Site, anything',
    description => 'Description goes here may have to do a little validation',
    image => 'www.urltoimage.com/blah.jpg',
    url	 => 'www.someurl.com',
);

ok( $bad_meta_tags->richsnippet->create_article );
use Data::Dumper;
warn Dumper $bad_meta_tags->richsnippet->create_article;


done_testing;
1;
