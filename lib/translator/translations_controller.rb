module Translator
  # Acts as the controller for the Translation class.
  class TranslationsController < ActionController::Base
    # GET translator/translations
    def translations
      render json: ordered_translations.to_json, status: 200
    end

    # POST translator/translate
    def translate
      Translator::Translation.translate(translate_params[:translations].to_h)
      render json: true, status: 200
    end

    private

    # @return [Param] with whitelisted parameters.
    def translate_params
      params.permit(translations: I18n.available_locales.map { |e| [e, {}] }.to_h)
    end

    # @return [Hash] with the keys in alphabetic order and first the untranslated keys
    def ordered_translations
      I18n.translations.map do |locale, keys|
        [locale, keys.sort_by { |key, options| [options[:value] ? 1 : 0, key] }.to_h]
      end.to_h
    end
  end
end
