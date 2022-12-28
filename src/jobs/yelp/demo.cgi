#!/usr/bin/perl -wT

delete $ENV{PATH};
use strict;

use lib qw(.);
use CGI;
use Template;
use Snippetizer;

my $cgi = CGI->new();
print $cgi->header();

my $s = Snippetizer->new();
my $doc = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut eleifend diam et turpis mollis iaculis. Morbi lobortis, nunc eget luctus elementum, elit velit dignissim enim, eu blandit ipsum purus et sapien. Nullam aliquet egestas mi posuere imperdiet. Mauris non lacus nec ipsum rutrum euismod id quis magna. Quisque et nunc ipsum. Vestibulum interdum tortor nibh, vitae ultrices sapien. Pellentesque faucibus elementum ante nec condimentum. Ut est libero, volutpat at suscipit in, sollicitudin vel turpis. Proin sit amet justo non elit congue cursus quis ac magna. Curabitur eget lectus vitae purus porta malesuada nec quis ipsum. Nullam ut massa quis arcu eleifend lacinia. Cras ac ipsum nec nunc ultrices feugiat ac vel orci. Quisque suscipit augue in velit porta at varius diam consequat. Donec augue nulla, venenatis lobortis semper in, blandit non tortor. Nam gravida molestie quam. Cras purus nunc, posuere sed fermentum ac, elementum et libero. 123 Fake Street\n\nFusce et urna eget lorem auctor commodo. Maecenas felis dui, adipiscing sit amet elementum a, tempus id diam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce felis nisi, pellentesque vel vulputate quis, dictum vitae dolor. Proin facilisis lorem sed eros feugiat et faucibus lorem sagittis. Nunc pulvinar suscipit pulvinar. Morbi condimentum nisl at justo consequat sodales. Vestibulum feugiat euismod ipsum quis mollis. Aliquam erat volutpat. Praesent rhoncus euismod enim, quis dapibus massa fringilla vel. Cras eleifend dolor non metus tristique mattis. Etiam tempor tempor felis. Maecenas vitae tellus id mauris euismod eleifend. Nam vehicula dolor a ipsum eleifend ut consectetur est dignissim. Suspendisse facilisis elementum venenatis. Nam sit amet diam lacus, ac luctus neque. Duis pellentesque erat at lorem ornare mollis. Aenean quis sapien nunc. Vivamus blandit feugiat lectus, placerat lacinia metus porta vel. Nunc in nisi magna.";
my $query = join(' ', $cgi->param('query'));
my $result = $s->highlight_doc($doc, $query);

my $vars = {
    'query' => $query,
    'result' => $result,
};

my $tmpl = join("", <DATA>);
my $tt = new Template || die "$Template::ERROR\n";
$tt->process(\$tmpl, $vars) || die $tt->error(), "\n";

__DATA__
<html>
<head>
<title>Snippetizer Demo Page</title>
<style type="text/css">
    .snippet {
        text-decoration: underline;
        font-weight: bold;
    }
</style>
</head>
<body>
<h1>Snippetizer Demo Page</h1>
<form>
    <label for="query">Query: </label>
    <input id="query" name="query" value="[% query FILTER html %]">
    <input type="submit" value="Snippetize">
</form>
<hr>
<p>
[%# show the whole result with snippets marked up %]
[% result
    | html
    | html_break
    | replace('\[\[HIGHLIGHT\]\]','<span class="snippet">')
    | replace('\[\[ENDHIGHLIGHT\]\]', '</span>') %]
</p>
<hr>
<p>
[%# truncate non-matching areas %]
[% IF result.match('\[\[HIGHLIGHT\]\]') %]
    [% result = result.replace('(?s:^.*?(\b.{2,20}\[\[HIGHLIGHT\]\]))',' ... $1') %]
    [% result = result.replace('(?s:(\[\[ENDHIGHLIGHT\]\][^][]{2,20})\s.*?\s([^][]{2,20}\[\[HIGHLIGHT\]\]))',"\$1 ...\n\n... \$2") %]
    [% result = result.replace('(?s:(.*\[\[ENDHIGHLIGHT\]\].{2,20}\b).*?$)','$1 ...') %]
    [% result
        | html
        | html_break
        | replace('\[\[HIGHLIGHT\]\]','<span class="snippet">')
        | replace('\[\[ENDHIGHLIGHT\]\]', '</span>') %]
[% END %]
</p>
</body>
</html>

