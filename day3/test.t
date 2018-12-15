use strict;
use warnings;
use Test::More;

do './day3-part1.pl';
do './day3-part2.pl';

my @input_lines = (
    '#1 @ 1,3: 4x4',
    '#2 @ 3,1: 4x4',
    '#3 @ 5,5: 2x2',
);

is(
    overlapping_squares(@input_lines),
    4,
    'Exactly 4 overlapping squares',
);

is_deeply(
    [ nonoverlapping_squares(@input_lines) ],
    [3],
    '3 is not overlapping at all',
);

done_testing();
