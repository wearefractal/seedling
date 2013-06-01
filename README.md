![status](https://secure.travis-ci.org/wearefractal/seedling.png?branch=master)

## Information

<table>
<tr> 
<td>Package</td><td>seedling</td>
</tr>
<tr>
<td>Description</td>
<td>help create seed data for mongoose</td>
</tr>
<tr>
<td>Node Version</td>
<td>>= 0.4</td>
</tr>
</table>

## Install

`npm install seedling`

## Usage

```coffee-script
goosestrap  = require 'goosestrap'

db = goosestrap "mongodb://localhost", "./models"

seedData =
  User: [
    username: 'admin'
    id: '1'
    token: '1'
    password: 'secret' 
  ]

  Location: [
    name: "Scottsdale Fashion Square"
    coords: 
      lat: 33.5038 
      lon: 111.9296
  ]

  Movie: -> [
    name: "Star Trek Into Darkness"
    date: "5/15/13"
    # grabs random
    location: seed.ref 'Location'
  ,
    name: "The Iceman"
    date: "5/15/13"
    location: seed.ref 'Location'
  ]

seed = new seedling db, seedData

# clear db
seed.clear ->
  # create seed data
  seed.create (err) ->
	  console.log err if err?

```

## LICENSE

(MIT License)

Copyright (c) 2013 Fractal <contact@wearefractal.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
