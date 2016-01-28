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

has '+card_options' => (
    default => sub {
        return {
            summary        => q(create_summary),
            featured_image => q(create_summary_large_image),
            app            => q(create_app),
            player         => q(create_player),
        };
    },
);

has '+build_fields' => (
    default => sub {
        return {
            summary             => [qw(card site title description image)],
            summary_large_image => [qw(card site title description image)],
            app =>
              [qw(card site description app_country app_name app_id app_url)],
            player => [
                qw(card site title description image player player_width player_height)
            ],
        };
    },
);

sub create_summary {
    my ($self) = @_;

    $self->card('summary');

    return $self->build_meta_tags( $self->card );
}

sub create_summary_large_image {
    my ($self) = @_;

    $self->card('summary_large_image');

    return $self->build_meta_tags( $self->card );
}

sub create_app {
    my ($self) = @_;

    $self->card('app');

    return $self->build_meta_tags( $self->card );
}

sub create_player {
    my ($self) = @_;

    $self->card('player');

    return $self->build_meta_tags( $self->card );
}

sub provider_convert {
    my ( $self, $field ) = @_;

    return [ { field_type => $field } ]
      if $field !~ m{^app}xms || $field =~ m{country$}xms;

    return [ { field_type => $field . ':googleplay' } ]
      if $self->operatingSystem eq q{ANDROID};

    return [
        { field_type => $field . ':iphone' },
        { field_type => $field . ':ipad' }
      ]
      if $self->operatingSystem eq q{IOS};

    return croak 'We currently do not support this APP type';
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
        operatingSystem => 'ANDROID',
        app_country => 'test',
        app_name  => 'test',
        app_id => 'test',
        app_url => 'test',
        player      => 'www.urltovideo.com/blah.jpg',
        player_width => '500',
        player_height => '500',            
   );

   $twitter->create('summary featured_image app player');
   
   $twitter->create_summary;
   $twitter->create_summary_large_image;
   $twitter->create_app;
   $twitter->create_player;

=cut 

=head1 SUBROUTINES/METHODS

=head1 VERSION

Version 0.3

=cut

=head1 DESCRIPTION

Base class for creating OpenGraph meta data

=head1 SYNOPSIS

=head1 SUBROUTINES/METHODS

=head2 card_options

An Hash Reference of card options available for this meta provider, it is used to map the create function when create is called.

=cut

=head2 build_fields 
    
An Hash Reference of fields that are attached to the selected card:

=cut

=head2 create_summary

Generate Twitter Summary meta data

=cut

=head2 create_summary_large_image

Generate Twitter Summary Large Image Video meta data

=cut

=head2 create_app

Generate Twitter App meta data

=cut

=head2 create_player

Generate Twitter Player meta data

=cut

=head1 AUTHOR

Robert Acock <ThisUsedToBeAnEmail@gmail.com>
Robert Haliday <robh@cpan.org>

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



