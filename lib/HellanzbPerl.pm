#!/usr/bin/perl -w

package HellanzbPerl;

use strict;
use warnings;

use Data::Dumper;
use RPC::XML::Client;

my $xmlrpc;

##
# Connect to server
#
sub new
{
    my ($class, $host, $port, $user, $passwd ) = @_;
    bless (my $self = {}, $class);
    $xmlrpc = RPC::XML::Client->new("http://$user:$passwd\@$host:$port");
    return $self;
}

##
# Cancel current download
#
sub cancel
{
    my ($this) = @_;
    $xmlrpc->send_request("cancel");
}

##
# Clear the current nzb queue. Specify True as the second argument to clear anything currently downloading as well (like the cancel call)
#
sub clear
{
    my ($this) = @_;
    $xmlrpc->send_request("clear");
}

##
# Continue downloading after being paused
#
sub continue
{
    my ($this) = @_;
    $xmlrpc->send_request("continue");
}

##
# Pause downloading
#
sub pause
{
    my ($this) = @_;
    $xmlrpc->send_request("pause");
}

##
# Shutdown hellanzb. Will quietly kill any post processing threads that may exist
#
sub shutdown
{
    my ($this) = @_;
    $xmlrpc->send_request("shutdown");
}

##
# Get info aboute queue / processing / downloading
#
sub status
{
    my ($this) = @_;
    my $res = $xmlrpc->send_request("status");
    return $res;
}

1;

##
#   List function TODO :
#
#dequeue nzbid
#    Remove the NZB with specified ID from the queue 
#down nzbid [shift]
#    Move the NZB with the specified ID down in the queue. The optional second argument specifies the number of spaces to shift by (Default: 1) 
#enqueue nzbfile
#    Add the specified NZB file to the end of the queue 
#enqueuenewzbin nzbid
#    Download the NZB with the specified NZB ID from www.newzbin.com, and enqueue it 
#force nzbid
#    Force hellanzb to begin downloading the NZB with the specified ID immediately, interrupting the current download 
#last nzbid
#    Move the NZB with the specified ID to the end of the queue 
#list [excludeids]
#    List the NZBs in the queue, along with their NZB IDs. Specify True as the second argument to exclude the NZB ID in the listing 
#maxrate [newrate]
#    Return the Hellanzb.MAX_RATE (maximum download rate) value. Specify a second argument to change the value -- a value of zero denotes no maximum rate 
#move nzbid index
#    Move the NZB with the specified ID to the specified index in the queue 
#next nzbid
#    Move the NZB with the specified ID to the beginning of the queue 
#process archivedir
#    Post process the specified directory. The -p option is preferable -- it will do this for you, or use the current process if this XML-RPC call fails 
#setrarpass nzbid pass 
#    Set the rarPassword for the NZB with the specified ID
#up nzbid [shift]
#    Move the NZB with the specified ID up in the queue. The optional second argument specifies the number of spaces to shift by (Default: 1) 
