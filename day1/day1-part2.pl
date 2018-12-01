#!/usr/bin/perl
use strict;
use warnings;
use Path::Tiny qw< path >;

sub calibrate {
    my ( $lines, $num, $seen ) = @_;

    foreach my $change ( @{$lines} ) {
        ${$num} += $change;
        $seen->{ ${$num} }++
            and return ${$num};
    }

    return;
}

my @lines = path('input')->lines( { 'chomp' => 1 } );
my %seen  = ( 0 => 1 );
my ( $num, $result );

while ( !defined $result ) {
    $result = calibrate( \@lines, \$num, \%seen );
}

print "$result\n";
