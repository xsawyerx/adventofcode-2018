#!/usr/bin/perl
use strict;
use warnings;
use constant { 'DEBUG' => 0 };
use Path::Tiny qw< path >;

my %lookup = map +(
    $_    => uc $_,
    uc $_ => $_
), 'a' .. 'z';

my %lengths;

foreach my $letter ( 'a' .. 'z' ) {
    chomp( my $string = path('input')->slurp );
    $string =~ s/$letter//ig;

    my @chars  = split //, $string;
    my $length = $#chars;

    for ( my $i = 0; $i < $length; $i++ ) {
        if ( DEBUG() ) {
            print "[$i] $string\n";
            print "    ";
            for ( my $j = 0; $j <= $length; $j++ ) {
                print $j == $i ? '^' : $j == $i + 1 ? '^' : ' ';
            }
            print "\n";
        }

        # Only inspect when we need
        $chars[ $i + 1 ] eq $lookup{ $chars[$i] }
            or next;

        splice @chars, $i, 2;  # Remove characters
        $length -= 2;          # Update length
        $i -= $i == 0 ? 1 : 2; # Update index
    }

    $lengths{$letter} = scalar @chars;
}

my $shortest = $lengths{ (
    sort { $lengths{$a} <=> $lengths{$b} } keys %lengths
)[0] };

print "$shortest\n";
