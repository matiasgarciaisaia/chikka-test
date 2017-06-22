require 'sinatra'
require 'chikka'
require 'pry-byebug'

chikka = Chikka::Client.new

get '/' do
  'Hi there!'
end

get '/chikka/:contact' do
  mobile_number = params['contact']
  text = params['text'] || 'This is a test'
  request_id = params['request_id']
  puts "Sending#{' REQ ' + request_id if request_id} to #{mobile_number} - Message: #{text}"
  res = chikka.send_message(message: text, mobile_number: mobile_number, request_id: request_id)
  if res.status == 200
    puts "Sending: message #{res.message_id} ACCEPTED"
    "Message is being sent with ID #{res.message_id}"
  else
    puts "Sending: message #{res.message_id} FAILED (#{res.status} - #{res.description})"
    "Error delivering message: #{res.to_s}"
  end
end

post '/notification' do
  puts "Notification: message #{params['message_id']} to #{params['mobile_number']} is #{params['status']}"
  'Accepted'
end

post '/message' do
  puts "Received: #{params['timestamp']} - from #{params['mobile_number']} (req #{params['request_id']}): #{params['message']}"
  res = chikka.send_message(message: "Thank you for your message, #{params['mobile_number']}!", mobile_number: params['mobile_number'], request_id: params['request_id'])
  puts "Responded: #{res.message_id}"
  'Accepted'
end
