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

message('Host OS: ' + host_machine.system())
add_global_arguments('-D_UNICODE', language : 'c')
add_global_arguments('-municode', language : 'c')

# Platform settings
# Windows
if host_machine.system() == 'windows'
  add_project_arguments('-DDARK_PLATFORM_WINDOWS', language : 'c')
  add_project_arguments('-DENIGMA_PLATFORM_WINDOWS', language : 'c')
  add_project_arguments('-DPHANTOM_PLATFORM_WINDOWS', language : 'c')
  add_project_arguments('-DPHANTOM_DISPLAY_WIN32', language : 'c')
# Linux
elif host_machine.system() == 'linux'
  add_project_arguments('-DDARK_PLATFORM_LINUX', language : 'c')
  add_project_arguments('-DENIGMA_PLATFORM_LINUX', language : 'c')
  add_project_arguments('-DPHANTOM_PLATFORM_LINUX', language : 'c')
endif

# Enigma Settings
add_project_arguments('-DENIGMA_DOUBLE_PRECISION', language : 'c')
add_project_arguments('-DENIGMA_EXIT_CRASH', language : 'c')
#add_project_arguments('-DENIGMA_MEM_DEBUG', language : 'c')

# Phantom Settings
add_project_arguments('-DPHANTOM_DEBUG_VULKAN', language : 'c')
# Phantom Display Settings
dep_ncurses = dependency('ncurses', required : false)
if host_machine.system() == 'linux'
  dep_wayland = dependency('wayland-client', required : false)
  dep_x11 = [
    dependency('xcb', required : false),
    dependency('xcb-image', required : false),
    ]
# X11
  if dep_x11[0].found() and dep_x11[1].found()
    add_project_arguments('-DPHANTOM_DISPLAY_X11', language : 'c')
# Wayland
  elif dep_wayland.found()
    add_project_arguments('-DPHANTOM_DISPLAY_WAYLAND', language : 'c')
# Ncurses
  elif dep_ncurses.found()
    add_project_arguments('-DPHANTOM_DISPLAY_NCURSES', language : 'c')
  else
    error('There must be at least one graphical back-end installed.')
  endif
endif

subdir('src/enigma')
subdir('src/phantom')

dark_srcs = [ 'src/main.c' ]
dark_deps = [ dep_libenigma, dep_libphantom ]

dark = executable(
  'dark',
  sources : dark_srcs,
  dependencies : dark_deps,
  include_directories: include_directories('src'),
  win_subsystem : 'windows',
  install : false)

