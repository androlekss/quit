project(
  'quit-docklet',
  'vala',
  'c',
  version: '0.1.0',
)

# Dependencies
gtk_dep = dependency('gtk+-3.0')
gee = dependency('gee-0.8')
plank_dep = dependency('plank')
i18n = import('i18n')

# Configure the build
customconf = configuration_data()
customconf.set('GETTEXT_PACKAGE', meson.project_name())

# Generate resource file
gnome = import('gnome')
resources = gnome.compile_resources('resources', 'quit.gresource.xml', source_dir: '.', c_name: 'resources')

add_project_arguments(
  [
    '-Wno-discarded-qualifiers',
    '-Wno-incompatible-pointer-types',
    '-Wno-unused',
    '-Wl,--enable-new-dtags',

    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
  ],
  language: 'c',
)

# Source files
sources = [
  'QuitDock.vala',
  'QuitDockItem.vala',
  'QuitDockItemPreferences.vala',
  'QuitDialog.vala',
  'SessionManager.vala',
  resources,
]

# Build the shared module
shared_module(
  'docklet-quit',
  sources,
  dependencies: [gtk_dep, plank_dep, gee],
  install: true,
  install_dir: '/usr/lib/x86_64-linux-gnu/plank/docklets',
)
