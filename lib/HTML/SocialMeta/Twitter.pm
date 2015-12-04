package HTML::SocialMeta::Twitter;

use Moose;
use namespace::autoclean;
use Carp;

extends 'HTML::SocialMeta::Base';

our $VERSION = '0.22';

# Provider Specific Fields
has 'meta_attribute' =>
  ( isa => 'Str', is => 'ro', required => 1, default => 'name' );
has 'meta_namespace' =>
  ( isa => 'Str', is => 'ro', required => 1, default => 'twitter' );

sub card_options {
    return (
        summary        => 'create_summary_card',
        featured_image => 'create_featured_image_card',
        app            => 'create_app_card',
        player         => 'create_player_card',
    );
}

sub create_summary_card {
    my ($self) = @_;

    $self->card('summary');

    # the required fields needed to build a twitter summary card
    my @fields = qw(card site title description image);

    return $self->build_meta_tags(@fields);
}

sub create_featured_image_card {
    my ($self) = @_;

    $self->card('summary_large_image');

    # the required fields needed to build a twitter featured image card
    my @fields = qw(card site title description image);

    return $self->build_meta_tags(@fields);
}

sub create_app_card {
    my ($self) = @_;

    $self->card('app');

    # the required fields needed to build a twitter featured image card
    my @fields =
      qw(card site description app_country app_name_store app_id_store app_url_store app_name_play app_id_play app_url_play);

    return $self->build_meta_tags(@fields);
}

sub create_player_card {
    my ($self) = @_;

    $self->card('player');

    # the required fields needed to build a twitter featured image card
    my @fields =
      qw(card site title description image player player_width player_height );

    return $self->build_meta_tags(@fields);
}

#
# The End
#
__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::SocialMeta::Twitter

=head1 VERSION

Version 0.2

=cut

=head1 DESCRIPTION

Base class to create Twitter Cards

=head1 SYNOPSIS
    
    $twitter_meta => HTML::Social::Twitter->new(
        card_type => 'summary',
        site => '@example_twitter',
        site_name => 'Example Site, anything',
        title => 'You can have any title you wish here',
        description => 'Description goes here may have to do a little validation',
        image => 'www.urltoimage.com/blah.jpg',
        url  => 'www.someurl.com',
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

   $twitter->create('summary featured_image app player');
   
   $twitter->create_summary_card;
   $twitter->create_featured_image_card;
   $twitter->create_app_card;
   $twitter->create_player_card;

=cut 

=head1 SUBROUTINES/METHODS

=head2 create 

    * summary
    * featured_image
    * app
    * player

=cut

=head2 create_summary_card

Required Fields

    * type
    * title
    * description
    * url
    * image 
    * site_name 

=cut

=head2 create_featured_image_card

Required Fields

    * type
    * title
    * description
    * url
    * image 
    * site_name 

=cut

=head2 create_app_card

Required Fields

    * type
    * site
    * description
    * app_country
    * app_name_store 
    * app_id_store
    * app_url_store
    * app_name_play
    * app_id_play
    * app_url_play  

=cut

=head3 create_player_card

Required Fields

    * card 
    * site 
    * title 
    * description 
    * image 
    * player 
    * player_width 
    * player_height

=cut

=head1 AUTHOR

Robert Acock <ThisUsedToBeAnEmail@gmail.com>

=head1 TODO
 
    * Add support for player streaming 
 
=head1 BUGS AND LIMITATIONS
 
Most probably. Please report any bugs at http://rt.cpan.org/.

=head1 INCOMPATIBILITIES

=head1 DEPENDENCIES

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DIAGNOSTICS
 
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



