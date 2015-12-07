# NAME

HTML::SocialMeta - Module to generate Social Media Meta Tags, 

# VERSION

Version 0.2

# DESCRIPTION

This module makes it easy to create social meta cards.

i.e  $social->create('summary') will generate:

        <html itemscope itemtype="http://schema.org/Article">
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
        <meta property="og:site_name" content="Example Site, anything"/>

It allows you to optimize sharing on several social media platforms such as Twitter, Facebook, Google+ 
and Pinerest by defining exactly how titles, descriptions, images and more appear in social streams.

It generates all the required META data for the following Providers:

        * Twitter
        * OpenGraph
        * Schema.org

This module currently allows you to create the following cards:

        $social->create()   $twitter->create_       $opengraph->create_         $schema->create_
        * summary           summary                 thumbnail                       article
        * featured_image    summary_large_image     article                         offer 
        * player            player                  video                           video
        * app               app                     product                 ***                 

# SYNOPSIS

        use HTML::SocialMeta;
        # summary or featured image 
        my $social = HTML::SocialCards->new(
                site => '',
                site_name => '',
                title => '',
                description => '',
                image   => '',
                url  => '',  # optional
                ... => '',
                ... => '',
        );

        # returns meta tags for all providers   
        my $meta_tags = $social->create('summary | featured_image | app | player');

        # returns meta tags specificly for a single provider
        my $twitter_tags = $social->twitter;
        my $opengraph_tags = $social->opengraph;
        my $schema = $social->create->schema

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

# SUBROUTINES/METHODS

## new

Returns an instance of this class. Requires `$url` as an argument;

        my $social = URL::Social->new(
                card => '...',          * card type - currently either summary or featured_image
                site => '',             * twitter site - @twitter_handle 
                site_name => '',        * sites name - Example Business
                title => '',            * card title - title of the card 
                description => '',      * description - content of the card
                image => '',            * attached image - url http/www.someurl.com/test.jpg
                url => '',              * url where the content is hosted, or url to some completly randon html page
                ... => '',
                ... => '',
        );

## Summary Card

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
        $card->schema->create_article;

fields required:

        * card   
        * site_name - OpenGraph
        * site - Twitter Site
        * title
        * description
        * image

## Featured Image Card

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
        $card->schema->create_offer;

Fields Required:

        * card - Twitter
        * site - Twitter
        * site_name  - Open Graph
        * creator - Twitter
        * title
        * image
        * url - Open Graph

## Player Card

        ,-----------------------------------,
        | Title                             |   
        | link                              |
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
        $card->schema->create_video;

Fields Required:

    * site 
    * title 
    * description 
    * image 
    * player 
    * player_width 
    * player_height

## App Card

        ,-----------------------------------,
        |   APP NAME              *-------* |
        |   APP INFO              |  app  | |
        |                         | image | |
        |   PRICE                 *-------* |
        |   DESCRIPTION                     |
        *-----------------------------------*

Return an instance for the provider specific app card:

        $card->create('app);    
        # call meta provider specifically
        $card->twitter->create_app;
        $card->twitter->create_product;

Fields Required

        * site
        * description
        * app_country
        * app_name_store
        * app_id_store
        * app_url_store
        * app_id_play
        * app_id_play
        * app_id_play

price and app info pulled from the app stores?

## create

Create the Meta Tags - this returns the meta information for all the providers:

        * Twitter
        * OpenGraph
        * Google
        

You just need to specify the card type on create

        $social->create('summary | featured_image | app | player');

## required\_fields

Returns a list of fields that are required to build the meta tags

        $social = HTML->SocialMeta->new();
        # @fields = qw{}
        my @fields = $social->required_fields('summary');

# BUGS AND LIMITATIONS

Please report any bugs at http://rt.cpan.org/.

# DEPENDENCIES

Moose - Version 2.0604
Namespace::Autoclean - Verstion 0.15
List::MoreUtils - Version 0.413 

# DIAGNOSTICS

A. Twitter Validation Tool

https://dev.twitter.com/docs/cards/validation/validator

Before your cards show on Twitter, you must first have your domain approved. Fortunately, 
it's a super-easy process. After you implement your cards, simply enter your sample URL into 
the validation tool. After checking your markup, select the "Submit for Approval" button.

B. Facebook Debugger

https://developers.facebook.com/tools/debug

You don't need prior approval for your meta information to show on Facebook, 
but the debugging tool they offer gives you a wealth of information about all your 
tags and can also analyze your Twitter tags.

C. Google Structured Data Testing Tool

http://www.google.com/webmasters/tools/richsnippets

Webmasters traditionally use the structured data testing tool to test authorship markup and preview
how snippets will appear in search results, but you can also use see what other types of
meta data Google is able to extract from each page.

# AUTHOR

Robert Acock <ThisUsedToBeAnEmail@gmail.com>
Robert Haliday &lt;robh@cpan.org>

# CONFIGURATION AND ENVIRONMENT

# INCOMPATIBILITIES

# LICENSE AND COPYRIGHT

Copyright 2015 Robert Acock.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

[http://www.perlfoundation.org/artistic\_license\_2\_0](http://www.perlfoundation.org/artistic_license_2_0)

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
