#!/usr/bin/perl -w

use strict;
use warnings;

use CGI;
use CGI::Session;
use CGI::Simple;
use FindBin qw($Bin);
use lib "$Bin/..//lib";
use HellanzbPerl;

my $cgi         = new CGI;
my $session     = new CGI::Session(undef, $cgi, {Directory=>"/tmp"});
my $cgiSimple   = new CGI::Simple;
   $cgiSimple->parse_query_string;

print $cgi->header(-type=>'text/html',-expires=>'now',);
print '
<html>
    <head>
        <title>Hellanzb-Perl-Cli sample</title>
        <link href="./css/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" media="screen" href="./css/style.css" />
        <script type="text/javascript" src="./javascript/script.js"></script>
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.9.0.js"></script>
        <script type="text/javascript" src="./javascript/bootstrap.min.js"></script>
    </head>
    <body onload="setTimeout(\'refreshIt()\',0)">
        <nav class="navbar navbar-inverse" role="navigation">
            <div class="navbar-inner">
                <ul class="nav navbar-nav">
                    <a class="navbar-brand" href="#"><span class="glyphicon glyphicon-home"></span> Hellanzb-Perl-Cli</a>
                </ul>
            </div>
        </nav>
        <div id="content">
            <div id="status">
            </div>
        </div>
    </body>
</html>';
