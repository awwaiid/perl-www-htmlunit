use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'WWW::HtmlUnit',
    VERSION_FROM      => 'lib/WWW/HtmlUnit.pm', # finds $VERSION
    PREREQ_PM         => {
      'Inline::Java' => 0,
    },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/WWW/HtmlUnit.pm', # retrieve abstract from module
       AUTHOR         => 'awwaiid <awwaiid@thelackthereof.org>') : ()),
);

