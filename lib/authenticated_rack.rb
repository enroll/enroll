class AuthenticatedRack
  def initialize(app)
    @app = app
  end

  def call(env)
    warden_user = env['warden'].user
    if warden_user && warden_user.staff?
      @app.call(env)
    else
      [403, {"Content-Type" => "text/html"}, ["Forbidden: Authenticate first"]]
    end
  end
end
