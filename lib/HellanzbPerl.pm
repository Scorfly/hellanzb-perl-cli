#!/usr/bin/perl -w

package HellanzbPerl;

use strict;
use warnings;
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
# go down in the list of file to download
#
sub down
{
    my ($this, $id) = @_;
    $xmlrpc->send_request("down", $id);
}

##
#    Force hellanzb to begin downloading the NZB with the specified ID immediately, interrupting the current download 
#
sub force
{
    my ($this, $id) = @_;
    $xmlrpc->send_request("force", $id);
}

##
#   set it to the last position of the list of file to download
#
sub last
{
    my ($this, $id) = @_;
    $xmlrpc->send_request("last", $id);
}

##
#   set it to the first position of the list of file to download
#
sub next
{
    my ($this, $id) = @_;
    $xmlrpc->send_request("next", $id);
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
#   Remove the NZB with specified ID from the queue
#   info : I had som 8002 error sometimes. I don't know why ...
#
sub remove
{
    my ($this, $id) = @_;
    $xmlrpc->send_request("dequeue", $id);
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

##
#   go up in the list of file to download
#
sub up
{
    my ($this, $id) = @_;
    $xmlrpc->send_request("up", $id);
}

1;
