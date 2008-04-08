#!/usr/bin/env  perl

# depend on generated config structure
# -----------------------------------------------------------
#
#
use Dynamic::Loader;
use File::Basename;


my $script = basename($0);


my $inlineargs="";

unless (@ARGV){
    print ";javaperl configuration\n";
    print "JAVAPERL=$ENV{JAVAPERL}\n";
    print "DEFAULTHOME=$ENV{HOME}/.perljava/conf/\n";
    print ";perl modules managed by java\n";
    foreach my $mod (keys %{$javaperl}){
        print "$mod:prefix=".$javaperl->{$mod}->{'prefix'}."\n";
        print "$mod:bin=".$javaperl->{$mod}->{'bin'}."\n";
        print "$mod:inc=".$javaperl->{$mod}->{'inc'}."\n";
    }
    exit 0;
}

if ($ARGV[0] =~ /.*\.pl/){
    $script=$ARGV[0];
    shift(@ARGV);
}

foreach (@ARGV) {
    $inlineargs="$inlineargs $_";
}

my ($inc,$bin)=getscriptenv($script);

exit system("perl -I$inc $bin $inlineargs");

die "ERROR: Cannot open executable $script (No such file)\n";
