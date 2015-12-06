use 5.006;
use strict;
use warnings;
use Test::More;
  
use_ok( 'HTML::SocialMeta' );
use_ok( 'HTML::SocialMeta::Base' );
use_ok( 'HTML::SocialMeta::Twitter' );

# Build Some Test Data Which Is Valid
my $meta_tags = HTML::SocialMeta->new(
    card_type => 'summary',
    site => '@example_twitter',
    site_name => 'Example Site, anything',
    title => 'You can have any title you wish here',
    description => 'Description goes here may have to do a little validation',
    image => 'www.urltoimage.com/blah.jpg',
    url	 => 'www.someurl.com',
    app_country => 'test',
    app_name_store => 'test',
    app_id_store => 'test', 
    app_url_store => 'test',
    app_name_play => 'test', 
    app_id_play => 'test',
    app_url_play => 'test',
    player      => 'www.urltovideo.com/blah.jpg',
    player_width => '500',
    player_height => '500',
);
# Build a player card
my $meta_player_tags = HTML::SocialMeta->new(
    site => '@example_twitter',
    title => 'You can have any title you wish here',
    description => 'Description goes here may have to do a little validation',
    player => 'www.urltovideo.com/blah.jpg',
    image => 'www.urltoimage.com/blah.jpg',
    player_width => '500',
    player_height => '500',
);

ok($meta_tags);
my $twitter = $meta_tags->twitter;
# Create Twitter Cards
my $twitter_summary_card = $meta_tags->twitter->create_summary;
my $twitter_featured_image_card = $meta_tags->twitter->create_summary_large_image;
my $twitter_app_card = $meta_tags->twitter->create_app;
my $twitter_player_card = $meta_player_tags->twitter->create_player;

# Meta tags we need for Twitter to work
my $test_twitter = '<meta name="twitter:card" content="summary"/>
<meta name="twitter:site" content="@example_twitter"/>
<meta name="twitter:title" content="You can have any title you wish here"/>
<meta name="twitter:description" content="Description goes here may have to do a little validation"/>
<meta name="twitter:image" content="www.urltoimage.com/blah.jpg"/>';

is($twitter->create('summary'), $test_twitter);
is($twitter_summary_card, $test_twitter);

my $test_twitter_featured = '<meta name="twitter:card" content="summary_large_image"/>
<meta name="twitter:site" content="@example_twitter"/>
<meta name="twitter:title" content="You can have any title you wish here"/>
<meta name="twitter:description" content="Description goes here may have to do a little validation"/>
<meta name="twitter:image" content="www.urltoimage.com/blah.jpg"/>';

is($twitter->create('featured_image'), $test_twitter_featured);
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

is($twitter->create('app'), $test_twitter_app_card);
is($twitter_app_card, $test_twitter_app_card);

my $test_player_card = '<meta name="twitter:card" content="player"/>
<meta name="twitter:site" content="@example_twitter"/>
<meta name="twitter:title" content="You can have any title you wish here"/>
<meta name="twitter:description" content="Description goes here may have to do a little validation"/>
<meta name="twitter:image" content="www.urltoimage.com/blah.jpg"/>
<meta name="twitter:player" content="www.urltovideo.com/blah.jpg"/>
<meta name="twitter:player:width" content="500"/>
<meta name="twitter:player:height" content="500"/>';

is($twitter->create('player'), $test_player_card);
is($twitter_player_card, $test_player_card);

done_testing();

1;
