#!/usr/bin/perl
use strict;
use warnings;
use Path::Tiny qw< path >;

my @lines = path('input')->lines( { 'chomp' => 1 } );

my ( %cache, $pair );
# Brute-force, for on for, I don't like it
foreach my $first_word (@lines) {
    my @first_letters = split //, $first_word;

    foreach my $second_word (@lines) {
        # at least avoid hitting the same pair twice
        $cache{$first_word}{$second_word}++ and next;
        $cache{$second_word}{$first_word}++ and next;

        my @second_letters = split //, $second_word;

        # sanity check
        @first_letters == @second_letters
            or die "Different sizes for '$first_word' and '$second_word'\n";

        my $mismatch = 0;
        for my $idx ( 0 .. $#first_letters ) {
            if ( $first_letters[$idx] ne $second_letters[$idx] ) {
                $mismatch++;
            }
        }

        $mismatch == 1
            or next;

        # sanity check
        $pair and die "We already picked a pair\n";

        $pair = [ \@first_letters, \@second_letters ];
    }
}

my $matching_chars;
for ( 0 .. $#{ $pair->[0] } ) {
    $pair->[0][$_] eq $pair->[1][$_]
        and $matching_chars .= $pair->[0][$_];
}

print "Matching characters: $matching_chars\n";
