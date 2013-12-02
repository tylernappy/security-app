class GuestsController < ApplicationController
	def index
		@event = find_event
		@guests = Guest.all
	end

	def new
		@event = find_event
		@guest = @event.guests.new
	end

	def create
		@event = find_event
		@guest = @event.guests.create(guest_params)
		@guest.save
		redirect_to new_event_guest_path
	end

	def show
		@event = find_event
		@guest = find_guest(@event)
	end

	def edit
		@event = find_event
		@guest = find_guest(@event)
	end

	def destroy
		@event = find_event
		@guest = find_guest(@event)
		@guest.destroy
		redirect_to @event
	end

	private
	def guest_params
		params.require(:guest).permit(:name, :email, :phone, :company, :event_id)
	end

	def find_event
		Event.find(params[:event_id])
	end

	def find_guest event
		event.guests.find(params[:id])
	end

	def user_exists?(email)
		User.find_by_email(email).present? ? true : false
	end

end
