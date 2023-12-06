project('DarkEngine', 'c',
  version : '0.0.1',
  default_options : [
    'buildtype=debug',
    'warning_level=3',
    'c_std=c99',
    'b_sanitize=address',
    'b_lundef=false'
    ])

subdir('src/Obsidian')
subdir('src/Enigma')

executable('dark',
           'src/main.c',
           dependencies : [
             libobsidian_dep,
             libenigma_dep,
            ],
           install : false)
