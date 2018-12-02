#!/usr/bin/perl
use strict;
use warnings;
use Path::Tiny qw< path >;

my ( $double, $triple ) = ( 0, 0 );

foreach my $line ( path('input')->lines( { 'chomp' => 1 } ) ) {
    my %seen;
    foreach my $letter ( split //, $line ) {
        $seen{$letter}++ and next; # uniqify along the way
        my @times = $line =~ /\Q$letter\E/g;
        $seen{ scalar @times } = 1; # uniqify again on occurrences
    }

    # make sure to only increment once, even if multiple occurrences
    $double += $seen{'2'} || 0;
    $triple += $seen{'3'} || 0;
}

printf "$double * $triple = %d\n", $double * $triple;

