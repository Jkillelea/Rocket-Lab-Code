#!/usr/bin/env ruby
require 'socket'

server = TCPServer.open(2000)

loop {
	begin
		client = server.accept

		puts client.inspect

		input = File.open 'Detn.inp', 'w'
		puts 'input'
		while line = client.gets
			# puts line
			input.write line

			break if line.include? "end"
		end
		input.close

		puts 'cea'
		system 'wine CEA600.exe'

		puts 'output'
		output = File.read 'Detn.out'
		# puts output
		client.puts output
		client.puts 'TRANSMISSION DONE'
		client.close
		puts 'done'

	rescue Interrupt
		exit
	rescue
		retry
	end
}

socket.close
