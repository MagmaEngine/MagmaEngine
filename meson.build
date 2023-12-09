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

# Set up dep list
x11_dep = dependency('x11', required : false)
vulkan_dep = dependency('vulkan', required : false)
m_dep = cc.find_library('m', required : false)

# ARGS as options for ENIGMA
add_project_arguments('-DE_DOUBLE_PRECISION', language: 'c')
add_project_arguments('-DE_MEM_DEBUG', language: 'c')
add_project_arguments('-DE_EXIT_CRASH', language: 'c')

# ARGS as options for PHANTOM
if x11_dep.found()
  add_project_arguments('-D_PHANTOM_X11', language: 'c')
endif

subdir('src/enigma')
subdir('src/phantom')

dark = executable(
  'dark',
  'src/main.c',
  dependencies : [
    libenigma_dep,
    libphantom_dep,
  ],
  install : false)

