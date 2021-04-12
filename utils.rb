def getGenres(package)
    genres = package[0][13].to_s
   return genres.gsub(' - ', '|')
end

def getYears(date1)
    tab = Array.new
    pp date1.year
    tab = date1.split('/')
    return tab[2]
end

def getPrice(package)
    price = 0
    package.each {|song| price = price + $price}
    return price.round(2)
end

# Build the full data track for the release
def buildDataTrack(package)
    playlist = ""
    i = 1
    package.each do |son|
        playlist = playlist + "<a href=\"http:\/\/player.yoyaku.io/mp3/#{son[1]}_#{i}.mp3\">#{son[7]} - #{son[9]}</a>\n"
        i = i + 1
    end
    return playlist
end
