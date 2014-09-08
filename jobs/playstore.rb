#!/usr/bin/env ruby
require_relative '../lib/appRating/AppStore'
require_relative '../lib/appRating/Rating'
 
appPageUrl = '/store/apps/details?id=org.chesterzoo.companion'
app_store = AppStore.new('play.google.com')

SCHEDULER.every '1h', :first_in => 0 do |job|
  response = app_store.get_response_for_app(appPageUrl);
    
    average_rating = response.body.scan( /class=[\"\']score[\"\']>([\d,.]+)</m)
    voters_count = response.body.scan( /class=[\"\']reviews-num[\"\']>([\d,.]+)</m )
 
    rating = Rating.new(average_rating, voters_count)
    last_version = rating.retrieve_last_version
 
    data = {
      last_version: last_version
    }

    send_event('Android Chester Zoo', data)
end