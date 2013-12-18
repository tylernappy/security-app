class EventsController < ApplicationController
	def home

	end

	def index
		@events_hosting = []
		@events_going_to = []
		@all_events = Event.all
		if user_signed_in? && @all_events.empty? == false #check to see if a user is signed in
			events_array = events_organizer(@all_events)
			@events_hosting = events_array[0]
			@events_going_to = events_array[1]
		end

		@events = @events_hosting+@events_going_to
		@events_today = events_today(@events)
		@todays_date = Time.now.strftime("%m/%d/%Y") 
		if user_signed_in? && @events_today.length != 0
			if @events.length > 1
				@image = google_map_image_multiple(@events_today)
			else
				@image = google_map_image_single(@events_today)
			end
    else
      @image = "http://maps.googleapis.com/maps/api/staticmap?center=Midtown+New+York,NY&size=400x400&zoom=12&sensor=false"
		end

		@letter = "A"
	
	end

	def show
		@event = find_event
		@guests = @event.guests
		@image = google_map_image_single(@event)
	end

	def new
		if user_signed_in?
			@event = Event.new
		else
			redirect_to new_user_session_path
		end
	end

	def create
		@event = Event.new(event_params)
		@event.save
		redirect_to @event
	end

	def destroy
		@event = find_event
		@event.destroy
		redirect_to events_path
	end

	def edit
		@event = Event.find(params[:id])
	end

	def update
		@event = find_event
		@event.update(event_params)		
		redirect_to @event
	end

	private
	def event_params
		params.require(:event).permit(:name, :description, :floor, :room, :date, :time, :address, :owner_id, :search)
	end

	def find_event
		Event.find(params[:id])
	end

	def google_map_image_single event
		if event[0].nil?
      address = event.address
    else
      address = event[0].address
    end
		address = address.tr(" ", "+")
  	return "http://maps.googleapis.com/maps/api/staticmap?center=#{address}+New+York,NY&size=400x400&zoom=15&markers=color:blue%7C#{address}+New+York,NY&sensor=false"
  end
  
  def google_map_image_multiple events
  	url_string = []
  	letter = "A"
  	events.each do |event|
  		address = event.address.tr(" ", "+")+"+New+York,NY"
  		url_string << "&markers=color:blue%7Clabel:#{letter}%7C#{address}"
  		letter = letter.next
  	end
  	url_string = url_string.join
  	return "http://maps.googleapis.com/maps/api/staticmap?center=Midtown+New+York,NY&size=400x400&zoom=12#{url_string}&sensor=false"
  end

	def events_organizer events
		events_array = [Array.new, Array.new]
		todays_date = Time.now.strftime("%m/%d/%Y")
 		events.each do |event|
			event_date = event.date.strftime("%m/%d/%Y")
			if event_date >= todays_date #will not accept dates that have already passed
				events_array[0] << event if current_user.id == event.owner_id #hosting
				events_array[1] << event if event.guests.find_by_name(current_user.name) && events_array[0].include?(event) == false #going to
			end
		end
		return events_array
	end

	def events_today events
		if user_signed_in? && @events.nil? == false
			events_array = []
			todays_date = Time.now.strftime("%m/%d/%Y") 
			events.sort {|a,b| a.time <=> b.time }.each do |event|
				if event.date.strftime("%m/%d/%Y") == todays_date
	      	events_array << event
	    	end
	    end
	  end
    return events_array
	end

  #return "http://maps.googleapis.com/maps/api/staticmap?center=#{address}+New+York,NY&size=400x400&zoom=13#{url_string}&sensor=false"

  # def add_to_google_calendar event
  # 	event = {
  # 		'summary' => @event.description,
  # 		'location' => @event.address,
  # 		'start' => {
  #   	'dateTime' => '2011-06-03T10:00:00.000-07:00'
 	# 		},
  # 		'end' => {
  #   	'dateTime' => '2011-06-03T10:25:00.000-07:00'
  # 		},
  # 		'attendees' => [
  #   	{
  #     'email' => 'tylernappy@gmail.com'
  #   	},
  #  		#...
  # 		]
		# }
		# result = client.execute(:api_method => service.events.insert,
  #                       :parameters => {'calendarId' => 'primary'},
  #                       :body => [JSON.dump(event)],
  #                       :headers => {'Content-Type' => 'application/json'})

 	# # event = {
  # # 		'summary' => 'Appointment',
  # # 		'location' => 'Somewhere',
  # # 		'start' => {
  # #   	'dateTime' => '2011-06-03T10:00:00.000-07:00'
 	# # 		},
  # # 		'end' => {
  # #   	'dateTime' => '2011-06-03T10:25:00.000-07:00'
  # # 		},
  # # 		'attendees' => [
  # #   	{
  # #     'email' => 'attendeeEmail'
  # #   	},
  # #  		#...
  # # 		]
		# # }
  # end

end
