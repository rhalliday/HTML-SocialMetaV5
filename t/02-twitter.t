use 5.006;
use strict;
use warnings;
use Test::More;
  
use_ok( 'HTML::SocialMeta' );
use_ok( 'HTML::SocialMeta::Base' );
use_ok( 'HTML::SocialMeta::Twitter' );

# Build Some Test Data Which Is Valid
my $meta_tags = HTML::SocialMeta->new(
    card_type => 'summary'
    site => '@example_twitter',
    site_name => 'Example Site, anything',
    title => 'You can have any title you wish here',
    description => 'Description goes here may have to do a little validation',
    image => 'www.urltoimage.com/blah.jpg',
    url	 => 'www.someurl.com',
);

# Build a app card 
my $meta_app_tags = HTML::SocialMeta->new(
    card_type => 'app',
    site => '@example_twitter',
    description => 'Description goes here may have to do a little validation',
    app_country => 'test',
    app_name_store => 'test',
    app_id_store => 'test', 
    app_url_store => 'test',
    app_name_play => 'test', 
    app_id_play => 'test',
    app_url_play => 'test',
);

ok($meta_tags);

# Create Twitter Cards
my $twitter_summary_card = $meta_tags->twitter->create_summary_card;
my $twitter_featured_image_card = $meta_tags->twitter->create_featured_image_card;
my $twitter_app_card = $meta_app_tags->twitter->create_app_card;

# Meta tags we need for Twitter to work
my $test_twitter = '<meta name="twitter:card" content="summary"/>
<meta name="twitter:site" content="@example_twitter"/>
<meta name="twitter:title" content="You can have any title you wish here"/>
<meta name="twitter:description" content="Description goes here may have to do a little validation"/>
<meta name="twitter:image" content="www.urltoimage.com/blah.jpg"/>';

is($twitter_summary_card, $test_twitter);

my $test_twitter_featured = '<meta name="twitter:card" content="summary_large_image"/>
<meta name="twitter:site" content="@example_twitter"/>
<meta name="twitter:title" content="You can have any title you wish here"/>
<meta name="twitter:description" content="Description goes here may have to do a little validation"/>
<meta name="twitter:image" content="www.urltoimage.com/blah.jpg"/>';

is($twitter_featured_image_card, $test_twitter_featured);

my $test_twitter_app_card = '<meta name="twitter:card" content="app"/>
<meta name="twitter:site" content="@example_twitter"/>
<meta name="twitter:description" content="Description goes here may have to do a little validation"/>
<meta name="twitter:app:country" content="test"/>
<meta name="twitter:app:name:iphone" content="test"/>
<meta name="twitter:app:name:ipad" content="test"/>
<meta name="twitter:app:id:iphone" content="test"/>
<meta name="twitter:app:id:ipad" content="test"/>
<meta name="twitter:app:url:iphone" content="test"/>
<meta name="twitter:app:url:ipad" content="test"/>
<meta name="twitter:app:name:googleplay" content="test"/>
<meta name="twitter:app:id:googleplay" content="test"/>
<meta name="twitter:app:url:googleplay" content="test"/>';

is($twitter_app_card, $test_twitter_app_card);

done_testing();

1;
