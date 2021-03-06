class SessionsController < ApplicationController
  def new
  end

  def create
      if auth
        @student = Student.find_or_create_by(uid: auth['uid']) do |u|
          u.first_name = auth['info']['name'].split(" ")[0..-2].join(" ")
          u.last_name = auth['info']['name'].split(" ").last
          u.email = auth['info']['email']
          u.password = auth['uid'] #use secure random hex
        end

        session[:student_id] = @student.id

        flash[:success] = "Welcome"
        redirect_to '/courses'
      else
           @student = Student.find_by(email: params[:session][:email].downcase)
           #@student = Student.find_by(first_name: params[:student][:first_name])
            # if student && student.authenticate(params[:session][:password])
            #   log_in student
            #   params[:session][:remember_me] == '1' ? remember(student) : forget(student)
            #   #redirect_back_or student
            if @student && @student.authenticate(params[:session][:password])
              session[:student_id] = @student.id
              flash[:success] = "Awesome. You are logged in!"

              redirect_to @student
            else
              flash.now[:danger] = 'Invalid email/password combination'
              render 'new'
          end
      end
  end


  def destroy
    log_out if logged_in?
    flash[:success] = "Good bye! You have succesfully logged out."
    redirect_to root_url
  end

  private

  def auth
    request.env['omniauth.auth']
  end

end
