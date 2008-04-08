#!/usr/bin/env  perl

# depend on generated config structure
# -----------------------------------------------------------
#
#
use Dynamic::Loader;
use File::Basename;
use File::Find::Rule;

my $script = basename($0);



my %cache=();
print ";scripts availables\n";
foreach my $mod (keys %{$javaperl}){
    print $javaperl->{$mod}->{'prefix'}.$javaperl->{$mod}->{'bin'}."\n";
    my $path=$javaperl->{$mod}->{'prefix'}.$javaperl->{$mod}->{'bin'};
    my @files = File::Find::Rule->file()
                              ->name( '*.pl' ) 
                             ->in( $path);
    unless ($cache{$path}){
        foreach (@files){
            print "\t$_\n";
        };
    }

    $cache{$path}=1;
}


