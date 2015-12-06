package HTML::SocialMeta::Schema;
use Moose;
use namespace::autoclean;
use Carp;

our $VERSION = '0.2';

extends 'HTML::SocialMeta::Base';

# Provider Specific Fields
has 'meta_attribute' =>
  ( isa => 'Str', is => 'ro', required => 1, default => 'itemprop' );
has 'meta_namespace' =>
  ( isa => 'Str', is => 'ro', required => 1, default => q{} );

sub card_options {
    return (
        summary        => q(create_schema),
        featured_image => q(create_schema),
        player         => q(create_schema),
    );
}

sub build_fields {
    return ( schema => [qw(name description image)], );
}

sub create_schema {
    my ($self) = @_;

    # the required fields needed to build a twitter summary card
    my @fields = $self->required_fields('schema');

    return $self->build_meta_tags(@fields);
}

override build_meta_tags => sub {
    my ( $self, @fields ) = @_;

    my @meta_tags;

    # specifiying this is an Google Article - eventually this will be modified
    push @meta_tags, '<html itemscope itemtype="http://schema.org/Article">';

    # google snippet
    push @meta_tags, '<title>' . $self->name . '</title>';
    push @meta_tags,
      '<meta name="description" content="' . $self->description . '">';

    foreach my $field (@fields) {

        # check the field has a value set
        $self->_validate_field_value($field);

        push @meta_tags, $self->_build_field($field);
    }

    return join "\n", @meta_tags;
};

override _build_field => sub {
    my ( $self, $field, $field_type ) = @_;

    $field_type = $field_type ? $field_type : $field;

    return
        q{<meta }
      . $self->meta_attribute . q{="}
      . $field
      . q{" content="}
      . $self->$field . q{"/>};
};

#
# The End
#
__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::SocialMeta::Schema

=head1 VERSION

Version 0.2

=cut

=head1 DESCRIPTION

Base class for creating Schema meta data

=head1 METHODS

=cut

=head1 SYNOPSIS

=head1 SUBROUTINES/METHODS

=head2 create

=cut

=head2 build_meta_tags 

OVERIDE build_meta_tags

This builds the meta tags for Schema.org / Google products

Firstly it adds generic meta data which is used in several google products including search snippets.

Then we replicate build_meta_tags using the passed in fields to generate the meta information. I'm currently only 
catering for the google+ Article Card. However I will look into expanding on this.

=cut

=head2 create 

currently only create one card type. 
TODO - figure out the boundaries of schema.org

=cut

=head2 create_card

Fields Required:
* name
* description
* image

=cut

=head1 AUTHOR

Robert Acock <ThisUsedToBeAnEmail@gmail.com>

=head1 TODO
 
    * Improve tests
    * Add Additional Support for schema.org
    * Figure out which meta tags are used
 
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



