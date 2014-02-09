class Picture < Model
  def self.receive(output, id)
    puts "breaking"
    image_time = Time.now.to_i
    filename = "/home/towski/code/fort/public/raw_images/raw_output#{id}.jpg"
    #converted_filename = "/home/towski/code/fort/public/raw_images/output#{id}.jpg"
    file = File.open(filename, "w")
    file.write(output)
    file.close
    #`convert -rotate 90 #{filename} #{converted_filename}`
    #`cp #{filename} /home/towski/code/fort/public/output.jpg`
    puts "got file output#{id}.jpg"
    filename
  end
end
