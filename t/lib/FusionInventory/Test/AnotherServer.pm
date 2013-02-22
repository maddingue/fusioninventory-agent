package FusionInventory::Test::AnotherServer;

use base qw/FusionInventory::Test::Server/;
use strict;
use warnings;

use English '-no_match_vars';

my $dispatch_table = {};

sub handle_request {
    my $self = shift;
    my $cgi  = shift;

    my $path = $cgi->path_info();
    $path =~ s#\/##;

    my $action = $cgi->param("action");
    my $handler = $dispatch_table->{$action};

    if (!$handler) {
        print "Invalid action\n";
        return;
    }

    my ($content, $code) = $handler->($cgi, $path);

    print "HTTP/1.0 $code OK\r\n";
    print "Content-Type: application/json\r\nContent-Length: ";
    print length($content), "\r\n\r\n", $content;
}

sub set_dispatch {
    my $self = shift;
    $dispatch_table = shift;

    return;
}

1;
