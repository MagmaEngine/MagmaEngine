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

# ARGS AS OPTIONS FOR UTIL
add_project_arguments('-DE_DOUBLE_PRECISION', language: 'c')
#add_project_arguments('-DE_MEM_DEBUG', language: 'c')
#add_project_arguments('-DE_EXIT_CRASH', language: 'c')

# Math dep
cc = meson.get_compiler('c')
m_dep = cc.find_library('m', required : false)

#subdir('src/Obsidian')

incl_dir =  [
  include_directories('src/util/include')
  ]

dark = executable(
  'dark',
# Main Engine
    'src/main.c',
# Utilities
    'src/util/e_math.c',
    'src/util/e_matrix_operations.c',
    'src/util/e_path.c',
    'src/util/e_text.c',
    'src/util/e_mem_debug.c',
    'src/util/e_types.c',
    'src/util/e_noise.c',
    'src/util/e_matrix_make.c',
    'src/util/e_math.c',
  dependencies : [
    m_dep,
    #libobsidian_dep,
  ],
  include_directories: incl_dir,
  install : false)

