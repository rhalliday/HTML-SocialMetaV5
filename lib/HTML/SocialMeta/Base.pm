package HTML::SocialMeta::Base;
use Moose;
use namespace::autoclean;
use Carp;

=head1 NAME

HTML::SocialMeta::BASE - Base class for the different meta classes.

=head1 DESCRIPTION

builds and returns the Meta Tags

=cut

# A list of fields which the cards may possibly use
has 'card_type' => ( isa => 'Str',  is => 'rw', lazy => 1, default => '' );
has 'card' => ( isa => 'Str',  is => 'rw', lazy => 1, default => '' );
has 'type' => ( isa => 'Str',  is => 'rw', lazy => 1, default => '' );
has 'name' => ( isa => 'Str',  is => 'rw', lazy => 1, default => '' );
has 'site' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'url' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'site_name' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'title' => ( isa => 'Str',  is => 'ro',  lazy => 1, default => '' );
has 'description' => ( isa => 'Str',  is => 'ro',  lazy => 1, default => '' );
has 'image' => ( isa => 'Str',  is => 'ro',  lazy => 1, default => '' );
has 'app_country' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'app_name_store' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'app_id_store' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'app_url_store' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'app_name_play' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'app_id_play' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'app_url_play' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );

=head2 build_meta_tags 

This builds the meta tags for Twitter and OpenGraph

It takes an array of fields, which loops through firstly checking 
that we have a value set and then actually building the specific tag
for that field.

=cut

sub build_meta_tags {
    my ($self, @fields) = @_;

    my @meta_tags;
    foreach my $field (@fields){
        # check the field has a value set
        $self->_validate_field_value($field);

        push @meta_tags, $self->_generate_meta_tag($field);
    }

   return join("\n", @meta_tags);
}

sub _validate_field_value {
    my ($self, $field) = @_;
	
	# look to see we have the fields atrribute set
    croak "you have not set this field value " . $field unless 
        $self->$field;

    return;
}

sub _generate_meta_tag {
    my ($self, $field) = @_;

    # just build the meta tag if this is not an app field
    return $self->_build_field($field) if $field !~ /^app/;

    my @tags = ();
    # convert the field into separate apps and get the tags
    push @tags, $self->_build_field($field, $_) for (@{$self->_convert_field($field)});

    return @tags;
}

sub _build_field {
  my ($self, $field, $field_type) = @_;

  $field_type = $field_type ? $field_type : $field;

  return '<meta ' . $self->meta_attribute . '="' . $self->meta_namespace . ':' . $field_type . '" content="' . $self->$field . '"/>';  
}

sub _convert_field {
    my ($self, $field) = @_;
   
    $field =~ tr/_/:/;

    my @app_fields;
    if ( $field =~ s/store// ) {

        push @app_fields, $field . 'iphone';
        push @app_fields, $field . 'ipad';  

    } elsif ($field =~ s/play//){

        push @app_fields, $field . 'googleplay';

    } else {

        push @app_fields, $field;

    }

    return \@app_fields;
}




#
# The End
#
__PACKAGE__->meta->make_immutable;

1;

=head1 LICENSE AND COPYRIGHT
