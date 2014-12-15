# Description
#   Robots like art.
#
# Configuration:
#   HUBOT_ARTSY_CLIENT_ID
#   HUBOT_ARTSY_CLIENT_SECRET
#   
#   Sign up at https://developers.artsy.net
#
# Commands:
#   hubot get art - Returns a random image from artsy.net.
#   hubot get artist - Returns a random artist.
#   hubot art me <query> - Search for piece of art.
#   artists <some artist> - Returns the details about an artist including an image.
#   
# Notes:
#   You need to sign up and get a client id and secret.
#
# Author:
#   github.com/robksawyer

request = require('superagent')
traverson = require('traverson')
clientID = process.env.HUBOT_ARTSY_CLIENT_ID
clientSecret = process.env.HUBOT_ARTSY_CLIENT_SECRET
api = traverson.jsonHal.from('https://api.artsy.net/api')
apiUrl = 'https://api.artsy.net/api/tokens/xapp_token'
artworksUrl = 'https://api.artsy.net/api/artworks'
artistUrl = 'https://api.artsy.net/api/artists'
searchUrl = 'https://api.artsy.net/api/search'
xappToken = undefined

#For random number generation
low  = 1
high = 23987

module.exports = (robot) ->
  
  #
  # Get a token from Artsy
  #
  getToken = (msg, cb) ->
    #Get a token
    request
      .post(apiUrl)
      .send({ client_id: clientID, client_secret: clientSecret })
      .end (res) ->
        #Save the token
        xappToken = res.body.token
        unless xappToken?
          msg.send "Had an issue connecting to Artsy."
        cb xappToken

  #
  # Return a piece of artwork based on a query
  # 
  robot.respond /art me (.*)/i, (msg) ->
    #find the query
    if msg.match[2]

      getToken msg, (xappToken) ->
        #Get a piece of art
        robot.http(searchUrl)
          .header('X-Xapp-Token', xappToken)
          .header('Accept', 'application/vnd.artsy-v2+json')
          .query(
            q: msg.match[2].trim(),
            size: 1
          )
          .get() (err, res, body) ->
            unless body?
              msg.send "The gallery is closed at the moment."
              return 
            
            result = JSON.parse(body)
            if result
              message = ""
              if result._embedded 
                  artwork = result._embedded.results[0]
                  if artwork
                    if artwork.type == "Artwork"

                      if artwork.title
                        message += artwork.title + "\n"

                      links = artwork._links
                      if links.thumbnail.href
                        message += links.thumbnail.href + "\n"

                      if links.permalink.href
                        message += links.permalink.href

                      msg.send message
                      return

  #
  # Return a random piece of artwork
  #
  robot.respond /(get) art$/i, (msg) ->
    #create a random offset
    offset = Math.round(Math.floor(Math.random() * (high - low + 1)) + low)
    getToken msg, (xappToken) ->
      #Get a piece of art
      robot.http(artworksUrl)
        .header('X-Xapp-Token', xappToken)
        .header('Accept', 'application/vnd.artsy-v2+json')
        .query(
          offset: offset,
          size: 1
        )
        .get() (err, res, body) ->
          if err
            msg.send "Had an issue connecting to Artsy."
            return

          unless body?
            msg.send "The gallery is closed at the moment."
            return 
          
          result = JSON.parse(body)
          if result
            message = ""
            if result._embedded 
                artwork = result._embedded.artworks[0]
                if artwork

                  if artwork.title
                    message += artwork.title + "\n"

                  links = artwork._links
                  if links.thumbnail.href
                    message += links.thumbnail.href + "\n"

                  if links.permalink.href
                    message += links.permalink.href

                  msg.send message
                  return

  #
  # Return details about a random artist
  #
  robot.respond /(get)? artist$/i, (msg) ->
    #create a random offset
    offset = Math.round(Math.floor(Math.random() * (high - low + 1)) + low)
    getToken msg, (xappToken) ->
      #Get a piece of art
      robot.http(artistUrl)
        .header('X-Xapp-Token', xappToken)
        .header('Accept', 'application/vnd.artsy-v2+json')
        .query(
          offset: offset,
          size: 1
        )
        .get() (err, res, body) ->
          if err
            msg.send "Had an issue connecting to Artsy."
            return

          unless body?
            msg.send "The gallery is closed at the moment."
            return 
          
          result = JSON.parse(body)
          if result
            message = ""

            if result._embedded 
              artist = result._embedded.artists[0]
              if artist

                if artist.name
                  message += artist.name + "\n"

                if artist.blurb
                  message += artist.blurb + "\n"

                links = artist._links
                if links.thumbnail.href
                  message += links.thumbnail.href + "\n"

                if links.permalink.href
                  message += links.permalink.href

                msg.send message
                return
        

  #
  # Returns the details about an artist that is mentioned.
  # TODO: Make this smarter. Right now it only looks for artists with only first and last name.
  #
  robot.hear /artist (\w+\s\w+)/i, (msg) ->
    unless msg.match[1]?
      return

    getToken msg, (xappToken) ->
      #Get artist details
      artist_name = msg.match[1].replace(/\s+/g, '-').toLowerCase()
      api.newRequest()
        .follow('artist')
        .withRequestOptions({
          headers: {
            'X-Xapp-Token': xappToken,
            'Accept': 'application/vnd.artsy-v2+json'
          }
        })
        .withTemplateParameters({ 
          id: artist_name 
        })
        .getResource (err, artist) ->
          if err
            msg.send "Had an issue connecting to Artsy."
            return

          message = ""
          if artist

            if artist.name
              message += artist.name + "\n"

            if artist.blurb
              message += artist.blurb + "\n"

            if artist._links.thumbnail
              message += artist._links.thumbnail.href + "\n"

            if artist._links.permalink
              message += artist._links.permalink.href

            msg.reply message
            return
