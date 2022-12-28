use strict;
use warnings;

use Test::More tests => 9;

use lib qw(.);
use_ok('Snippetizer');

my $s = Snippetizer->new;

isa_ok($s, 'Snippetizer', 'class instantiation');

# Try highlighting an empty document
my $doc = "";
my $query = 'deep dish pizza';
my $expected = "";
my $result = $s->highlight_doc($doc, $query);
ok($result eq $expected, 'empty document');

# Try highlighting nothing
$doc = "I like fish. Little star's deep dish pizza sure is fantastic. Dogs are funny.";
$query = '';
$expected = $doc;
$result = $s->highlight_doc($doc, $query);
ok($result eq $expected, 'empty query string');

# Try highlighting a string that does not appear
$doc = "I like fish. Little star's deep dish pizza sure is fantastic. Dogs are funny.";
$query = 'quick brown fox';
$expected = $doc;
$result = $s->highlight_doc($doc, $query);
ok($result eq $expected, 'non-matching query string');

# Try highlighting a string that occurs once
$doc = "I like fish. Little star's deep dish pizza sure is fantastic. Dogs are funny.";
$query = 'deep dish pizza';
$expected = "I like fish. Little star's [[HIGHLIGHT]]deep dish pizza[[ENDHIGHLIGHT]] sure is fantastic. Dogs are funny.";
$result = $s->highlight_doc($doc, $query);
ok($result eq $expected, 'simple query string');

# Try highlighting a string that occurs more than once
$doc = "I like fish. Little star's deep dish pizza sure is fantastic. Dogs also like deep dish pizza.";
$query = 'deep dish pizza';
$expected = "I like fish. Little star's [[HIGHLIGHT]]deep dish pizza[[ENDHIGHLIGHT]] sure is fantastic. Dogs also like [[HIGHLIGHT]]deep dish pizza[[ENDHIGHLIGHT]].";
$result = $s->highlight_doc($doc, $query);
ok($result eq $expected, 'double query string');

# Try highlighting a string does not occur verbatim
$doc = "I like fish. Little star's DEEP  dish pizzaz sure is fantastic. Dogs are funny.";
$query = 'deep dish pizza';
$expected = "I like fish. Little star's [[HIGHLIGHT]]DEEP  dish pizza[[ENDHIGHLIGHT]]z sure is fantastic. Dogs are funny.";
$result = $s->highlight_doc($doc, $query);
ok($result eq $expected, 'double query string');

# Try highlighting a string that occurs in disjoint parts
$doc = "Little star's deepest deep dish pizza sure is pizza fantastic.";
$query = 'deep dish pizza';
$expected = "Little star's [[HIGHLIGHT]]deep[[ENDHIGHLIGHT]]est [[HIGHLIGHT]]deep dish pizza[[ENDHIGHLIGHT]] sure is [[HIGHLIGHT]]pizza[[ENDHIGHLIGHT]] fantastic.";
$result = $s->highlight_doc($doc, $query);
ok($result eq $expected, 'messy query string');
