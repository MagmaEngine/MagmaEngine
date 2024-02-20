project('MagmaEngine', 'c',
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

message('Host OS:', host_machine.system())
add_global_arguments('-D_UNICODE', language : 'c')
add_global_arguments('-DUNICODE', language : 'c')

display = meson.get_external_property('display')
graphics = meson.get_external_property('graphics')
message('Display System:', display)
message('Graphics Backend:', graphics)

# Platinum Settings
if get_option('math_double_precision').enabled()
  add_project_arguments('-DPLATINUM_DOUBLE_PRECISION', language : 'c')
endif
if get_option('debug_crash_on_error')
  add_project_arguments('-DPLATINUM_EXIT_CRASH', language : 'c')
endif
if get_option('debug_memory')
  add_project_arguments('-DPLATINUM_DEBUG_MEMORY', language : 'c')
endif
if get_option('debug_graphics')
  add_project_arguments('-DPLATINUM_DEBUG_GRAPHICS', language : 'c')
endif

subdir('src/platinum')
#subdir('src/enigma')
#subdir('src/abyss')

magma_srcs = [
  'src/main.c',
  'src/config/config.c',
  'src/config/argparse.c',
  ]

magma_deps = [
  #dep_libabyss,
  #dep_libenigma,
  dep_libplatinum,
  dependency('iniparser', required : true),
  ]

magma = executable(
  'magma',
  sources : magma_srcs,
  dependencies : magma_deps,
  include_directories: include_directories('include'),
  win_subsystem : 'windows',
  install : true)

engine_conf = configuration_data()
engine_conf.set('PROJECTNAME', meson.project_name())
engine_conf.set('PROJECTVERSION', meson.project_version())
engine_conf.set('SHADERPATH', join_paths(get_option('prefix'), platinum_shader_install_path))
engine_conf_path = 'share/MagmaEngine'
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
  install_data('lsan_suppress.txt', install_dir: 'share/MagmaEngine')
  runtime_conf.set('RUNTIME_ENVVARS',
    'LSAN_OPTIONS=fast_unwind_on_malloc=0\ suppressions=' + join_paths(get_option('prefix'), 'share/MagmaEngine/lsan_suppress.txt '))
else
  runtime_conf.set('RUNTIME_ENVVARS', '')
endif
  runtime_conf.set('RUNTIME_ARGS',
    ' -c ' + join_paths(get_option('prefix'), engine_conf_path, engine_conf_name))

# Create a custom script using configure_file
run_script_config = configure_file(
  input : 'run.sh.in',
  output : 'MagmaEngine.sh',
  configuration : runtime_conf,
  install_mode : 'rwxr-xr-x',
  install_dir : 'bin',
  install : true)

