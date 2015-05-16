# define sprites properties

# width of each sprite in pixels
sprite_width=180

# height of each sprite in pixels
sprite_height=135

# margin between two sprites, in pixels
sprite_margin=10

# maximum width of the sprites image
# (computed to fit precisely 10 sprites)
sprite_max_width=$((
  ( $sprite_width + $sprite_margin ) * 9 + $sprite_width
))

# path to the sprites image, relative to CSS style sheet
sprite_path='flags.png'
