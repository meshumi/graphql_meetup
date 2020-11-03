# frozen_string_literal: true

module Movie::Operation
  class RemoveFavorite < Trailblazer::Operation
    step :find_favorite_movie
    step :favorite_movie_exists?
    fail :movie_is_not_favorite

    step Rescue(ActiveRecord::RecordInvalid, handler: :error_handler) {
      step :remove_favorite_movie!
    }

    step :set_result

    def find_favorite_movie(ctx, params:, **)
      ctx[:model] = FavoriteMovie.find_by(movie_id: params[:movie_id], user_account_id: ctx[:current_user].id)
    end

    def favorite_movie_exists?(_ctx, model:, **)
      model.present?
    end

    def remove_favorite_movie!(_ctx, model:, **)
      model.destroy!
    end

    def movie_is_not_favorite(ctx, **)
      ctx['operation_status'] = :bad_request
      ctx['operation_message'] = I18n.t('graphql.errors.messages.movie.movie_is_not_favorite')
    end

    def set_result(ctx, params:, **)
      ctx['result'] = { removed_movie_id: params[:movie_id] }
    end

    private

    def error_handler(exception, ctx)
      ctx['operation_status'] = :execution_error

      raise ActiveRecord::Rollback, exception.message
    end
  end
end
