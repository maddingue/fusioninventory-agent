package FusionInventory::Agent::Task::Inventory::OS::HPUX::Softwares;

use strict;
use warnings;

use FusionInventory::Agent::Tools;

sub isInventoryEnabled  {
    my (%params) = @_;

    return
        !$params{no_software} &&
        can_run('swlist');
}

sub doInventory {
    my (%params) = @_;

    my $inventory = $params{inventory};
    my $logger    = $params{logger};

    my $list = _getSoftwaresList(
        command => 'swlist',
        logger => $logger
    );

    return unless $list;

    foreach my $software (@$list) {
        $inventory->addEntry(
            section => 'SOFTWARES',
            entry   => $software
        );
    }
}

sub _getSoftwaresList {
    my $handle = getFileHandle(@_);
    return unless $handle;

    my @softwares;
    while (my $line = <$handle>) {
        chomp $line;
        next unless $line =~ /^  (\S+)\s+(\S+)\s+(\S.*\S)/;
        next if $1 =~ /^PH/;
        push @softwares, {
            NAME      => $1,
            VERSION   => $2,
            COMMENTS  => $3,
            PUBLISHER => 'HP'
        };
    }

    close $handle;

    return \@softwares;
}

1;
