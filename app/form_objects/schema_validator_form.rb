# frozen_string_literal: true
# JSON schema validator
class SchemaValidatorForm
  attr_reader :params, :controller_params

  def initialize(params, controller_params)
    @params = params
    @controller_params = controller_params
  end

  def validate
    schema_path = set_schema_root_path
    errors = JSON::Validator.fully_validate(schema_path, params.to_json).uniq
    valid = errors.empty?
    error = fetch_custom_errors(errors) unless valid
    [valid, error]
  end

  private

  def fetch_custom_errors(errors)
    error_messages = JSONSchemaErrorParser.parse(errors)
    raise JSON::Schema::CustomFormatError, error_messages
  rescue JSON::Schema::CustomFormatError => excp
    excp
  end

  def set_schema_root_path
    controller_name = controller_params[:controller_name]
    action_name = controller_params[:action_name]
    root_path = "#{Rails.root}/app/controllers/api/v1/schemas"
    root_path + "/#{controller_name}/#{action_name}.json"
  end
end
