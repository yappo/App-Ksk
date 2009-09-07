#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';

use App::Ksk;

my $run_file = shift || '';
my $script = do {
    open my $fh, '<', $run_file or die "$run_file: $!";
    local $/;
    <$fh>;
};

my($package) = $script =~ /^package\s+([\w_\:]+)/;
require $run_file;

my $opts = {};
if ($package->can('ksk_init')) {
    $opts = $package->ksk_init(@ARGV);
}

$opts->{app} = $package;

App::Ksk->new($opts)->run;
