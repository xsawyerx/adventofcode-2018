#!/usr/bin/perl
use strict;
use warnings;

sub nonoverlapping_squares {
    my @lines = @_;
    my ( %board, %ids );

    foreach my $line (@lines) {
        # #123 @ 3,2: 5x4
        # 3 inch from left, 2 inch from top
        # 5 inch wide,      4 inch tall
        my ( $id, $left_edge, $top_edge, $width, $height )
            = $line =~ /^\#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/
            or return;

        $ids{$id} = 1;

        foreach my $row ( $top_edge .. ( $top_edge + $height - 1 ) ) {
           foreach my $col ( $left_edge .. ( $left_edge + $width - 1 ) ) {
                push @{ $board{"$row,$col"} }, $id;
            }
        }
    }

    foreach my $row_col ( keys %board ) {
        @{ $board{$row_col} } > 1
            and delete @ids{ @{ $board{$row_col} } };
    }

    return keys %ids;
}

# Run when not loaded by test
if ( !caller() ) {
    require Path::Tiny;
    my @lines = Path::Tiny::path('input')->lines( { 'chomp' => 1 } );
    print nonoverlapping_squares(@lines), "\n";
}

