project('DarkEngine', 'c',
  version : '0.0.1',
  default_options : [
    'buildtype=debug',
    'default_library=static',
    'warning_level=3',
    'c_std=c99',
    #'b_sanitize=address',
    'b_lundef=false'
    ])
cc = meson.get_compiler('c')

dark_srcs = [ 'src/main.c' ]
dark_deps = []

# Set up dep list
dep_vulkan = dependency('vulkan', required : false)

target_os = host_machine.system()
message('Host OS: ' + target_os)

## Phantom build setup
# Windows
if target_os == 'windows'
  target_display = 'windows'
  add_project_arguments('-D_PHANTOM_WIN32', language : 'c')
  add_project_arguments('-D_PHANTOM_WINDOWS', language : 'c')
  add_project_arguments('-D_ENIGMA_WINDOWS', language : 'c')
# Linux
elif target_os == 'linux'
  add_project_arguments('-D_PHANTOM_LINUX', language : 'c')
  add_project_arguments('-D_ENIGMA_LINUX', language : 'c')
  dep_wayland = dependency('wayland-client', required : false)
  dep_x11 = dependency('xcb', required : false)
# X11
  if dep_x11.found()
    target_display = 'x11'
    add_project_arguments('-D_PHANTOM_X11', language: 'c')
# Wayland
  elif dep_wayland.found()
    target_display = 'wayland'
    add_project_arguments('-D_PHANTOM_WAYLAND', language: 'c')
  endif
endif

# ARGS as options for ENIGMA
add_project_arguments('-DE_DOUBLE_PRECISION', language: 'c')
#add_project_arguments('-DE_MEM_DEBUG', language: 'c')
add_project_arguments('-DE_EXIT_CRASH', language: 'c')

subdir('src/enigma')
subdir('src/phantom')

dark_deps += [ dep_libenigma, dep_libphantom ]

dark = executable(
  'dark',
  sources : dark_srcs,
  dependencies : dark_deps,
  include_directories: include_directories('src'),
  win_subsystem : 'windows',
  install : false)

