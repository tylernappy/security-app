class UsersController < ApplicationController

	def show
		@user = find_user
		#@guest = find_guest(@event)
	end

	def edit
		@user = find_user
	end

	def update
		@user = User.find(params[:id])
		@user.update(user_params)		
		redirect_to @user
	end

	def destroy
		@user = find_user
		@user.destroy
		redirect_to @user
	end

	private
	def user_params
		params.require(:user).permit(:name, :email, :phone, :title, :type, :address, :company, :guest_id)
	end

	def find_event

	end

	# def find_guest user
	# 	user.guests.find(params[:id])
	# end

	def find_user
		User.find(params[:id])
	end

end
