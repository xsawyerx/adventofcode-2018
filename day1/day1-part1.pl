#!/usr/bin/perl
use strict;
use warnings;
use Path::Tiny qw< path >;

my $num;
$num += $_ for path('input')->lines({ 'chomp' => 1 });
print "$num\n";
