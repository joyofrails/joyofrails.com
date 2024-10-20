# frozen_string_literal: true

require "addressable/template"

class Gravatar
  # Gravatar URI template
  #
  # digest = MD5 hash of the email address
  #
  # s = size, an integer, default is 80
  #
  # d = default image when none found, can be one of the following:
  # - an encoded URL
  # - 404: do not load any image if none is associated with the email hash, instead return an HTTP 404 (File Not Found) response
  # - mp: (mystery-person) a simple, cartoon-style silhouetted outline of a person (does not vary by email hash)
  # - identicon: a geometric pattern based on an email hash
  # - monsterid: a generated ‘monster’ with different colors, faces, etc
  # - wavatar: generated faces with differing features and backgrounds
  # - retro: awesome generated, 8-bit arcade-style pixelated faces
  # - robohash: a generated robot with different colors, faces, etc
  # - blank: a transparent PNG image (border added to HTML below for demonstration purposes)
  #
  # r = rating, can be one of the following:
  # - g: suitable for display on all websites with any audience type.
  # - pg: may contain rude gestures, provocatively dressed individuals, the lesser swear words, or mild violence.
  # - r: may contain such things as harsh profanity, intense violence, nudity, or hard drug use.
  # - x: may contain sexual imagery or extremely disturbing violence.
  #
  # @see https://docs.gravatar.com/api/avatars/images/
  #
  URI_TEMPLATE = "https://secure.gravatar.com/avatar/{digest}{?s,d,r}"

  attr_reader :email

  def initialize(email)
    @email = email
  end

  def url(size: 32, default: "retro", rating: nil)
    uri_template.expand(digest: digest, s: size, d: default, r: rating).to_s
  end

  def digest
    Digest::MD5.hexdigest(email.downcase)
  end

  def uri_template
    Addressable::Template.new(URI_TEMPLATE)
  end
end
