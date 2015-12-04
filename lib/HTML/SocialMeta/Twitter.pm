package HTML::SocialMeta::Twitter;
use Moose;
use namespace::autoclean;
use Carp;

extends 'HTML::SocialMeta::Base';

=head1 NAME

HTML::SocialMeta::Twitter

=head1 DESCRIPTION

Base class to create Twitter Cards

=head1 METHODS

=cut

# Provider Specific Fields 
has 'meta_attribute' => ( isa => 'Str',  is => 'ro', required => 1, default => 'name' );
has 'meta_namespace' => ( isa => 'Str',  is => 'ro', required => 1, default => 'twitter' );

=head2 create 

=cut

sub create {
    my ($self, $card_type) = @_;
    my $card_type = $card_type || $self->card_type;

    if ($card_type eq 'summary'){
        return $self->create_summary_card;
    } elsif ($card_type eq 'featured_image'){
        return $self->create_featured_image_card;
    }

    croak "Sorry we do not currently support this card type" . $card_type;
}

=head2 create_summary_card

Required Fields

* type
* title
* description
* url
* image 
* site_name	

=cut

sub create_summary_card{
    my ($self) = @_;
    $self->card('summary');
    # the required fields needed to build a twitter summary card
    my @fields = ( 'card', 'site', 'title', 'description', 'image' );

    return $self->build_meta_tags(@fields);
}

=head2 create_featured_image_card

Required Fields

* type
* title
* description
* url
* image 
* site_name	


=cut

sub create_featured_image_card{
    my ($self) = @_;

    $self->card('summary_large_image');
    # the required fields needed to build a twitter featured image card
    my @fields = ( 'card', 'site', 'title', 'description', 'image');

    return $self->build_meta_tags(@fields);
}


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

sub create_app_card{
    my ($self) = @_;
    $self->card('app');
    # the required fields needed to build a twitter featured image card
    my @fields = ( 'card', 'site',  'description', 'app_country', 'app_name_store', 'app_id_store', 'app_url_store', 'app_name_play', 'app_id_play', 'app_url_play');

    return $self->build_meta_tags(@fields);
}

#
# The End
#
__PACKAGE__->meta->make_immutable;

1;
