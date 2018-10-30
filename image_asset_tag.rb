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
#        {% image "Description of the image" "filename in asset path.ext" "Copyright Holder Name" %}

module Jekyll
  class ImageAssetTag < Liquid::Tag
    @markup = nil

    def initialize(tag_name, markup, tokens)
      #strip leading and trailing spaces
      @markup = markup.strip
      super
    end

    def parseNextParameter(parameterString)
      if (parameterString == nil)
        return nil, ""
      end

      parameterString.strip!

      if (parameterString.length == 0)
        return nil, ""
      end

      if ['"', "'"].include? parameterString[0] 
        # Quoted or whitespace limited description, possibly followed by post id
        next_quote_index = parameterString.index(parameterString[0], 1)
        nextParameter = parameterString[1 ... next_quote_index]
        if parameterString.length > next_quote_index
          remaining = parameterString[(next_quote_index + 1) .. -1]
        else
          remaining = ""
        end
      else
        # Unquoted parameter
        whitespace_index = parameterString.index(' ', 0)
        if (whitespace_index == nil)
          nextParameter = parameterString
          remaining = ""
        else
          nextParameter = parameterString[0 ... whitespace_index]
          remaining = parameterString[(whitespace_index + 1) .. -1]
        end
      end

      return nextParameter, remaining
    end

    def parseParameters(parameterString)
      parameterString.strip!

      description, parameterString = parseNextParameter(parameterString)
      filename, parameterString = parseNextParameter(parameterString)
      copyright, parameterString = parseNextParameter(parameterString)

      print "desc: #{description}, filename: #{filename}, copyright: #{copyright}\n"

      return description, filename, copyright
    end

    def render(context)
      if @markup.empty?
        return 'Error processing input, expected syntax: {% image "description" "filename" "Copyright Holder Name" %}'
      end

      #render the markup
      parameters = Liquid::Template.parse(@markup).render context

      description, filename, copyright = parseParameters(parameters)

      path = AssetPathTools.resolve(context, filename)
      title = description
      if (copyright != nil)
        title = "#{title} © #{copyright}"
      end

      %[<div class="block-image-sizer">
          <a href="#{path}">
            <img src="#{path}" alt="#{description}" title="#{title}">
          </a>
        </div>
      ]
    end
  end
end

Liquid::Template.register_tag("image", Jekyll::ImageAssetTag)
