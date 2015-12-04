use 5.006;
use strict;
use warnings;
use Test::More;
  
use_ok( 'HTML::SocialMeta' );
use_ok( 'HTML::SocialMeta::Base' );
use_ok( 'HTML::SocialMeta::OpenGraph' );

# Build Some Test Data Which Is Valid
my $meta_tags = HTML::SocialMeta->new(
    site => '@example_twitter',
    site_name => 'Example Site, anything',
    title => 'You can have any title you wish here',
    description => 'Description goes here may have to do a little validation',
    image => 'www.urltoimage.com/blah.jpg',
    url	 => 'www.someurl.com',
);

ok($meta_tags);

my $opengraph_article_card = $meta_tags->opengraph->create_article_card;
my $opengraph_thumbnail_card = $meta_tags->opengraph->create_thumbnail_card;

# Meta tags we need for OPENGRAPH to work
my $test_opengraph = '<meta property="og:type" content="thumbnail"/>
<meta property="og:title" content="You can have any title you wish here"/>
<meta property="og:description" content="Description goes here may have to do a little validation"/>
<meta property="og:url" content="www.someurl.com"/>
<meta property="og:image" content="www.urltoimage.com/blah.jpg"/>
<meta property="og:site_name" content="Example Site, anything"/>';

is($opengraph_thumbnail_card, $test_opengraph);

my $test_opengraph_thumbnail = '<meta property="og:type" content="thumbnail"/>
<meta property="og:title" content="You can have any title you wish here"/>
<meta property="og:description" content="Description goes here may have to do a little validation"/>
<meta property="og:url" content="www.someurl.com"/>
<meta property="og:image" content="www.urltoimage.com/blah.jpg"/>
<meta property="og:site_name" content="Example Site, anything"/>';

is($opengraph_thumbnail_card, $test_opengraph_thumbnail);

done_testing();
