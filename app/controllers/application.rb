# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base

  def initialize(testing=false)
    super()
    self.class.layout(nil) if testing
  end

  def url_for(options, *params)
    if options.include? :model then
      model = options.delete(:model)
      defaults = {
        :action => 'show',
        :id => model.id,
        :controller => Inflector.pluralize(model.class.name.downcase),
      }
      defaults = defaults.merge model.url_params if model.respond_to? :url_params
      options = defaults.merge options
    end
    return super(options, *params)
  end

  def validate_params expected
    # TODO validate_params :url => //, :label => //
  end
end
