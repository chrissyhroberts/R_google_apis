#Depends on having an account for using Google APIs through google cloud
# this is pay per use services

#https://console.cloud.google.com/

#see here for usefuls https://github.com/ropensci/googleLanguageR

#Enable these APIs
#Google Natural Language API
#Google Cloud Translation API
#Google Cloud Speech-to-Text API
#Google Cloud Text-to-Speech API



## GEOCODING
library(ggmap)
library(leaflet)
aa<-geocode("Swonnels Walk, Lowestoft, UK", output = "latlon")
paste(aa$lat,aa$lon)

leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=aa$lon, lat=aa$lat, popup="Swonnels Walk, Lowestoft")



library(googleLanguageR)
#if the json file for authenticating the API is not in the .Renviron file, then point to it directly
#gl_auth("location_of_json_file.json")


###
#The Natural Language API returns natural language understanding technolgies. You can call them individually, or the default is to return them all. The available returns are:

#Entity analysis - Finds named entities (currently proper names and common nouns) in the text along with entity types, salience, mentions for each entity, and other properties. If possible, will also return metadata about that entity such as a Wikipedia URL. If using the v1beta2 endpoint this also includes sentiment for each entity.
#Syntax - Analyzes the syntax of the text and provides sentence boundaries and tokenization along with part of speech tags, dependency trees, and other properties.
#Sentiment - The overall sentiment of the text, represented by a magnitude [0, +inf] and score between -1.0 (negative sentiment) and 1.0 (positive sentiment).

texts<-c("We are in a lucky position to live on a farm so the children have lots of outside space and it is easy to self-isolate and socially distance, however we are further from healthcare.
We have been keeping up with our community mainly through class whatapp group, school website and homeschooling information from the internet.  Video calling family, especially my mother who lives alone and so has no physical contact with anyone.  Trying to limit news and reading articles on the internet to once a day.  Catching up on things I dont usually get to do that often such as reading, playing games, crafts. I am a holistic therapist so have a practice in relaxation techniques etc so I think that goes a long way to understanding and alleviating anxiety and panic.","I initially panicked as my son was away at University, however he is now repatriated. Working from home but on the dining room table, youngest son now sleeping on the floor as his bedroom was due to be redone and his bed had been sold (with brother home we have no spare room). Shopping once a week on my own, running alternate days, gardening, board games to break up the time children are spending on social media/TV etc.")

nlp_result <- gl_nlp(texts)

# two results of lists of tibbles
str(nlp_result, max.level = 2)
(nlp_result$language)
View(nlp_result$entities[[1]])
(nlp_result$classifyText)
View(nlp_result$sentences)[[1]]
(nlp_result$tokens)



#Google Translation API
#You can detect the language via gl_translate_detect, or translate and detect language via gl_translate
#Note this is a lot more refined than the free version on Google’s translation website.

text <- "to administer medicine to animals is frequently a very difficult matter, and yet sometimes it's necessary to do so"
## translate British into Danish
gl_translate(text, target = "ja")$translatedText


#Google Cloud Speech-to-Text API
#The Cloud Speech-to-Text API provides audio transcription. Its accessible via the gl_speech function.
#If you need to convert file to wav then use ffmpeg on command line, may need install, best done through homebrew

## convert the sample source file if needed i.e.
system("ffmpeg -i in.m4a in.wav")

#split the file in to 1 minute chunks

system("ffmpeg -i in.wav -f segment -segment_time 30 -c copy out_%03d.wav")

## its not perfect but...:)
transcript28<-gl_speech("out_028.wav",sampleRateHertz = "48000",languageCode = "fr-FR")


## # A tibble: 1 x 2
##   transcript                                                    confidence
##   <chr>                                                         <chr>
## 1 to administer medicine to animals is frequency of very diffi… 0.9180294
