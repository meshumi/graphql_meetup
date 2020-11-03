# frozen_string_literal: true

module Types::Enums
  class MoviesSort < ::Types::Base::Enum
    I18N_PATH = 'graphql.enums.movies_sort'

    description I18n.t("#{I18N_PATH}.desc")

    value 'TITLE' do
      value 'title'
      description I18n.t("#{I18N_PATH}.values.title")
    end

    value 'ORIGINAL_TITLE' do
      value 'original_title'
      description I18n.t("#{I18N_PATH}.values.original_title")
    end

    value 'REVENUE' do
      value 'revenue'
      description I18n.t("#{I18N_PATH}.values.revenue")
    end

    value 'BUDGET' do
      value 'budget'
      description I18n.t("#{I18N_PATH}.values.budget")
    end

    value 'RUNTIME' do
      value 'runtime'
      description I18n.t("#{I18N_PATH}.values.runtime")
    end

    value 'ORIGINAL_LANGUAGE' do
      value 'original_language'
      description I18n.t("#{I18N_PATH}.values.original_language")
    end

    value 'CREATED_AT' do
      value 'created_at'
      description I18n.t("#{I18N_PATH}.values.created_at")
    end
  end
end
