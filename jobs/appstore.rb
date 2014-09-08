#!/usr/bin/env ruby
require_relative '../lib/appRating/AppStore'
require_relative '../lib/appRating/Rating'

appPageUrl = '/gb/app/chester-zoo/id820950885'
app_store = AppStore.new('itunes.apple.com')
 
apps = [{url: '/gb/app/chester-zoo/id820950885', event: 'iOS Chester Zoo'}]

SCHEDULER.every '1h', :first_in => 0 do |job|
    apps.each do | app |
      response = app_store.get_response_for_app(app[:url]);
      
      average_rating = response.body.scan( /(Version(s)?:(.)*?aria-label=[\"\'](?<num>.*?)star)/m )
      voters_count = response.body.scan( /(class=[\"\']rating-count[\"\']>(?<num>([\d,.]+)) )/m )
   
      rating = Rating.new(average_rating,voters_count)
      last_version = rating.retrieve_last_version
      all_versions = rating.retrieve_all_versions

      data = {
        last_version: last_version,
        all_versions: all_versions,
        app_type: 'ios'
      }

      send_event(app[:event], data)
    end
end