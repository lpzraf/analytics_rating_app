module SessionsHelper

  def log_out
    session.delete(:student_id)
    @current_student = nil
  end

  # Logs in the given user.
  def log_in(student)
    session[:student_id] = student.id
  end

  def current_student
    if session[:student_id]
      @current_user ||= Student.find_by(id: session[:student_id])
    end
  end

  def logged_in?
    !current_student.nil?
  end

  def log_out
    session.delete(:student_id)
    @current_student = nil
  end
end
