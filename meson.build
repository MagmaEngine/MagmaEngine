project('DarkEngine', 'c',
  version : '0.0.1',
  default_options : [
    'buildtype=debug',
    'default_library=static',
    'warning_level=3',
    'c_std=c99',
    'b_sanitize=address',
    'b_lundef=false'
  ])
cc = meson.get_compiler('c')

dark_sources = []

# Set up dep list
dep_vulkan = dependency('vulkan', required : true)
dep_m = cc.find_library('m', required : false)

## Phantom build setup
# Windows
if host_machine.system() == 'windows'
  build_phantom = 'windows'
  add_project_arguments('-D_PHANTOM_WIN32', language : 'c')
  dark_sources += 'src/winmain.c'
else
  dep_wayland = dependency('wayland-client', required : false)
  dep_x11 = dependency('xcb', required : false)
  dark_sources += 'src/main.c'
# X11
  if dep_x11.found()
    build_phantom = 'x11'
    add_project_arguments('-D_PHANTOM_X11', language: 'c')
# Wayland
  elif dep_wayland.found()
    build_phantom = 'wayland'
    add_project_arguments('-D_PHANTOM_WAYLAND', language: 'c')
  endif
endif

# ARGS as options for ENIGMA
add_project_arguments('-DE_DOUBLE_PRECISION', language: 'c')
add_project_arguments('-DE_MEM_DEBUG', language: 'c')
add_project_arguments('-DE_EXIT_CRASH', language: 'c')

subdir('src/enigma')
subdir('src/phantom')

dark = executable(
  'dark',
  sources : dark_sources,
  dependencies : [
    dep_libenigma,
    dep_libphantom,
  ],
  win_subsystem : 'windows',
  install : false)

