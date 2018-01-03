# Image asset plugin for Jekyll static site generator
#
# Author: Otto Urpelainen <oturpe@iki.fi>
#
# This plugin adds Liquid tag 'image' for adding a click-to-enlarge image.
# Maximum width and height of displayed image size of the image are defined in
# site configuration. Name of image to display is given using the convention
# of jekyll-asset-path-plugin. Consequently, this plugin depends on
# jekyll-asset-path-plugin.
#
# Installation:
# 1. Copy image_asset_tag.rb to _plugins directory
# 2. Copy _block_image.scss to _sass directory
# 3. Copy the snippet from main.scss to css/main.scss file
# 4. Copy the snippet from _config.yml to _config.yml
# 5. Adjust any values as desired
#
# Usage:
# 1. Save an image file to asset path of a page or post
# 2. Include the image as follows:
#        {% image "Description of the image" "filename in asset path.ext" %}

module Jekyll
  class ImageAssetTag < Liquid::Tag
    @markup = nil

    def initialize(tag_name, markup, tokens)
      #strip leading and trailing spaces
      @markup = markup.strip
      super
    end

    def render(context)
      if @markup.empty?
        return 'Error processing input, expected syntax: {% image "description" "filename" %}'
      end

      #render the markup
      parameters = Liquid::Template.parse(@markup).render context
      parameters.strip!

      if ['"', "'"].include? parameters[0] 
        # Quoted description, possibly followed by post id
        next_quote_index = parameters.index(parameters[0], 1)
        description = parameters[1 ... next_quote_index]
        filename = parameters[(next_quote_index + 1) .. -1].strip.gsub(/["']/,'')
      else
        # Unquoted filename, followed by post id
        whitespace_index = parameters.index(' ', 0)
        description = parameters[0 ... whitespace_index]
        filename = parameters[(whitespace_index + 1) .. -1].strip.gsub(/["']/,'')
      end

      path = AssetPathTools.resolve(context, filename)

      %[<div class="block-image-sizer">
          <a href="#{path}">
            <img src="#{path}" alt="#{description}">
          </a>
        </div>
      ]
    end
  end
end

Liquid::Template.register_tag("image", Jekyll::ImageAssetTag)
