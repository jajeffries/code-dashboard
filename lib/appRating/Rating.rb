class Rating 
  def initialize(average_rating, voters_count)
    @average_rating = average_rating
    @voters_count = voters_count
  end

  def retrieve_last_version
    last_version = {
          average_rating: 0.0,
          voters_count: 0
        }

    if ( @average_rating )
      if ( @average_rating[0] )
        last_version[:average_rating] = extract_average_rating(@average_rating[0])
      end
    end
 
    if ( @voters_count )
      if ( @voters_count[0] ) 
        last_version[:voters_count] = extract_voters_count(@voters_count[0])
      end
    end

    return last_version
  end

  def retrieve_all_versions

    all_versions = {
      average_rating: 0.0,
      voters_count: 0
    }

    if ( @average_rating )
      if ( @average_rating[1] )
        all_versions[:average_rating] = extract_average_rating(@average_rating[1])
      end
    end
 
    if ( @voters_count )
      if ( @voters_count[1] ) 
        all_versions[:voters_count] = extract_voters_count(@voters_count[1])
      else 
        puts 'ERROR::RegEx for last version voters count didn\'t match anything'
      end
    end

    return all_versions
  end

  def extract_average_rating(element)
    raw_string = element[0].gsub('star', '')
    clean_string = raw_string.match(/[\d,.]+/i)[0]
    last_version_average_rating = clean_string.gsub(",", ".").to_f
    half = 0.0
    if ( raw_string.match(/half/i) )
      half = 0.5
    end
    last_version_average_rating += half
    return '%.1f' % last_version_average_rating
  end

  def extract_voters_count(element)
    return element[0].gsub(',', '').to_i
  end
end