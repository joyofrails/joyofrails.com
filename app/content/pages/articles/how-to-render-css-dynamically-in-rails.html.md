---
title: How to Render CSS Dynamically in Rails
author: Ross Kaffenberger
layout: article
summary: Rails is not just for "HTML over the wire". This post demonstrates how and why you might use Rails for delivering CSS on the fly too.
description: Rails is not just for "HTML over the wire". This post demonstrates how and why you might use Rails for delivering CSS on the fly too.
published: '2024-08-07'
draft: true
uuid: 3be769c4-6a2a-4cfb-8008-94046b952aa6
image: articles/how-to-render-css-dynamically-in-rails/placeholder.jpg
meta_image: articles/how-to-render-css-dynamically-in-rails/placeholder.jpg
tags:
  - Rails
---

Let‘s talk about how to render CSS dynamically with Ruby on Rails.

Usually you would think of CSS as a static asset that can be easily provided by web servers and globally-distributed CDNs. Sometimes thought, you may want CSS to served and/or generated dynamically, say, depending on user preferences.

## respond to

Generate Dynamic CSS from a Controller?

Generating CSS dynamically from a controller offers several advantages:

Flexibility: Allows for real-time style changes based on user preferences or application state.
Customization: Enables user-specific or context-specific styling.
Performance: Can reduce the overall CSS payload by serving only necessary styles.
DRY principle: Avoids repetition in static stylesheets.

Step-by-Step Guide: Implementing Dynamic CSS Generation

The respond_to method in Rails controllers allows you to define different responses based on the requested format. It's commonly used to serve different content types (HTML, JSON, XML) from the same action.

```ruby
class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @product }
      format.css { render css: @product.custom_styles }
    end
  end
end
```

Example controller

```ruby
class ColorSchemesController < ApplicationController
  def show
    @color_theme = ColorScheme.find(id)

    respond_to do |format|
      format.css
    end
  end
end
```

Example CSS template

app/views/styles/theme.css.erb

```erb
:root {
  <%= @color_scheme.weights.map do |weight, color| %>
  --color-#{color_name}-#{weight}: #{to_hsla(color)};
  <% end %>
}
```

This example demonstrates how you can generate CSS based on user preferences and a theme parameter.

Use Cases and Benefits

Theme customization: Allow users to choose color schemes or layouts.
User-specific styling: Adjust font sizes for accessibility or personal preference.
A/B testing: Serve different styles to different user groups for testing purposes.

Best Practices and Considerations

Caching:

```ruby
class StylesController < ApplicationController
  def theme
    @user = current_user
    @primary_color = @user.preferred_color || '#007bff'

    respond_to do |format|
      format.css { render css: generate_css, cache_control: 'public, max-age=3600' }
    end
  end

  private

  def generate_css
    render_to_string(template: 'styles/theme', layout: false)
  end
end
```
