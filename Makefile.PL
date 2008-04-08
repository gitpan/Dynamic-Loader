use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Dynamic::Loader',
    AUTHOR              => 'Olivier Evalet <olivier.evalet@genebio.com>',
    VERSION_FROM        => 'lib/Dynamic/Loader.pm',
    ABSTRACT_FROM       => 'lib/Dynamic/Loader.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Dynamic-Loader-*' },
);
