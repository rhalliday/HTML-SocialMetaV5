use 5.006;
use strict;
use warnings;
use Test::More;
  
use_ok( 'HTML::SocialMeta' );
use_ok( 'HTML::SocialMeta::Base' );
use_ok( 'HTML::SocialMeta::Schema' );

# Build Some Test Data Which Is Valid
my $meta_tags = HTML::SocialMeta->new(
    title => 'You can have any title you wish here',
    description => 'Description goes here may have to do a little validation',
    image => 'www.urltoimage.com/blah.jpg',
    player => 'www.somevideourl.com/url/url',
    player_width => '500',
    player_height => '500',
    operatingSystem => 'ANDROID',
    app_url	=> 'www.someapp.com',
);

ok($meta_tags);

# Create Schema Cards
my $schema_tags = $meta_tags->schema->create_article;
my $offer_tags = $meta_tags->schema->create_offer;
my $video_tags = $meta_tags->schema->create_video;
my $app_tags = $meta_tags->schema->create_software_application;

# Meta tags we need for Schema to work
my $test_schema = q{<meta itemprop="article" itemscope itemtype="http://schema.org/Article" />
<meta itemprop="name" content="You can have any title you wish here"/>
<meta itemprop="description" content="Description goes here may have to do a little validation"/>
<meta itemprop="image" content="www.urltoimage.com/blah.jpg"/>};

is($schema_tags, $test_schema);

my $test_offer = q{<meta itemprop="offer" itemscope itemtype="http://schema.org/Offer" />
<meta itemprop="name" content="You can have any title you wish here"/>
<meta itemprop="description" content="Description goes here may have to do a little validation"/>
<meta itemprop="image" content="www.urltoimage.com/blah.jpg"/>};

is($offer_tags, $test_offer);

my $test_video = q{<meta itemprop="video" itemscope itemtype="http://schema.org/VideoObject" />
<meta itemprop="thumbnailUrl" content="www.urltoimage.com/blah.jpg"/>
<meta itemprop="name" content="You can have any title you wish here"/>
<meta itemprop="description" content="Description goes here may have to do a little validation"/>
<meta itemprop="image" content="www.urltoimage.com/blah.jpg"/>
<meta itemprop="embedURL" content="www.somevideourl.com/url/url"/>
<meta itemprop="contentURL" content="www.somevideourl.com/url/url"/>
<meta itemprop="width" content="500"/>
<meta itemprop="height" content="500"/>};

is($video_tags, $test_video);

my $test_app = q{<meta itemprop="software_application" itemscope itemtype="http://schema.org/SoftwareApplication" />
<link itemprop="applicationCategory" href="http://schema.org/GameApplication"/>
<meta itemprop="name" content="You can have any title you wish here"/>
<meta itemprop="description" content="Description goes here may have to do a little validation"/>
<meta itemprop="image" content="www.urltoimage.com/blah.jpg"/>
<meta itemprop="operatingSystem" content="ANDROID"/>
<meta itemprop="url" content="www.someapp.com"/>};

is($app_tags, $test_app);

done_testing();

1;
