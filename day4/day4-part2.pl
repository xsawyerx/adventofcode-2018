#!/usr/bin/perl
use strict;
use warnings;

sub find_guard2 {
    my @lines  = @_;
    my ( $state, $id, $started_sleep );
    my %guards;

    my $REGEX = qr{
        ^
        \[
            (\d+) - (\d+) - (\d+) \s ( \d+ ):( \d+ )
        \]
    }x;

    my @sorted_lines = sort {
        my @data_for_a = $a =~ $REGEX;
        my @data_for_b = $b =~ $REGEX;

        $data_for_a[0] <=> $data_for_b[0] ||
        $data_for_a[1] <=> $data_for_b[1] ||
        $data_for_a[2] <=> $data_for_b[2] ||
        $data_for_a[3] <=> $data_for_b[3] ||
        $data_for_a[4] <=> $data_for_b[4]
    } @lines;

    foreach my $line (@sorted_lines) {
        my ( $year, $month, $day, $hour, $minute ) = $line =~ $REGEX
            or return;

        # Mark the guard as starting
        if ( $line =~ /Guard \#(\d+) begins shift/ ) {
            $id = $1;
            next;
        }

        # Just some health check
        $hour != 0
            and die "Got an action not at midnight: $line\n";

        # Mark when they fell asleep
        $line =~ /falls asleep/
            and $started_sleep = $minute;

        # They woke up, count all the time asleep
        $line =~ /wakes up/
            and
            @{ $guards{"$year$month$day"}{$id} }[ $started_sleep .. $minute ]
            = split //, 1 x ( $minute - $started_sleep );
    }

    # guard with most minutes asleep
    return sleepiest_guard_for_minute( \%guards );
}

sub sleepiest_guard_for_minute {
    my $data = shift;
    my ( $longest, $longest_id, $longest_minute ) = (0);
    my %by_minute;

    # what the hell am I doing here?
    foreach my $date ( keys %{$data} ) {
        foreach my $id ( keys %{ $data->{$date} } ) {
            foreach my $min_idx ( 0 .. $#{ $data->{$date}{$id} } ) {
                if ( $data->{$date}{$id}[$min_idx] ) {
                    if ( ++$by_minute{$min_idx}{$id} > $longest ) {
                        $longest        = $by_minute{$min_idx}{$id};
                        $longest_id     = $id;
                        $longest_minute = $min_idx;
                    }
                }
            }
        }
    }

    return $longest_minute * $longest_id;
}

if ( !caller() ) {
    require Path::Tiny;
    print find_guard2( Path::Tiny::path('input')->lines( { 'chomp' => 1 } ) ), "\n";
}
