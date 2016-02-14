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
has 'meta_scope' =>
   ( isa => 'Str', is => 'ro', required => 1, default => 'itemscope' );
has 'meta_type' => 
    ( isa => 'Str', is => 'ro', required => 1, default => 'itemtype' );
has 'meta_id' =>
    ( isa => 'Str', is => 'ro', required => 1, default => 'itemid' );

has 'item_scope' => (
    is => 'rw',
    isa => 'HashRef',
    lazy => 1,
    default => sub {
        return {
            value => q{custom},
            tag => q{div},
            itemtype => q{http://schema.org/NewsArticle}
        }
    }
);

has 'item_type' => (
    is => 'rw',
    isa => 'HashRef',
    lazy => 1,
    default => sub {
        return { 
            value => q{custom},
            tag => q{meta},
            itemprop => q{mainEntityOfPage},
            itemtype => q{https://schema.org/WepPage},
            itemid => q{https://google.com/article}
        }
    }

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
			article => [qw(item_scope item_type headline author description image_object publisher)],
		};
	},
);

sub create_article {
    my ($self) = @_;
    
    return $self->build_meta_tags('article');
}

override _generate_meta_tag => sub {
    my ( $self, $field ) = @_;

    use Data::Dumper;
    # if we do not have embed_meta then just build the field
    return $self->_build_field( $self->$field )
        if !$self->$field->{embed_meta}; 

    my @tags = ();
    
    # covert the field into multiple fields
    for ( @{ $self->_convert_field($field) }) {

        push @tags, $self->_build_field({ %{$_} });
    }
    
    #push @tags, $self->_build_field({ tag => $self->item_scope->{tag} });

    return @tags;
};

override _convert_field => sub{
    my ($self, $field) = @_;
    
    return [$self->build_embed_structure($field, $self->$field)];
};

sub build_embed_structure {
    my ($self, $field, $field_hash) = @_; 

    # outa field first
    my $field_args = { field => $field, tag =>  $field_hash->{tag}};
  
    # if we have these then add them
    $field_args->{itemtype} = $field_hash->{itemtype} if $field_hash->{itemtype};  
    $field_args->{itemprop} = $field_hash->{itemprop} if $field_hash->{itemprop}; 
    $field_args->{itemid} = $field_hash->{itemid} if $field_hash->{itemid};
    $field_args->{value} = $field_hash->{value} if $field_hash->{value};
    
    my $embed_meta = $field_hash->{embed_meta};

    return $field_args unless $embed_meta;
    my @tags;
    push @tags, $field_args;

    foreach my $tag (keys %{ $embed_meta }) {
        $field_args = $self->build_embed_structure($tag, $embed_meta->{$tag});
        push @tags, $field_args;
    }
    
    push @tags, { tag => $field_hash->{tag} };
   
    warn Dumper @tags; 
    return @tags; 
}

override _build_field => sub {
    my ( $self, $args) = @_;
    # field args
    my $tag = $args->{tag};
    my $itemprop = $args->{itemprop};
    my $itemtype = $args->{itemtype};
    my $itemid = $args->{itemid};
    my $value = $args->{value};
    # global args
    my $meta_att = $self->meta_attribute;
    my $meta_name = $self->meta_namespace;
    my $meta_scope = $self->meta_scope;
    my $meta_type = $self->meta_type;
    my $meta_id = $self->meta_id;
 
    # <tag itemscope itemprop="field" itemtype="url" itemid="some google url" />
    return sprintf q{<%s %s %s="%s" %s="%s" %s="%s"/>},
        $tag, $meta_scope, $meta_att, $itemprop, $meta_type, $itemtype, $meta_id, $itemid  
            if $itemid;
    
    # <tag itemprop="itemprop" itemscope content="itemtype" />
    return sprintf q{<%s %s="%s" %s %s="%s"/>},
        $tag, $meta_att, $itemprop, $meta_scope, $meta_name, $itemtype
            if $itemprop && $itemtype;
    
    # <tag itemprop="itemprop" content="value" />
    return sprintf q{<%s %s="%s" %s="%s"/>},
        $tag, $meta_att, $itemprop, $meta_name, $value
            if $tag eq q{meta};
    
    # <tag itemscope itemtype="url">
    return sprintf q{<%s %s %s="%s">},
        $tag, $meta_scope, $meta_type, $itemtype
            if $itemtype;
    
    # <tag itemtype="url">
    return sprintf q{<%s src="%s">},
        $tag, $value
            if $tag eq q{img};

    # <tag itemprop="field">value</tag>
    return sprintf q{<%s %s="%s">%s</%s>},
        $tag, $meta_att, $itemprop, $value, $tag
            if $value;
    
    # </tag>
    return sprintf q{</%s>},
        $tag;
};

#
# The End
#
__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::SocialMeta::RichSnippet

=head1 VERSION

Version 0.2

=cut

=head1 DESCRIPTION

Base class for creating Schema.org Rich Snippet microdata

=head1 SYNOPSIS

   $schema_meta => HTML::Social::richsnippet->new(
   

    );

   $schema->create('summary');
   
   $schema->create_article;


=head1 SUBROUTINES/METHODS

=head2 card_options

A Hash Reference of card options available for this meta provider, it is used to map the create function when create is called.

=cut

=head2 build_fields 
    
A Hash Reference of fields that are attached to the selected card:

=cut

=head2 create_article

Generate Schema.org Rich Snippet Article microdata

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



