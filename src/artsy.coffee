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
#   artists <some artist> - Returns the details about an artist including an image.
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
xappToken = undefined

#For random number generation
low  = 1
high = 23987

module.exports = (robot) ->
  
  #Get a token from Artsy
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

  robot.respond /(get)? art/i, (msg) ->
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
            art_title = result._embedded.artworks[0].title
            art_image = result._embedded.artworks[0]._links.thumbnail.href
            permalink = result._embedded.artworks[0]._links.permalink.href
            if art_title and art_image
              msg.send art_title + " [" + permalink + "]\n" + art_image
              return
          
          msg.send "The gallery is closed at the moment."

  #Make this smarter. Right now it only looks for artists with only first and last name.
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
          if artist
            art_image = artist._links.thumbnail.href
            permalink = artist._links.permalink.href
            message = artist.name + "\n" + artist.blurb + "\n" + art_image + "\n" + permalink
            msg.reply message
