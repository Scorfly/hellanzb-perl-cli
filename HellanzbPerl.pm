#!/usr/bin/perl -w

package HellanzbPerl;

use strict;
use warnings;

use Data::Dumper;

##
# Connect to server  
#
sub hellanzbConnect 
{

    # This is defaut user / pass / serveur with hellanzb. 
    # TODO : define it with a config file

    my $host    = 'localhost';
    my $port    =  8760;
    my $user    = 'hellanzb';
    my $passwd  = 'changeme';
    my $disk    = '/media/download/usenet';

    my $xmlrpc = RPC::XML::Client->new("http://$user:$passwd\@$host:$port");
    return $xmlrpc;
}

##
# Get info aboute queue / processing / downloading
#
sub hellanzbStatus
{
    my $xmlrpc  = hellanzbConnect();
    my $res = $xmlrpc->send_request("status");
    return $res;
}

##
#   Cancel current download
#
sub hellanzbCancel
{
    my $xmlrpc  = hellanzbConnect();
    $xmlrpc->send_request("cancel");
}

1;
