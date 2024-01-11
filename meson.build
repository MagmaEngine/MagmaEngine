project('DarkEngine', 'c',
  version : '0.0.1',
  default_options : [
    'buildtype=debug',
    'default_library=static',
    'warning_level=3',
    'c_std=c99',
    #'b_sanitize=address',
    #'b_lundef=false',
    ])

library_buildtype = get_option('library_buildtype')

message('Host OS:', host_machine.system())
add_global_arguments('-D_UNICODE', language : 'c')
add_global_arguments('-DUNICODE', language : 'c')

display = meson.get_external_property('display')
message('Display System:', display)

# Platform settings
# Windows
if host_machine.system() == 'windows'
  add_project_arguments('-DDARK_PLATFORM_WINDOWS', language : 'c')
  add_project_arguments('-DENIGMA_PLATFORM_WINDOWS', language : 'c')
  add_project_arguments('-DPHANTOM_PLATFORM_WINDOWS', language : 'c')
# Linux
elif host_machine.system() == 'linux'
  add_project_arguments('-DDARK_PLATFORM_LINUX', language : 'c')
  add_project_arguments('-DENIGMA_PLATFORM_LINUX', language : 'c')
  add_project_arguments('-DPHANTOM_PLATFORM_LINUX', language : 'c')
endif

# Enigma Settings
if get_option('math_double_precision').enabled()
  add_project_arguments('-DENIGMA_DOUBLE_PRECISION', language : 'c')
endif
if get_option('debug_crash_on_error')
  add_project_arguments('-DENIGMA_EXIT_CRASH', language : 'c')
endif
if get_option('debug_memory')
  add_project_arguments('-DENIGMA_DEBUG_MEMORY', language : 'c')
endif

# Phantom Settings
if get_option('debug_vulkan')
  add_project_arguments('-DPHANTOM_DEBUG_VULKAN', language : 'c')
endif
# Phantom Display Settings
if display == 'x11'
  dep_display = [
    dependency('xcb', required : true),
    dependency('xcb-image', required : true),
    ]
  add_project_arguments('-DPHANTOM_DISPLAY_X11', language : 'c')
elif display == 'wayland'
  dep_display = dependency('wayland-client', required : true)
  add_project_arguments('-DPHANTOM_DISPLAY_WAYLAND', language : 'c')
elif display == 'win32'
  add_project_arguments('-DPHANTOM_DISPLAY_WIN32', language : 'c')
elif display == 'ncurses'
  dep_display = dependency('ncurses', required : true)
  add_project_arguments('-DPHANTOM_DISPLAY_NCURSES', language : 'c')
else
  error('There must be at least one graphical back-end installed.')
endif

dep_vulkan = dependency('vulkan', required : true)
subdir('src/enigma')
subdir('src/phantom')

dark_srcs = [ 'src/main.c' ]
dark_deps = [ dep_libenigma, dep_libphantom]

dark = executable(
  'dark',
  sources : dark_srcs,
  dependencies : dark_deps,
  include_directories: include_directories('src'),
  win_subsystem : 'windows',
  install : true)

