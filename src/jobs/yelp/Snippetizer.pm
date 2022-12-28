=head1 NAME

Snippetizer - highlight words of interest in a document

=head1 SYNOPSIS

    use Snippetizer;
    
    my $s = Snippetizer->new();
    print $s->highlight_doc("Hello, world!", "world");
    
    "Hello, [[HIGHLIGHT]]world[[ENDHIGHLIGHT]]!"

=cut

package Snippetizer;

use strict;
use warnings;

use Text::ParseWords qw(quotewords);


=head1 METHODS

=over 4

=item C<new(config)>

Constructor. Configuration is provided as a hashref argument. With no arguments,
will use the default configuration:

    {
        'start_string' => '[[HIGHLIGHT]]',
        'end_string'   => '[[ENDHIGHLIGHT]]',
    }

=cut

sub new {
    my $class = shift;
    my ($config) = @_;
    
    my $self = {};
    if (ref $config eq 'HASH') {
        $self = $config;
    };
    
    # provide default configuration
    my $default_config = {
        'start_string' => '[[HIGHLIGHT]]',
        'end_string'   => '[[ENDHIGHLIGHT]]'
    };
    foreach my $key (keys %$default_config) {
        $self->{$key} = $default_config->{$key} unless exists $self->{$key};
    }
    
    bless($self, $class);
    return $self;
}

=item C<naive_highlight_doc(doc, query)>

Highlight a string of interest in a document. This implementation attempts to
find the entire query as entered, including word order, punctuation, and whitespace.

=cut


sub naive_highlight_doc {
    my $self = shift;
    my ($doc, $query) = @_;
    
    $doc =~ s/(\Q$query\E)/$self->{start_string}$1$self->{end_string}/ig;
    
    return $doc;
}

=item C<highlight_doc(doc, query)>

Highlight words of interest in a document. This implementation splits the input
into words separated by whitespace and phrases surrounded by single or double
quotes. Adjacent words joined by punctuation are also treated as phrases. Treats
all non-word characters as interchangeable.

=cut

sub highlight_doc {
    my $self = shift;
    my ($doc, $query) = @_;
    
    return '' unless defined $doc;
    return $doc unless defined $query;

    my $s = $self->{'start_string'};
    my $e = $self->{'end_string'};
    
    # escape special characters in query to make it play nice with quotewords
    # and as input to a regex
    $query =~ s{\\}{\\\\}g;

    # split apart query words on whitespace and quotes
    my @query_words = quotewords('\s+', 0, $query);
    foreach my $word (@query_words) {
        # treat all non-word characters as interchangeable
        $word =~ s/(\W+)/\\W\+/g;

        # insert highlights around each query word found on at least one word boundary
        $doc =~ s/($word\b|\b$word)/$s$1$e/ig;
    }
    
    # combine adjacent highlights
    $doc =~ s/\Q$e\E(\s+)\Q$s\E/$1/g;
    
    return $doc;
}

1;
