use 5.006;
use strict;
use warnings;
use Test::More;
  
use_ok( 'HTML::SocialMeta' );

# Build Some Test Data Which Is Valid
my $meta_tags = HTML::SocialMeta->new(
    card_type => 'summary',
    site => '@example_twitter',
    site_name => 'Example Site, anything',
    title => 'You can have any title you wish here',
    description => 'Description goes here may have to do a little validation',
    image => 'www.urltoimage.com/blah.jpg',
    url	 => 'www.someurl.com',
);

# Create - Valid Meta_Tags
my $tags = $meta_tags->create;

my $test_create_all = '<html itemscope itemtype="http://schema.org/Article">
<title>You can have any title you wish here</title>
<meta name="description" content="Description goes here may have to do a little validation">
<meta itemprop="name" content="You can have any title you wish here"/>
<meta itemprop="description" content="Description goes here may have to do a little validation"/>
<meta itemprop="image" content="www.urltoimage.com/blah.jpg"/>
<meta name="twitter:card" content="summary"/>
<meta name="twitter:site" content="@example_twitter"/>
<meta name="twitter:title" content="You can have any title you wish here"/>
<meta name="twitter:description" content="Description goes here may have to do a little validation"/>
<meta name="twitter:image" content="www.urltoimage.com/blah.jpg"/>
<meta property="og:type" content="thumbnail"/>
<meta property="og:title" content="You can have any title you wish here"/>
<meta property="og:description" content="Description goes here may have to do a little validation"/>
<meta property="og:url" content="www.someurl.com"/>
<meta property="og:image" content="www.urltoimage.com/blah.jpg"/>
<meta property="og:site_name" content="Example Site, anything"/>';

is($tags, $test_create_all);

my $twitter_tags = $meta_tags->twitter;
my $twitter_create = $twitter_tags->create('featured_image');

my $test_twitter_featured = '<meta name="twitter:card" content="summary_large_image"/>
<meta name="twitter:site" content="@example_twitter"/>
<meta name="twitter:title" content="You can have any title you wish here"/>
<meta name="twitter:description" content="Description goes here may have to do a little validation"/>
<meta name="twitter:image" content="www.urltoimage.com/blah.jpg"/>';

is($twitter_create, $test_twitter_featured);

# check we still have the original card_type passed in available
my $generic_twitter_create = $twitter_tags->create();

my $test_twitter = '<meta name="twitter:card" content="summary"/>
<meta name="twitter:site" content="@example_twitter"/>
<meta name="twitter:title" content="You can have any title you wish here"/>
<meta name="twitter:description" content="Description goes here may have to do a little validation"/>
<meta name="twitter:image" content="www.urltoimage.com/blah.jpg"/>';

is($generic_twitter_create, $test_twitter);

done_testing();

1;
