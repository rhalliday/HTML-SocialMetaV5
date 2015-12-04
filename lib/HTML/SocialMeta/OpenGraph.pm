package HTML::SocialMeta::OpenGraph;
use Moose;
use namespace::autoclean;
use Carp;

extends 'HTML::SocialMeta::Base';

=head1 NAME

HTML::SocialMeta::OpenGraph

=head1 DESCRIPTION

Base class for creating OpenGraph meta data

=head1 METHODS

=cut

# Provider Specific Fields 
has 'meta_attribute' => ( isa => 'Str',  is => 'ro', required => 1, default => 'property' );
has 'meta_namespace' => ( isa => 'Str',  is => 'ro', required => 1, default => 'og' );

=head2 create 

current card options
* summary
* featured_image

=cut

sub create {
    my ($self, $card_type) = @_;
    
    $card_type ||= $self->card_type;

    if ($card_type eq 'summary'){
        return $self->create_thumbnail_card;
    } elsif ($card_type eq 'featured_image'){
        return $self->create_article_card;
    }

    croak "Sorry we do not currently support this card type " . $card_type;
}

=head2 create_thumbnail_card 

Required Fields

* type
* title
* description
* url
* image 
* site_name	

=cut

sub create_thumbnail_card{
    my ($self) = @_;

    $self->type('thumbnail');
    # the required fields needed to build a twitter summary card
    my @fields = ( 'type', 'title', 'description', 'url', 'image', 'site_name' );

    return $self->build_meta_tags(@fields);
}

=head2 create_article_card

Required Fields

* type
* title
* description
* url
* image 
* site_name	

=cut

sub create_article_card{
    my ($self) = @_;

    $self->type('article');
    # the required fields needed to build a twitter featured image card
    my @fields = ( 'type', 'title', 'description', 'url', 'image', 'site_name');

    return $self->build_meta_tags(@fields);
}

#
# The End
#
__PACKAGE__->meta->make_immutable;

1;
