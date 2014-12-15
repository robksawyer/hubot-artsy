# hubot-artsy

Robots like art.

See [`src/artsy.coffee`](src/artsy.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-artsy --save`

Then add **hubot-artsy** to your `external-scripts.json`:

```json
["hubot-artsy"]
```

## Sample Interaction

```
user1>> hubot get art
hubot>> Partie de la Cité vers la fin du XVIIe siècle (View of the City of Paris Towards the Close of the XVIIth Century)
http://static2.artsy.net/additional_images/515d55cc5eeb1c524c0041af/2/medium.jpg
```
```
user1> i like artist andy warhol he is awesome
hubot> Andy Warhol
       Obsessed with celebrity, consumer culture, and mechanical (re)production, [Pop artist](/gene/pop-art) Andy Warhol created some of the most iconic images of the 20th century. As famous for his quips as for his art—he variously mused that “art is what you can get away with” and “everyone will be famous for 15 minutes”—Warhol drew widely from popular culture and everyday subject matter, creating works like his _32 Campbell's Soup Cans_ (1962), [Brillo pad box sculptures](/artwork/andy-warhol-set-of-four-boxes-campbells-tomato-juice-del-monte-peach-halves-brillo-soap-pads-heinz-tomato-ketchup), and portraits of Marilyn Monroe, using the medium of silk-screen printmaking to achieve his characteristic hard edges and flat areas of color. Known for his cultivation of celebrity, Factory studio (a radical social and creative melting pot), and avant-garde films like _Chelsea Girls_ (1966), Warhol was also a mentor to artists like [Keith Haring](/artist/keith-haring) and [Jean-Michel Basquiat](/artist/jean-michel-basquiat). His Pop sensibility is now standard practice, taken up by major contemporary artists [Richard Prince](/artist/richard-prince), [Takashi Murakami](/artist/takashi-murakami), and [Jeff Koons](/artist/jeff-koons), among countless others.
       http://static1.artsy.net/artist_images/52f6bdda4a04f5d504f69b03/1/four_thirds.jpg
       http://artsy.net/artist/andy-warhol
```
```
user1> hubot get artist
hubot> Melvin Culaba
       http://static0.artsy.net/artist_images/53c37662776f7279d1000000/four_thirds.jpg
       http://artsy.net/artist/melvin-culaba

```

```
user1> hubot art me dragon
hubot> Raphael, Saint George and the Dragon (ca. 1506)
       https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTI9X6Q5Nvb7BTt7VtmLODHXh2s4ADXMozulZ7DmdA1gb3jYifkRLUmRJw
       https://artsy.net/artwork/raphael-saint-george-and-the-dragon
```
