#!/usr/bin/perl
{
package MyWebServer;

use strict;
use warnings;

use experimental 'smartmatch';
use HTTP::Server::Simple::CGI;
use Template;
use base qw(HTTP::Server::Simple::CGI);

my %dispatch = (
    '/score' => \&resp_score,
    '/scoreboard' => \&resp_score,
    '/red' => \&resp_red,
    '/blue' => \&resp_blue,
);

my %score = (
    'red'  => 0,
    'blue' => 0,
);

sub handle_request {
    my $self = shift;
    my $cgi  = shift;

    my $path = $cgi->path_info();
    my $handler = $dispatch{$path};

    if (ref($handler) eq "CODE") {
        print "HTTP/1.0 200 OK\r\n";
        $handler->($cgi);
    } else {
        print "HTTP/1.0 404 Not found\r\n";
        print $cgi->header,
              $cgi->start_html('Not found'),
              $cgi->h1('Not found'),
              $cgi->end_html;
    }
}

sub resp_score {
    my $cgi = shift;
    return if !ref $cgi;

    my $tt = Template->new({
        INCLUDE_PATH => "./templates",
    });

    my $out = $cgi->header;

    $tt->process(
        "scoreboard.tt",
        {
            red => $score{'red'},
            blue => $score{'blue'},
        },
        \$out,
    ) or die $tt->error;

    print $out;
    
}

sub resp_red {
    my $cgi = shift;
    return if !ref $cgi;
    
    open(my $fh, "<", "./flags/red.txt") or die "Failed to open file: $!\n";
    my @flags = <$fh>;
    close($fh);
    chomp @flags;

    my $flag = $cgi->param('flag');

    my $tt = Template->new({
        INCLUDE_PATH => "./templates",
    });


    if ( not defined $flag or $flag eq "" ) {
        my $out = $cgi->header;

        $tt->process(
            "team.tt",
            {
                team => "red",
            },
            \$out,
        ) or die $tt->error;

        print $out;

    } elsif ( $flag ~~ @flags ) {
        $score{'red'}++;

        open(my $fh, ">", "./flags/red.txt") or die "Failed to open file: $!\n";
        for (@flags) {
            print $fh $_, "\n" unless $_ eq $flag;
        }
        close($fh);

        my $out = $cgi->header;

        $tt->process(
            "team.tt",
            {
                team => "red",
                correct => "yes",
                flag => $flag,
            },
            \$out,
        ) or die $tt->error;

        print $out;

    } else {
        my $out = $cgi->header;

        $tt->process(
            "team.tt",
            {
                team => "red",
                flag => $flag,
            },
            \$out,
        ) or die $tt->error;

        print $out;

    }
}

sub resp_blue {
    my $cgi = shift;
    return if !ref $cgi;
    
    open(my $fh, "<", "./flags/blue.txt") or die "Failed to open file: $!\n";
    my @flags = <$fh>;
    close($fh);
    chomp @flags;

    my $flag = $cgi->param('flag');

    my $tt = Template->new({
        INCLUDE_PATH => "./templates",
    });

    if ( not defined $flag or $flag eq "" ) {
        my $out = $cgi->header;

        $tt->process(
            "team.tt",
            {
                team => "blue",
            },
            \$out,
        ) or die $tt->error;

        print $out;

    } elsif ( $flag ~~ @flags ) {
        $score{'blue'}++;

        open(my $fh, ">", "./flags/blue.txt") or die "Failed to open file: $!\n";
        for (@flags) {
            print $fh $_, "\n" unless $_ eq $flag;
        }
        close($fh);

        my $out = $cgi->header;

        $tt->process(
            "team.tt",
            {
                team => "blue",
                correct => "yes",
                flag => $flag,
            },
            \$out,
        ) or die $tt->error;

        print $out;

    } else {
        my $out = $cgi->header;

        $tt->process(
            "team.tt",
            {
                team => "blue",
                flag => $flag,
            },
            \$out,
        ) or die $tt->error;

        print $out;

    }
}

}

my $pid = MyWebServer->new(8080)->run();