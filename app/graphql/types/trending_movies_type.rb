# frozen_string_literal: true

module Types
  class TrendingMoviesType < Base::Object
    I18N_PATH = 'graphql.types.trending_movies_type'

    graphql_name 'TrendingMovies'
    description I18n.t("#{I18N_PATH}.desc")

    field :trending_movies,
          [Types::MovieType],
          null: true,
          description: I18n.t("#{I18N_PATH}.fields.trending_movies")
  end
end
