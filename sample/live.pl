#!/usr/bin/perl -w

use strict;
use warnings;

use CGI;
use CGI::Session;
use CGI::Simple;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use HellanzbPerl;
use POSIX;


my $cgi         = new CGI;
my $session     = new CGI::Session(undef, $cgi, {Directory=>"/tmp"});
my $cgiSimple   = new CGI::Simple;
   $cgiSimple->parse_query_string;

my $action      = $cgiSimple->param('action');
my $actionValue = $cgiSimple->param('value');

# For this sample I let defaut user / pass / port / server of hellanzb
my $xmlrpc = HellanzbPerl->new('localhost', 8760, 'hellanzb', 'changeme');
my $res;

if (defined($action))
{
    if ($action eq 'status')
    {
        $res = $xmlrpc->status();
    }
    elsif ($action eq 'cancel')
    {
        $xmlrpc->cancel();
    }
    elsif ($action eq 'remove')
    {
        $xmlrpc->remove($actionValue);
    }
    elsif ($action eq 'force')
    {
        $xmlrpc->force($actionValue);
    }
    elsif ($action eq 'last')
    {
        $xmlrpc->last($actionValue);
    }
    elsif ($action eq 'down')
    {
        $xmlrpc->down($actionValue);
    }
    elsif ($action eq 'up')
    {
        $xmlrpc->up($actionValue);
    }
    elsif ($action eq 'next')
    {
        $xmlrpc->next($actionValue);
    }
}

print $cgi->header(-type=>'text/html',-expires=>'now',);

if (defined($action) && $action eq 'status')
{
    # in queue
    my $toDownload = $res->{'queued'}[0];
    if ($toDownload ne '')
    {
        print '<div class="panel panel-info" id="toDownload">';
        print ' <div class="panel-heading">';
        print '     <h3 class="panel-title">En file d\'attente</h3>';
        print ' </div>';
        print ' <div class="panel-body">';
        
        my @listToDownload = $res->{'queued'}->value;
        my $listFile = $listToDownload[0];
        foreach my $file (@$listFile)
        {
            print ' <div>
                        <div class="btn-group">
                            <button type="button" class="btn btn-danger glyphicon glyphicon-remove" onClick="ajaxpage(\'live.pl?action=remove&value='.$file->{'id'}.'\', \'file\');setTimeout(\'refreshIt()\',0)"></button>
                            <button type="button" class="btn btn-default glyphicon glyphicon-step-backward" onClick="ajaxpage(\'live.pl?last&value='.$file->{'id'}.'\', \'file\');setTimeout(\'refreshIt()\',0)"></button>
                            <button type="button" class="btn btn-default glyphicon glyphicon-chevron-down" onClick="ajaxpage(\'live.pl?down&value='.$file->{'id'}.'\', \'file\');setTimeout(\'refreshIt()\',0)"></button>
                            <button type="button" class="btn btn-default glyphicon glyphicon-chevron-up" onClick="ajaxpage(\'live.pl?up&value='.$file->{'id'}.'\', \'file\');setTimeout(\'refreshIt()\',0)"></button>
                            <button type="button" class="btn btn-default glyphicon glyphicon-step-forward" onClick="ajaxpage(\'live.pl?next&value='.$file->{'id'}.'\', \'file\');setTimeout(\'refreshIt()\',0)"></button>
                            <button type="button" class="btn btn-success glyphicon glyphicon-play" onClick="ajaxpage(\'live.pl?force&value='.$file->{'id'}.'\', \'file\');setTimeout(\'refreshIt()\',0)"></button>
                        </div> 
                        <span class="label label-default">'.$file->{'nzbName'}.'</span>
                    </div>';
        }

        print ' </div>';
        print '</div>';
    }

    # traitement en cour
    # TODO

    # downloading
    my $downloading = $res->{'currently_downloading'}[0];
    if ($downloading ne '')
    {
        print '<div class="panel panel-primary" id="downloading">';
        print ' <div class="panel-heading">';
        print '     <h3 class="panel-title">En Telechargement</h3>';
        print ' </div>';
        print ' <div class="panel-body">';
        print '<div class="btn-group"><button type="button" class="btn btn-danger glyphicon glyphicon-remove" onClick="ajaxpage(\'live.pl?action=cancel\', \'file\')"></button> </div>';
            print '<span class="label label-primary">'.$downloading->{'nzbName'}->value . '</span> ';
            print '<span class="label label-success">Total : ' . $downloading->{'total_mb'}->value . "MB</span> ";
            print '<span class="label label-danger">Restant : ' . $res->{'queued_mb'}->value . 'MB</span> ';
            print '<span class="label label-info"> Speed : ' . $res->{'rate'}->value . " KB/s</span> ";

            my $percentComplete = floor((1-($res->{'queued_mb'}->value/$downloading->{'total_mb'}->value))*100);
            print '<span class="label label-warning">'.$percentComplete."%</span> ";
            print '<div class="progress"> <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="'.$percentComplete.'" aria-valuemin="0" aria-valuemax="100" style="width: '.$percentComplete.'%"><span class="sr-only">'.$percentComplete.'% Complete (success)</span></div></div>';

        print ' </div>';
        print "</div>";    
    } 
}
