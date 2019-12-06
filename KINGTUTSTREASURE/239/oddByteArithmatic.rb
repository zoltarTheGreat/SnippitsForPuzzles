#Array for all bytes
bytesArray = []
odds = []

File.open("bytes.txt", "r") do |file|
    file.each_line.each do |each_line|
        bytesArray += each_line.split()
    end
end

#Only odd numbers if 0 = 1, 2 = 3, etc
for byteIndex in (0...bytesArray.length)
    if(byteIndex % 2 == 0)
        odds.push(bytesArray[byteIndex])
    end
end

add = false
multiply = false
product = 1
total = 0
#Multiply and add
for byte in odds
    if(!add && !multiply)
        product = byte.hex
        print  "#{byte.hex}*"
        multiply = true
    elsif(!add && multiply)
        product *= byte.hex
        print  "#{byte.hex} + "
        multiply = false
        add = true
    elsif(add && !multiply)
        total += product
        product = byte.hex
        print  "#{byte.hex}*"
        #print  "#{product} + "
        add = false
        multiply = true
    end
end

puts "#{total}"

    