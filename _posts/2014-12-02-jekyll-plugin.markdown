---
layout: post
title:  "Jekyll plugin for Lightbox2 with thumbnails"
date:   2014-12-02 22:38:23
categories: jekyll lightbox2
---

[lightbox2] with Jekyll. I have written a [small plugin] for Jekyll.

It will generate the thumbs and create the html for lightbox. You can embed image gallery into your post, only with

    {% raw  %}{% imagegallery images/foobar %}{% endraw %}

this will generate a lightbox gallery with all images from images/foobar.

See it here:

{% imagegallery images/test-gallery %}




[lightbox2]: http://lokeshdhakar.com/projects/lightbox2/
[small plugin]: https://github.com/hggh/hggh.github.io/blob/jekll/_plugins/image_gallery_tag.rb
