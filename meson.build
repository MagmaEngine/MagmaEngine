project('DarkEngine', 'c',
  version : '0.0.1',
  default_options : [
    'buildtype=release',
    'default_library=static',
    'warning_level=3',
    'c_std=c99',
    'b_sanitize=none',
    'b_lundef=true',
    ])

if get_option('b_sanitize') != 'none'
  add_global_arguments('-fno-omit-frame-pointer', language: 'c')
endif

library_buildtype = get_option('library_buildtype')

message('Host OS:', host_machine.system())
add_global_arguments('-D_UNICODE', language : 'c')
add_global_arguments('-DUNICODE', language : 'c')

display = meson.get_external_property('display')
graphics = meson.get_external_property('graphics')
message('Display System:', display)
message('Graphics Backend:', graphics)

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
if graphics == 'vulkan'
  add_project_arguments('-DPHANTOM_BACKEND_VULKAN', language : 'c')
  dep_vulkan = dependency('vulkan', required : true)
endif
if get_option('debug_graphics')
  add_project_arguments('-DPHANTOM_DEBUG_GRAPHICS', language : 'c')
endif
# Phantom Display Settings
if display == 'x11'
  dep_display = dependency('xcb', required : true)
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

subdir('src/enigma')
subdir('src/phantom')

dark_srcs = [
  'src/main.c',
  'src/config/config.c',
  'src/config/argparse.c',
  ]

dark_deps = [
  dep_libenigma,
  dep_libphantom,
  dependency('iniparser', required : true),
  ]

dark = executable(
  'dark',
  sources : dark_srcs,
  dependencies : dark_deps,
  include_directories: include_directories('include'),
  win_subsystem : 'windows',
  install : true)

engine_conf = configuration_data()
engine_conf.set('PROJECTNAME', meson.project_name())
engine_conf.set('PROJECTVERSION', meson.project_version())
engine_conf.set('SHADERPATH', join_paths(get_option('prefix'), phantom_shader_install_path))
engine_conf_path = 'share/DarkEngine'
engine_conf_name = 'config.ini'

engine_config = configure_file(
  input : 'config.ini.in',
  output : engine_conf_name,
  configuration : engine_conf,
  install_mode : 'rw-r--r--',
  install_dir : engine_conf_path,
  install : true)

runtime_conf = configuration_data()
if get_option('b_sanitize') != 'none'
  install_data('lsan_suppress.txt', install_dir: 'share/DarkEngine')
  runtime_conf.set('RUNTIME_ENVVARS',
    'LSAN_OPTIONS=fast_unwind_on_malloc=0\ suppressions=' + join_paths(get_option('prefix'), 'share/DarkEngine/lsan_suppress.txt '))
else
  runtime_conf.set('RUNTIME_ENVVARS', '')
endif
  runtime_conf.set('RUNTIME_ARGS',
    ' -c ' + join_paths(get_option('prefix'), engine_conf_path, engine_conf_name))

# Create a custom script using configure_file
run_script_config = configure_file(
  input : 'run.sh.in',
  output : 'DarkEngine.sh',
  configuration : runtime_conf,
  install_mode : 'rwxr-xr-x',
  install_dir : 'bin',
  install : true)

