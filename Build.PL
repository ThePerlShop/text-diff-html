use Module::Build;

my $build = Module::Build->new(
    module_name        => 'Text::Diff::HTML',
    license            => 'perl',
    requires           => {
        Text::Diff     => '0.11',
        HTML::Entities => '0',
    },
    build_requires     => { Test::Simple  => '0.17' },
    create_makefile_pl => 'passthrough',
    create_readme      => 1,
);
$build->create_build_script;
