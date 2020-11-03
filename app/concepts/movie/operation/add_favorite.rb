# frozen_string_literal: true

module Movie::Operation
  class AddFavorite < Trailblazer::Operation
    step :find_movie
    step :movie_exists?
    fail :movie_does_not_exist

    step :movie_non_favorite?
    fail :already_at_favorites

    step Rescue(ActiveRecord::RecordInvalid, handler: :error_handler) {
      step :create_favorite_movie!
    }

    step :set_result

    def find_movie(ctx, params:, **)
      ctx['model'] = Movie.find_by(id: params[:movie_id])
    end

    def movie_exists?(_ctx, model:, **)
      model.present?
    end

    def movie_non_favorite?(_ctx, model:, current_user:, **)
      !FavoriteMovie.exists?(movie_id: model.id, user_account_id: current_user.id)
    end

    def create_favorite_movie!(_ctx, model:, current_user:, **)
      FavoriteMovie.create!(movie_id: model.id, user_account_id: current_user.id)
    end

    def already_at_favorites(ctx, **)
      ctx['operation_status'] = :bad_request
      ctx['operation_message'] = I18n.t('graphql.errors.messages.movie.already_favorited')
    end

    def movie_does_not_exist(ctx, **)
      ctx['operation_status'] = :bad_request
      ctx['operation_message'] = I18n.t('graphql.errors.messages.movie.movie_does_not_exist')
    end

    def set_result(ctx, model:, **)
      ctx['result'] = model
    end

    private

    def error_handler(exception, ctx)
      ctx['operation_status'] = :execution_error

      raise ActiveRecord::Rollback, exception.message
    end
  end
end
