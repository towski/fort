class Picture < Model
	def receive
		puts "breaking"
		image_time = Time.now.to_i
		filename = "/home/towski/code/fort/public/raw_images/raw_output#{image_time}.jpg"
		converted_filename = "/home/towski/code/fort/public/raw_images/output#{image_time}.jpg"
		file = File.open(filename, "w")
		file.write(output)
		file.close
		udp_in.close
		#`convert -rotate 90 #{filename} #{converted_filename}`
		`cp #{filename} /home/towski/code/fort/public/output.jpg`
		puts "got file output#{image_time}.jpg"
		return
		i += 1
		output += data[0]
	end
end
