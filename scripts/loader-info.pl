#!/usr/bin/env  perl

# depend on generated config structure
# -----------------------------------------------------------
#
#
use Dynamic::Loader;
use File::Basename;


my $script = basename($0);


if ($ARGV[0] =~ /.*\.pl/){
    $script=$ARGV[0];
    shift(@ARGV);
}else{
    print STDERR "usage: $script scriptname.pl\n";
    exit 1;
}


my ($inc,$bin)=getscriptenv($script);

print ";script info\n";
print "lib=$inc\n";
print "bin=$bin\n";

