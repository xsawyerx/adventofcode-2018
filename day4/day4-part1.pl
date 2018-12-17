#!/usr/bin/perl
use strict;
use warnings;

sub find_guard {
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
    my $worst_guard  = sleepiest_guard( \%guards );
    my $worst_minute = sleepiest_minute( \%guards, $worst_guard );

    return $worst_guard * $worst_minute;
}

sub sleepiest_guard {
    my $data = shift;
    my %by_id;
    foreach my $date ( keys %{$data} ) {
        foreach my $id ( keys %{ $data->{$date} } ) {
            $by_id{$id} += grep $_, @{ $data->{$date}{$id} };
        }
    }

    
    return ( sort { $by_id{$b} <=> $by_id{$a} } keys %by_id )[0];
}

sub sleepiest_minute {
    my ( $data, $id ) = @_;
    my %minutes;
    foreach my $day ( keys %{$data} ) {
        foreach my $min_idx ( 0 .. $#{ $data->{$day}{$id} } ) {
            $data->{$day}{$id}[$min_idx]
                or next;

            $minutes{$min_idx}++;
        }
    }

    return ( sort { $minutes{$b} <=> $minutes{$a} } keys %minutes )[0];
}

if ( !caller() ) {
    require Path::Tiny;
    print find_guard( Path::Tiny::path('input')->lines( { 'chomp' => 1 } ) ), "\n";
}
