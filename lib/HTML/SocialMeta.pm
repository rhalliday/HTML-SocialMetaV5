package HTML::SocialMeta;
use Moose;
use namespace::autoclean;
use List::MoreUtils qw(uniq);

use HTML::SocialMeta::Twitter;
use HTML::SocialMeta::OpenGraph;

our $VERSION = '0.4';

has 'card_type' => ( isa => 'Str', is => 'rw', lazy => 1, default => q{} );
has [
    qw(card site site_name title description image url creator operatingSystem app_country app_name app_id app_url player player_height player_width fb_app_id)
  ] => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => q{},
  );

has 'twitter' => (
    isa     => 'HTML::SocialMeta::Twitter',
    is      => 'ro',
    lazy    => 1,
    builder => 'build_twitter',
);

has 'opengraph' => (
    isa     => 'HTML::SocialMeta::OpenGraph',
    is      => 'ro',
    lazy    => 1,
    builder => 'build_opengraph',
);

sub create {
    my ( $self, $card_type ) = @_;

    $card_type ||= $self->card_type;

    $self->card_type($card_type);

    my @meta_tags =
      map { $self->$_->create( $self->card_type ) } qw/twitter opengraph/;

    return join "\n", @meta_tags;
}

sub required_fields {
    my ( $self, $card_type ) = @_;

    my @meta_tags =
      map { $self->$_->required_fields( $self->$_->meta_option($card_type) ) }
      qw/twitter opengraph/;

    my @required_fields = uniq(@meta_tags);

    return @required_fields;
}

sub build_twitter {
    my $self = shift;

    return HTML::SocialMeta::Twitter->new(
        card_type       => $self->card_type,
        site            => $self->site,
        title           => $self->title,
        description     => $self->description,
        image           => $self->image,
        url             => $self->url,
        creator         => $self->creator,
        operatingSystem => $self->operatingSystem,
        app_country     => $self->app_country,
        app_name        => $self->app_name,
        app_id          => $self->app_id,
        app_url         => $self->app_url,
        player          => $self->player,
        player_width    => $self->player_width,
        player_height   => $self->player_height,
    );
}

sub build_opengraph {
    my $self = shift;

    my $url = $self->app_url ? $self->app_url : $self->url;

    return HTML::SocialMeta::OpenGraph->new(
        card_type       => $self->card_type,
        site_name       => $self->site_name,
        title           => $self->title,
        description     => $self->description,
        image           => $self->image,
        url             => $url,
        operatingSystem => $self->operatingSystem,
        player          => $self->player,
        player_width    => $self->player_width,
        player_height   => $self->player_height,
        fb_app_id       => $self->fb_app_id,
    );
}

#
# The End
#
__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::SocialMeta - Module to generate Social Media Meta Tags, 

=head1 VERSION

Version 0.4

=head1 SYNOPSIS

    use HTML::SocialMeta;
    # summary or featured image card setup
    my $social = HTML::SocialCards->new(
        site => '',
        site_name => '',
        title => '',
        description => '',
        image	=> '',
        fb_app_id => '',
	url  => '',  # optional
        ... => '',
        ... => '',
    );

    # returns meta tags for all providers	
    my $meta_tags = $social->create('summary | featured_image | app | player');

    # returns meta tags specificly for a single provider
    my $twitter_tags = $social->twitter;
    my $opengraph_tags = $social->opengraph;

    my $twitter->create('summary' | 'featured_image' | 'player' | 'app');
    
    # Alternatively call a card directly
    my $summary_card = $meta_tags->twitter->create_summary;
    
    ....
    # You then need to insert these meta tags in the head of your html, 
    # one way of implementing this if you are using Catalyst and Template Toolkit would be ..
    
    # controller 
    $c->stash->{meta_tags} = $meta_tags;
    
    # template
    [% meta_tags | html %]

=head1 DESCRIPTION

This module generates social meta tags.

i.e  $social->create('summary') will generate:
    
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
    <meta property="og:site_name" content="Example Site, anything"/>
    <meta property="fb:app_id" content="123433223543"/>'

It allows you to optimize sharing on several social media platforms such as Twitter, Facebook, Google+ 
and Pinerest by defining exactly how titles, descriptions, images and more appear in social streams.

It generates all the required META data for the following Providers:

    * Twitter
    * OpenGraph

This module currently allows you to generate the following meta cards:

    $social->create()  $twitter->create_       $opengraph->create_  	
    summary            summary                 thumbnail         	
    featured_image     summary_large_image     article            	 
    player             player                  video              	
    app                app                     product             	                 

=head1 SUBROUTINES/METHODS

=head2 Constructor

Returns an instance of this class. Requires C<$url> as an argument;

=over

=item card

OPTIONAL - if you always want the same card type you can set it 

=item site

The Twitter @username the card should be attributed to. Required for Twitter Card analytics. 

=item site name

This is Used by Facebook, you can just set it as your organisations name.

=item title

The title of your content as it should appear in the card 

=item description

A description of the content in a maximum of 200 characters

=item image

A URL to a unique image representing the content of the page

=item url

OPTIONAL OPENGRAPH - allows you to specify an alternative url link you want the reader to be redirected 

=item player

HTTPS URL to iframe player. This must be a HTTPS URL which does not generate active mixed content warnings in a web browser

=item player_width

Width of IFRAME specified in twitter:player in pixels

=item player_height

Height of IFRAME specified in twitter:player in pixels

=item operating_system

IOS or Android 

=item app_country      

UK/US ect

=item app_name   

The applications name

=item app_id 

String value, and should be the numeric representation of your app ID in the App Store (.i.e. 307234931)

=item app_url 

Application store url - direct link to App store page

=item fb_app_id

This field is required to use social meta with facebook, you must register your website/app/company with facebook.
They will then provide you with a unique app_id.

=back

=head2 Summary Card

The Summary Card can be used for many kinds of web content, from blog posts and news articles, to products and restaurants. 
It is designed to give the reader a preview of the content before clicking through to your website.

    ,-----------------------------------,
    |   TITLE                 *-------* |
    |                         |       | |
    |   DESCRIPTION           |       | |
    |                         *-------* |
    *-----------------------------------*

Returns an instance for the summary card:
	
    $meta->create('summary');
    # call meta provider specifically
    $card->twitter->create_summary;
    $card->opengraph->create_thumbnail;

fields required:

    * card   
    * site_name - OpenGraph
    * site - Twitter Site
    * title
    * description
    * image

=head2 Featured Image Card

The Featured Image Card features a large, full-width prominent image. 
It is designed to give the reader a rich photo experience, clicking on the image brings the user to your website.

    ,-----------------------------------,
    | *-------------------------------* |
    | |                               | |
    | |                               | |
    | |                               | |
    | |                               | |
    | |                               | |
    | |                               | |
    | *-------------------------------* |
    |  TITLE                            |
    |  DESCRIPTION                      |
    *-----------------------------------*

Returns an instance for the featured image card:

    $card->create('featured_image');	
    # call meta provider specifically
    $card->twitter->create_featured_image;
    $card->opengraph->create_article;

Fields Required:

    * card - Twitter
    * site - Twitter
    * site_name  - Open Graph
    * creator - Twitter
    * title
    * image
    * url - Open Graph

=cut

=head2 Player Card

The Player Card allows you to share Video clips and audio stream.

    ,-----------------------------------,
    | Title                             |	
    | link   				|
    | *-------------------------------* |
    | |                               | |
    | |                               | |
    | |                               | |
    | |            <play>             | |
    | |                               | |
    | |                               | |
    | *-------------------------------* |
    *-----------------------------------*

Returns an instance for the player card:

    $card->create('player');	
    # call meta provider specifically
    $card->twitter->create_player;
    $card->opengraph->create_video;

Fields Required:
 
    * site 
    * title 
    * description 
    * image 
    * player                
    * player_width           
    * player_height     

image to be displayed in place of the player on platforms that does not support iframes or inline players. You should make this image the same dimensions
as your player. Images with fewer than 68,600 pixels (a 262 x 262 square image, or a 350 x 196 16:9 image) will cause the player card not to render. 
Image must be less than 1MB in size 

=cut

=head2 App Card

The App Card is a great way to represent mobile applications on Social Media Platforms and to drive installs. 

    ,-----------------------------------,
    |   APP NAME              *-------* |
    |   APP INFO              |  app  | |
    |                         | image | |
    |                         *-------* |
    |   DESCRIPTION                     |
    *-----------------------------------*

Return an instance for the provider specific app card:

    $card->create('app);	
    # call meta provider specifically
    $card->twitter->create_app;
    $card->opengraph->create_product;

Fields Required

    * site
    * title
    * description
    * operatingSystem   
    * app_country      
    * app_name        
    * app_id           
    * app_url           

=cut

=head2 create

Create the Meta Tags - this returns the meta information for all the providers:
    
    * Twitter
    * OpenGraph
    * Google
	
You just need to specify the card type on create

    $social->create('summary | featured_image | app | player');

=cut

=head2 required_fields

Returns a list of fields that are required to build the meta tags

    $social = HTML->SocialMeta->new();
    # @fields = qw{}
    my @fields = $social->required_fields('summary');

=cut

=head1 BUGS AND LIMITATIONS
 
Please report any bugs at http://rt.cpan.org/.

=todo

Add support for Schema.org Rich Snippets
Improve Unit Tests
Add support for additional card types

=head1 DEPENDENCIES

Moose - Version 2.0604
Namespace::Autoclean - Verstion 0.15
List::MoreUtils - Version 0.413 

=head1 DIAGNOSTICS

A. Twitter Validation Tool

https://dev.twitter.com/docs/cards/validation/validator

Before your cards show on Twitter, you must first have your domain approved. Fortunately, 
it's a super-easy process. After you implement your cards, simply enter your sample URL into 
the validation tool. After checking your markup, select the "Submit for Approval" button.

B. Facebook Debugger

https://developers.facebook.com/tools/debug

You do not need prior approval for your meta information to show on Facebook, 
but the debugging tool they offer gives you a wealth of information about all your 
tags and can also analyze your Twitter tags.

C. Google Structured Data Testing Tool

http://www.google.com/webmasters/tools/richsnippets

Webmasters traditionally use the structured data testing tool to test authorship markup and preview
how snippets will appear in search results, but you can also use see what other types of
meta data Google is able to extract from each page.

=head1 AUTHOR

Robert Acock <ThisUsedToBeAnEmail@gmail.com>
Robert Haliday <robh@cpan.org>

=head1 CONFIGURATION AND ENVIRONMENT

=head1 INCOMPATIBILITIES

=head1 LICENSE AND COPYRIGHT
 
Copyright 2015 Robert Acock.
 
This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:
 
L<http://www.perlfoundation.org/artistic_license_2_0>
 
Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.
 
If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.
 
This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.
 
This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.
 
Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



