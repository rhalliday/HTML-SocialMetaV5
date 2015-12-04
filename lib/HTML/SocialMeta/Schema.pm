package HTML::SocialMeta::Schema;
use Moose;
use namespace::autoclean;
use Carp;

extends 'HTML::SocialMeta::Base';

=head1 NAME

HTML::SocialMeta::Schema.

=head1 DESCRIPTION

Base class for creating Schema meta data

=head1 METHODS

=cut

# Provider Specific Fields 
has 'meta_attribute' => ( isa => 'Str',  is => 'ro', required => 1, default => 'itemprop' );
has 'meta_namespace' => ( isa => 'Str',  is => 'ro', required => 1, default => '' );

=head2 create 

currently only create one card type. 
TODO - figure out the boundaries of schema.org

=cut

sub create {
    my ($self) = @_;

    return $self->create_card;
}

=head2 create_card

Fields Required:
* name
* description
* image

=cut

sub create_card{
    my ($self) = @_;

    # the required fields needed to build a twitter summary card
    my @fields = ( 'name', 'description', 'image');

    return $self->build_meta_tags(@fields);
}


=head2 build_meta_tags 

OVERIDE build_meta_tags

This builds the meta tags for Schema.org / Google products

Firstly it adds generic meta data which is used in several google products including search snippets.

Then we replicate build_meta_tags using the passed in fields to generate the meta information. I'm currently only 
catering for the google+ Article Card. However I will look into expanding on this.

=cut

sub build_meta_tags {
    my ($self, @fields) = @_;

    my @meta_tags;  
    # specifiying this is an Google Article - eventually this will be modified
    push @meta_tags, '<html itemscope itemtype="http://schema.org/Article">';

    # google snippet
    push @meta_tags, '<title>' . $self->name .  '</title>';
    push @meta_tags, '<meta name="description" content="' . $self->description . '">';

    foreach my $field (@fields){
        # check the field has a value set
        $self->_validate_field_value($field);

       	push @meta_tags, $self->_build_field($field);
    }
 
    return join("\n", @meta_tags); 
}

sub _build_field {
  my ($self, $field, $field_type) = @_;

  $field_type = $field_type ? $field_type : $field;

  return '<meta ' . $self->meta_attribute . '="' . $field . '" content="' . $self->$field . '"/>';  
}

#
# The End
#
__PACKAGE__->meta->make_immutable;

1;
