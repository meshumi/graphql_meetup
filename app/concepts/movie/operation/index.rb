# frozen_string_literal: true

module Movie::Operation
  class Index < Trailblazer::Operation
    step :set_result

    def set_result(ctx, params:, **)
      ctx['result'] = ::Movie.where('title LIKE ?', "%#{params}%")
    end
  end
end
