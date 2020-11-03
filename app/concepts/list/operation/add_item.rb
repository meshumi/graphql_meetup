# frozen_string_literal: true

module List::Operation
  class AddItem < Trailblazer::Operation
    step :init_model
    step Contract::Build(constant: List::Contract::AddItem)
    step Contract::Validate(), fail_fast: true
    step :item_not_added?
    fail :already_added

    step Rescue(ActiveRecord::RecordInvalid, handler: :error_handler) {
      step :add_item!
    }

    step :set_result

    def init_model(ctx, params:, **)
      ctx[:model] = List.find_by(id: params[:list_id])
    end

    def item_not_added?(_ctx, params:, **)
      !ListsMovie.exists?(list_id: params[:list_id], movie_id: params[:movie_id])
    end

    def add_item!(_ctx, params:, **)
      ListsMovie.create!(list_id: params[:list_id], movie_id: params[:movie_id])
    end

    def already_added(ctx, **)
      ctx['operation_status'] = :bad_request
      ctx['operation_message'] = I18n.t('graphql.errors.messages.movie.already_added')
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
