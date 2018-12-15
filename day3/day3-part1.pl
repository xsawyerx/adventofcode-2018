#!/usr/bin/perl
use strict;
use warnings;

sub overlapping_squares {
    my @lines = @_;
    my ( %board, $count );

    foreach my $line (@lines) {
        # #123 @ 3,2: 5x4
        # 3 inch from left, 2 inch from top
        # 5 inch wide,      4 inch tall
        my ( $id, $left_edge, $top_edge, $width, $height )
            = $line =~ /^\#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/
            or return;

        foreach my $row ( $top_edge .. ( $top_edge + $height - 1 ) ) {
           foreach my $col ( $left_edge .. ( $left_edge + $width - 1 ) ) {
                $board{"$row,$col"}++;
            }
        }
    }

    # Count how many had over 1 entry
    $board{$_} > 1 and $count++
        for keys %board;

    return $count || 0;
}

# Run when not loaded by test
if ( !caller() ) {
    require Path::Tiny;
    my @lines = Path::Tiny::path('input')->lines( { 'chomp' => 1 } );
    print overlapping_squares(@lines), "\n";
}

