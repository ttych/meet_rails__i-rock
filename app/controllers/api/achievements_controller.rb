module Api
  class AchievementsController < ApiController
    def index
      p request.headers["Content-Type"]

      achievements = Achievement.public_access
      render jsonapi: achievements
    end
  end
end
