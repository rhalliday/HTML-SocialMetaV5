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
);

ok($meta_tags);

# Create Schema Cards
my $schema_tags = $meta_tags->schema->create_schema;

# Meta tags we need for Schema to work
my $test_schema = '<html itemscope itemtype="http://schema.org/Article">
<title>You can have any title you wish here</title>
<meta name="description" content="Description goes here may have to do a little validation">
<meta itemprop="name" content="You can have any title you wish here"/>
<meta itemprop="description" content="Description goes here may have to do a little validation"/>
<meta itemprop="image" content="www.urltoimage.com/blah.jpg"/>';

is($schema_tags, $test_schema);

done_testing();

1;
