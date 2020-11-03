# frozen_string_literal: true

module Types
  class UserAccountType < Base::Object
    I18N_PATH = 'graphql.types.user_account_type'

    graphql_name 'UserAccountType'
    implements Types::Interfaces::Node

    description I18n.t("#{I18N_PATH}.desc")

    field :email,
          String,
          null: false,
          description: I18n.t("#{I18N_PATH}.fields.email")

    field :user_profile,
          Types::UserProfileType,
          null: true,
          description: I18n.t("#{I18N_PATH}.fields.user_profile")

    field :lists,
          Types::Connections::ListConnection,
          null: true,
          connection: true,
          description: I18n.t("#{I18N_PATH}.fields.lists")
    field :watchlist_movies_list,
          Types::Connections::MovieConnection,
          null: true,
          connection: true,
          description: I18n.t("#{I18N_PATH}.fields.watch_list_movies")

    field :favorite_movies_list,
          Types::Connections::MovieConnection,
          null: true,
          connection: true,
          description: I18n.t("#{I18N_PATH}.fields.favorite_movies") do
      argument :order_by, Types::Inputs::MovieOrderingInput, required: false, prepare: ->(order_by, _ctx) { order_by.to_h }
    end

    def lists
      BatchLoader::GraphQL.for(object.id).batch(default_value: []) do |ids, loader|
        ::List.where(user_account_id: ids).each do |list|
          loader.call(list.user_account_id) { |memo| memo << list }
        end
      end
    end

    def watchlist_movies_list
      BatchLoader::GraphQL.for(object.id).batch(default_value: []) do |ids, loader|
        ::WatchlistMovie.where(user_account_id: ids).includes(:movie).joins(:movie).each do |watchlist_movie|
          loader.call(watchlist_movie.user_account_id) { |memo| memo << watchlist_movie.movie }
        end
      end
    end

    def favorite_movies_list(order_by: nil)
      BatchLoader::GraphQL.for(object.id).batch(default_value: []) do |ids, loader|
        ::FavoriteMovie.where(user_account_id: ids).includes(:movie).joins(:movie)
          .order("movies.#{order_by[:sort]} #{order_by[:direction]}").each do |favorite_movie|
          loader.call(favorite_movie.user_account_id) { |memo| memo << favorite_movie.movie }
        end
      end
    end
  end
end
