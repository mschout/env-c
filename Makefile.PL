use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'Env::C',
    'VERSION_FROM'	=> 'C.pm',
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'C.pm', # retrieve abstract from module
       AUTHOR     => 'Stas Bekman <stas@stason.org>') : ()),
   dist => {
              PREOP        => 'pod2text C.pm > $(DISTVNAME)/README',
              COMPRESS     => 'gzip -9f',
              SUFFIX       => '.gz',
              ZIP          => 'zip',
              ZIPFLAGS     => '-r',
              DIST_DEFAULT => 'tardist',
             },


);
