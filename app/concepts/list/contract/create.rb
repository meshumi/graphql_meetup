# frozen_string_literal: true

module List::Contract
  class Create < Reform::Form
    feature Reform::Form::Dry

    property :name
    property :description

    validation :default do
      configure do
        def unique_name?(name)
          !List.exists?(name: name)
        end
      end
      required(:name).filled(:str?, :unique_name?, min_size?: 1)
      optional(:description).maybe(:str?)
    end
  end
end
