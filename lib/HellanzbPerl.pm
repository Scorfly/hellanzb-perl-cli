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
# Get info aboute queue / processing / downloading
#
sub status
{
    my ($this) = @_;
    my $res = $xmlrpc->send_request("status");
    return $res;
}

##
# Cancel current download
#
sub cancel
{
    my ($this) = @_;
    $xmlrpc->send_request("cancel");
}

1;
