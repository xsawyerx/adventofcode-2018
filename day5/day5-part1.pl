#!/usr/bin/perl
use strict;
use warnings;
use constant { 'DEBUG' => 0 };
use Path::Tiny qw< path >;

chomp( my $string = path('input')->slurp );
my @chars  = split //, $string;
my %lookup = map +(
    $_    => uc $_,
    uc $_ => $_
), 'a' .. 'z';

for ( my $i = 0; $i < $#chars; $i++ ) {
    if ( DEBUG() ) {
        print "[$i] $string\n";
        print "    ";
        for ( my $j = 0; $j <= $#chars; $j++ ) {
            print $j == $i ? '^' : $j == $i + 1 ? '^' : ' ';
        }
        print "\n";
    }

    # Only inspect when we need
    $chars[ $i + 1 ] eq $lookup{ $chars[$i] }
        or next;

    splice @chars, $i, 2;  # Remove characters
    $i -= $i == 0 ? 1 : 2; # Update index
}

print "Length: @{[ scalar @chars ]}\n";
