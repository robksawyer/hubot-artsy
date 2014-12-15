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
#
# Notes:
#   You need to sign up and get a client id and secret.
#
# Author:
#   github.com/robksawyer

request = require('superagent')
clientID = process.env.HUBOT_ARTSY_CLIENT_ID
clientSecret = process.env.HUBOT_ARTSY_CLIENT_SECRET
apiUrl = 'https://api.artsy.net/api/tokens/xapp_token'
xappToken = undefined

#For random number generation
low  = 1
high = 23987

module.exports = (robot) ->
  
  robot.respond /(get)? art/i, (msg) ->

    #create a random offset
    offset = Math.round(Math.floor(Math.random() * (high - low + 1)) + low)

    #Get a token
    request
      .post(apiUrl)
      .send({ client_id: clientID, client_secret: clientSecret })
      .end (res) ->
        #Save the token
        xappToken = res.body.token
        unless xappToken?
          msg.send "Had an issue connecting to Artsy.\n#{err}"
          return

        #Get a piece of art
        robot.http('https://api.artsy.net/api/artworks.json')
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
              if art_title and art_image
                msg.send art_title + "\n" + art_image
                return
            
            msg.send "The gallery is closed at the moment."

