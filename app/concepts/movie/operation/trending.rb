# frozen_string_literal: true

module Movie::Operation
  class Trending < Trailblazer::Operation
    step :set_result

    def set_result(ctx, **)
      ctx['result'] = ::Movie.order(:created_at)
    end
  end
end
