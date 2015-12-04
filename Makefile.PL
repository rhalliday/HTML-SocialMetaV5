use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'HTML::SocialMeta',
    AUTHOR           => q{Robert Acock <ThisUsedToBeAnEmail@gmail.com>},
    VERSION_FROM     => 'lib/HTML/SocialMeta.pm',
    ABSTRACT_FROM    => 'lib/HTML/SocialMeta.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'Test::Exception' => 0
    },
    PREREQ_PM => {
        'Moose' => 2.0604,
        'namespace::autoclean' => 0.15
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'HTML-SocialMeta-*' },
);
