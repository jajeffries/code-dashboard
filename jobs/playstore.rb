#!/usr/bin/env ruby
require 'net/http'
require 'openssl'
 
# Average+Average Voting on an Android App
#
# This job will track the average vote score and number of votes on an app
# that is registered in the google play market by scraping the google play
# market website.
#
# There are two variables send to the dashboard:
# `google_play_voters_total` containing the number of people voted
# `google_play_average_rating` float value with the average votes
 
# Config
# ------
appPageUrl = 'https://play.google.com/store/apps/details?id=org.chesterzoo.companion'
 
SCHEDULER.every '24h', :first_in => 0 do |job|
  puts "fetching App Store Rating for App: " + appPageUrl
  # prepare request
  http = Net::HTTP.new("play.google.com", Net::HTTP.https_default_port())
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE # disable ssl certificate check
 
  # scrape detail page of appPageUrl
  response = http.request( Net::HTTP::Get.new(appPageUrl) )
 
  if response.code != "200"
    puts "google play store website communication (status-code: #{response.code})\n#{response.body}"
  else
    data = { 
      :last_version => {
        average_rating: 0.0,
        voters_count: 0}, 
    }
    
    # Version: ... aria-label="4 stars, 2180 Ratings"
    average_rating = response.body.scan( /class=[\"\']score[\"\']>([\d,.]+)</m)
    print "#{average_rating}\n"
    # <span class="rating-count">24 Ratings</span>
    voters_count = response.body.scan( /class=[\"\']reviews-num[\"\']>([\d,.]+)</m )
    print "#{voters_count}\n"
 
    #last versions average rating 
    if ( average_rating )
      if ( average_rating[0] ) # Last Version
        raw_string = average_rating[0][0].gsub('star', '')
        clean_string = raw_string.match(/[\d,.]+/i)[0]
        last_version_average_rating = clean_string.gsub(",", ".").to_f
        half = 0.0
        if ( raw_string.match(/half/i) )
          half = 0.5
        end
        last_version_average_rating += half
        data[:last_version][:average_rating] = '%.1f' % last_version_average_rating
      
      end
 
      if ( average_rating[1] ) # All Versions
        raw_string = average_rating[1][0].gsub('star', '')
        clean_string = raw_string.match(/[\d,.]+/i)[0]
        all_versions_average_rating = clean_string.gsub(",", ".").to_f
        half = 0.0
        if ( raw_string.match(/half/i) )
          half = 0.5
        end
        all_versions_average_rating += half
        data[:all_versions][:average_rating] = '%.1f' % all_versions_average_rating
     
      end
    end
 
    # all and last versions voters count 
    if ( voters_count )
      if ( voters_count[0] ) # Last Version
        last_version_voters_count = voters_count[0][0].gsub(',', '').to_i
        data[:last_version][:voters_count] = last_version_voters_count
      else 
        puts 'ERROR::RegEx for last version voters count didn\'t match anything'
      end
 
      if ( voters_count[1] ) # All Versions
        all_versions_voters_count = voters_count[1][0].gsub(',', '').to_i
        puts all_versions_voters_count
        data[:all_versions][:voters_count] = all_versions_voters_count
      else 
        puts 'ERROR::RegEx for all versions voters count didn\'t match anything'
      end
    end
 
 
    if defined?(send_event)
      send_event('Android Chester Zoo', data)
    else
      print "#{data}\n"
    end
  end
end