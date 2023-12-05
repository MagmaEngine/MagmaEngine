project('gameengine', 'c',
  version : '0.0.1',
  default_options : [
    'buildtype=debug',
    'warning_level=3',
    'c_std=c99',
    'b_sanitize=address',
    'b_lundef=false'
    ])

executable('engine',
           'src/main.c',
           dependencies : [
             dependency('x11'),
             ],
           install : false)
