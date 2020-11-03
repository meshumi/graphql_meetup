# frozen_string_literal: true

module Movie::Operation
  class RemoveWatchlistMovie < Trailblazer::Operation
    step :init_model
    step :movie_added_to_watchlist?
    fail :movie_not_added

    step Rescue(ActiveRecord::RecordInvalid, handler: :error_handler) {
      step :remove_movie!
    }

    step :set_result

    def init_model(ctx, params:, **)
      ctx[:model] = WatchlistMovie.find_by(movie_id: params[:movie_id], user_account_id: ctx[:current_user].id)
    end

    def movie_added_to_watchlist?(_ctx, model:, **)
      model.present?
    end

    def remove_movie!(_ctx, model:, **)
      model.destroy!
    end

    def movie_not_added(ctx, **)
      ctx['operation_status'] = :bad_request
      ctx['operation_message'] = I18n.t('graphql.errors.messages.movie.movie_not_added')
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
