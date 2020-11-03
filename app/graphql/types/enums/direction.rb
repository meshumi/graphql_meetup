# frozen_string_literal: true

module Types::Enums
  class Direction < ::Types::Base::Enum
    I18N_PATH = 'graphql.enums.direction'

    description I18n.t("#{I18N_PATH}.desc")

    value 'ASC' do
      value 'asc'
      description I18n.t("#{I18N_PATH}.values.asc")
    end

    value 'DESC' do
      value 'desc'
      description I18n.t("#{I18N_PATH}.values.desc")
    end
  end
end
