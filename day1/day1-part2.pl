#!/usr/bin/perl
use strict;
use warnings;
use Path::Tiny qw< path >;

## Solution 1: Using a function
sub calibrate {
    my ( $lines, $num, $seen ) = @_;

    foreach my $change ( @{$lines} ) {
        ${$num} += $change;
        $seen->{ ${$num} }++
            and return ${$num};
    }

    return;
}

sub solution_1 {
    my @lines = path('input')->lines( { 'chomp' => 1 } );
    my %seen  = ( 0 => 1 );
    my ( $num, $result );

    while ( !defined $result ) {
        $result = calibrate( \@lines, \$num, \%seen );
    }

    print "$result\n";
}

## Solution 2: Using a callback function
sub solution_2 {
    my @lines = path('input')->lines( { 'chomp' => 1 } );
    my %seen  = ( 0 => 1 );
    my ( $num, $result );

    my $calibrate = sub {
        foreach my $change (@lines) {
            $num += $change;
            $seen{$num}++
                and return $num;
        }

        return;
    };

    while ( !defined $result ) {
        $result = $calibrate->();
    }

    print "$result\n";
}

solution_2();
