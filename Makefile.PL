use strict;
use warnings;
use ExtUtils::MakeMaker;


my %scripts;
open (MAN, "<MANIFEST") or die "cannot open MANIFEST: $!";
while(<MAN>){
  chomp;
  next unless /^scripts\//;
  my $dest=$_;
  $scripts{$_}=$dest;
}
close MAN;

WriteMakefile(
    NAME                => 'Dynamic::Loader',
    AUTHOR              => 'Olivier Evalet <olivier.evalet@genebio.com>',
    VERSION_FROM        => 'lib/Dynamic/Loader.pm',
    ABSTRACT_FROM       => 'lib/Dynamic/Loader.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Env::Path'  => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Dynamic-Loader-*' },
    EXE_FILES           => [ keys %scripts],
);
