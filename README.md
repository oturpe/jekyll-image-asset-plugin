## Image asset plugin for Jekyll static site generator

Author: Otto Urpelainen <oturpe@iki.fi>

This plugin adds Liquid tag `image` for adding a click-to-enlarge image.
Maximum width and height of displayed image size of the image are defined in
site configuration.

Name of image to display is given using the convention
of jekyll-asset-path-plugin. Consequently, this plugin depends on
[jekyll-asset-path-plugin][asset-path].

[asset-path]: https://github.com/samrayner/jekyll-asset-path-plugin

## Installation
1. Copy `image_asset_tag.rb` to `_plugins` directory
2. Copy `_block_image.scss` to `_sass` directory
3. Copy the snippet from `main.scss` to `css/main.scss` file
4. Copy the snippet from `_config.yml` to `_config.yml`
5. Adjust any values as desired

## Usage
1. Save an image file to asset path of a page or post
2. Include the image as follows: `{% image "Description of the image" "filename in asset path.ext" %}`
