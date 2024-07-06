
#### Libraries ####

#spotifyr is a Spotify wrapper for R
#dplyr - data manipulation
pacman::p_load(spotifyr, tidyverse) #load all libraries with pacman


#### Spotify Credentials ####

#import Spotify Client ID and Secret using the following code

# myclientid <- 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
# myclientsecret <- 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

Sys.setenv(SPOTIFY_CLIENT_ID = myclientid)
Sys.setenv(SPOTIFY_CLIENT_SECRET = myclientsecret)

access_token <- get_spotify_access_token() #get Spotify token


#### Load the Data ####

#Billie Holiday Spotify ID (last part of the URL of artist's profile): 1YzCsTRb22dQkh9lghPIrp

#artist's audio features
df <- get_artist_audio_features('Billie Holiday', include_groups = "compilation") #looking only at compilations

#filter data for the compilation album of interest - Lady Day: The Complete Billie Holiday On Columbia (1933-1944)
df <- filter(df, df$album_name == 'Lady Day: The Complete Billie Holiday On Columbia (1933-1944)')

#only keep variables of interest
af <- df[, c(9:19, 22, 26:27, 30, 32, 37:39)]


#### Also consider elaborating on the following ####

#look at a specific track
#track <- get_track_audio_analysis('3CagY2CVUPn1gGAI9JC0jx', authorization = get_spotify_access_token())
