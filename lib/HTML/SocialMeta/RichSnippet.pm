package HTML::SocialMeta::RichSnippet;
use Moose;
use namespace::autoclean;
use Carp;

our $VERSION = '0.5_1';

extends 'HTML::SocialMeta::Base';

# Provider Specific Fields
has 'meta_attribute' =>
  ( isa => 'Str', is => 'ro', required => 1, default => 'itemprop' );
has 'meta_namespace' =>
  ( isa => 'Str', is => 'ro', required => 1, default => 'content' );
has 'item_type' => ( isa => 'Str', is => 'rw', required => 1, default => q{} );

has 'item_scope' => (
    is => 'rw',
    isa => 'HashRef',
    builder => '_build_item_scope',
);

has 'item_type' => (
    is => 'rw',
    isa => 'HashRef',
    builder => '_build_item_type',
);

has '+card_options' => (
	default => sub {
		return {
			summary => q(create_article),
		};
	},
);

has '+build_fields' => (
	default => sub {
		return {
			article => [qw(item_scope item_type headline author description image_object image author logo_object name)],
		};
	},
);

sub create_article {
    my ($self) = @_;
    
    return $self->build_meta_tags('article');
}

sub _build_item_scope {
    return {
        value => q{custom},
        tag => q{div},
        attributes => {
            itemtype => q{http://schema.org/NewsArticle}
        },
    };
}

sub _build_item_type {
    return {
        value => q{custom},
        tag => q{meta},
        attributes => {
            itemprop => q{mainEntityOfPage},
            itemtype => q{https://schema.org/WepPage},
            itemid => q{https://google.com/article}
        }
    };
}

override _convert_field => sub {
    my ( $self, $field ) = @_;

    if ( $field =~ s{player_}{}xms ) {
        return [$field];
    }
    else {
        return [qw(embedURL contentURL)];
    }

};

override _build_field => sub {
    my ( $self, $args) = @_;

    my $field_type = $args->{field_type} || $args->{field};
    my $field = $args->{field};
    my $attribute = $self->meta_attribute;
    my $itemprop = $self->{itemprop};
    my $itemtype = $self->{itemtype};
    my $tag = $self->$field->{tag};


    return sprintf q{<meta %s="%s" content="%s"/>},
       $attribute, $field_type, $self->$field
            if !$self->$field->{tag};

    return sprintf q{<%s %s="%s">%s<%s>},
        $tag, $attribute, $field_type, $self->$field->{value}, $tag  
            if !$self->$field->{attributes};

    my $meta_attributes = $self->$field->{attributes};    

    return sprintf q{<%s itemscope itemtype="%s">},
        $tag, $meta_attributes->{itemtype} 
            if !$meta_attributes->{itemprop};

    return sprintf q{<%s %s="%s" itemscope itemtype="%s">},
        $tag, $attribute, $meta_attributes->{itemprop}, $meta_attributes->{itemtype}
            if !$meta_attributes->{itemid} && !$self->$field->{embed_attribute}; 

    return sprintf q{<%s %s="%s" itemscope itemtype="%s" itemid="%s">},
        $tag, $attribute, $meta_attributes->{itemprop}, $meta_attributes->{itemtype}, $meta_attributes->{itemid}
            if !$self->$field->{embed_attribute};

    # if field has a embedded attribute then render it too
    my $inherit_attributes = $self->$field->{embed_attribute};
    use Data::Dumper;
    warn Dumper $inherit_attributes->{value};
    return sprintf q{<%s %s=%s itemscope itemtype="%s"><%s %s="%s"> %s </%s></%s>},
        $tag, $attribute, $meta_attributes->{itemprop}, $meta_attributes->{itemtype}, $inherit_attributes->{tag}, $attribute, $inherit_attributes->{itemprop}, $inherit_attributes->{value}, $inherit_attributes->{tag}, $tag;

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

=head1 SYNOPSIS

   $schema_meta => HTML::Social::schema->new(
        card_type => 'summary',
        site => '@example_twitter',
        site_name => 'Example Site, anything',
        title => 'You can have any title you wish here',
        description => 'Description goes here may have to do a little validation',
        image => 'www.urltoimage.com/blah.jpg',
        url  => 'www.someurl.com',
        player      => 'www.urltovideo.com/blah.jpg',
        player_width => '500',
        player_height => '500',            
   );

   $schema->create('summary featured_image player');
   
   $schema->create_article;
   $schema->create_offer;
   $schema->create_video;


=head1 SUBROUTINES/METHODS

=head2 card_options

An Hash Reference of card options available for this meta provider, it is used to map the create function when create is called.

=cut

=head2 build_fields 
    
An Hash Reference of fields that are attached to the selected card:

=cut

=head2 create_article

Generate Schema Article meta data

=cut

=head2 create_product

Generate Schema Offer meta data

=cut

=head2 create_video

Generate Schema Video meta data

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
 
Copyright 2016 Robert Acock.
 
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



