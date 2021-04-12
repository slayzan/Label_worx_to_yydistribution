require 'pp'
require_relative 'utils'
require 'spreadsheet'
require 'nokogiri'

begin
    workbook = Spreadsheet.open ARGV[0]
    worksheets = workbook.worksheets
    ws = worksheets[0]
rescue
    abort "Error while opening file please open .xls files only"
end

$catalog_current = ws.rows[4][1]
pp ws.rows[4][1]
$price = 1.29

#Build xml file
def sendPackage(package,xml)
i = 1
    xml.release{
        xml.post{
            xml.title package[0][3]
            xml.slug "#{package[0][1]}"
            xml.sku_ep package[0][1]
            xml.sku package[0][1]
            xml.artists package[0][2]
            xml.label package[0][0]
            xml.genres getGenres(package)
            xml.years package[0][4].year
            xml.type "release"
            xml.price getPrice(package)
            xml.description package[0][5]
            xml.owners "label worx"
            xml.product_visibility "visible"
            xml.file_path nil
            xml.featured_image "https://www.aze.digital/wp-content/uploads/#{package[0][4].year}/#{package[0][1]}"
            xml.short_description buildDataTrack(package)
        }
    }
end

#read the xls until he find a different sku then send all the previous to build the release
def readXls(ws,xml)
    package = Array.new
    i = 4
    j = 0
    while ws.rows[i]
       # pp ws.rows[i]
        if ws.rows[i] == nil
            break
        end
        if  ws.rows[i][1] == $catalog_current
            package[j] =  ws.rows[i]
            j = j + 1
            i = i +1
        else
            sendPackage(package,xml)
            $catalog_current = ws.rows[i][1]
            j = 0
            package.clear
        end
    end
end


def build_xml(ws)
    i = 0
    j = 0
    builder = Nokogiri::XML::Builder.new do |xml|
       xml.data{
           readXls(ws,xml)
       }
    end
        File.open("data/output.xml", 'w'){ |f| f.write(builder.to_xml)}
end


build_xml(ws)