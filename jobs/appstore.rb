#!/usr/bin/env ruby
require_relative '../lib/appRating/AppStore'
require_relative '../lib/appRating/Rating'

app_store = AppStore.new('itunes.apple.com')
 
apps = [
  {url: '/gb/app/chester-zoo/id820950885', event: 'iOS Chester Zoo'},
  {url:'/gb/app/nus-extra-student-discount/id566839337', event:'iOS NUS Extra'}
]

SCHEDULER.every '1h', :first_in => 0 do |job|
    apps.each do | app |
      response = app_store.get_response_for_app(app[:url]);
      
      average_rating = response.body.scan( /(Version(s)?:(.)*?aria-label=[\"\'](?<num>.*?)star)/m )
      voters_count = response.body.scan( /(class=[\"\']rating-count[\"\']>(?<num>([\d,.]+)) )/m )
   
      rating = Rating.new(average_rating,voters_count)

      if average_rating.length > 1
        last_version = rating.retrieve_last_version
      end
      all_versions = rating.retrieve_all_versions

      data = {
        last_version: last_version,
        all_versions: all_versions
      }

      send_event(app[:event], data)
    end
end