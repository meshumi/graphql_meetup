# frozen_string_literal: true

module Resolvers
  class TrendingMovies < AuthBase
    type [Types::MovieType], null: false

    def resolve
      match_operation ::Movie::Operation::Trending.call(current_user: current_user)
    end
  end
end
