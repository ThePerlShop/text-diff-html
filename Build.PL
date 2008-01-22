use Module::Build;

my $build = Module::Build->new(
    module_name        => 'Text::Diff::HTML',
    license            => 'perl',
    create_makefile_pl => 'passthrough',
    create_readme      => 1,
    configure_requires => { 'Module::Build' => '0.2701' },
    build_requires     => { 'Test::More'    => '0.17'   },
    recommends         => { 'Test::Pod'     => '1.20'   },
    requires           => {
        Text::Diff     => '0.11',
        HTML::Entities => '0',
    },
);
$build->create_build_script;
