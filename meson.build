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

# ARGS AS OPTIONS FOR ENIGMA
add_project_arguments('-DE_DOUBLE_PRECISION', language: 'c')
#add_project_arguments('-DE_MEM_DEBUG', language: 'c')
#add_project_arguments('-DE_EXIT_CRASH', language: 'c')

# Math dep
cc = meson.get_compiler('c')

subdir('src/enigma')
subdir('src/phantom')

dark = executable(
  'dark',
# Main Engine
    'src/main.c',
  dependencies : [
    m_dep,
    libenigma_dep,
    libphantom_dep,
  ],
  install : false)

