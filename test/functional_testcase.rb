require 'test/unit'

def Object.path2class(klassname)
  klassname.split('::').inject(Object) { |k,n| k.const_get n }
end

module FunctionalTestAssertions

  ##
  # Asserts that the response is one of the following types:
  # 
  # * <tt>:success</tt>: Status code was 200
  # * <tt>:redirect</tt>: Status code was in the 300-399 range
  # * <tt>:missing</tt>: Status code was 404
  # * <tt>:error</tt>:  Status code was in the 500-599 range
  #
  # You can also pass an explicit status code number as the type, like
  # assert_response(501)

  def assert_response(type, message = nil)
#    clean_backtrace do
      case type
      when :success, :missing, :redirect, :error then
        assert_block { @response.send "#{type}?" }
      when Fixnum then
        assert_block("") { @response.response_code == type }
      else
        flunk build_message(message, "Expected response to be <?>, but was <?>",
                            type, @response.response_code)
      end
#    end
  end

  ##
  # Assert that the redirection options passed in match those of the redirect
  # called in the latest action. This match can be partial, such at
  # assert_redirected_to(:controller => "weblog") will also match the
  # redirection of redirect_to(:controller => "weblog", :action => "show") and
  # so on.

  def assert_redirected_to(options = {}, message=nil)
#    clean_backtrace do
      assert_response :redirect, message

      case options
      when String then
        msg = build_message(message,
                            "expected a redirect to\n<?> found one to\n<?>",
                            options, @response.redirect_url)
        url_regexp = %r{^(\w+://.*?(/|$|\?))(.*)$}
        eurl, epath, url, path = [options, @response.redirect_url].map do |url|
          u, p = (url_regexp =~ url) ? [$1, $3] : [nil, url]
          [u, (p[0..0] == '/') ? p : '/' + p]
        end.flatten

        assert_block(msg) { eurl == url } if eurl and url
        assert_block(msg) { epath == path } if epath and path
      else
        msg = build_message(message,
                            "expected a redirect to\n<?> found one to\n<?>",
                            options,
                            @response.redirected_to || @response.redirect_url)

        assert_block msg do
          case options
          when Symbol then
            @response.redirected_to == options
          else
            options.keys.all? do |k|
              if k == :controller then
                options[k] == ActionController::Routing.controller_relative_to(@response.redirected_to[k], @controller.class.controller_path)
              else
                options[k] == (@response.redirected_to[k].respond_to?(:to_param) ? @response.redirected_to[k].to_param : @response.redirected_to[k] unless @response.redirected_to[k].nil?)
              end
            end
          end
        end
      end
#    end # DOOD
  end

end

class FunctionalTestCase < Test::Unit::TestCase

  include FunctionalTestAssertions

  def setup
    self.class.name =~ /\ATest(.*)\Z/
    return unless $1
    controller_klass = Object.path2class $1
    @controller = controller_klass.new
    controller_klass.send(:define_method, :rescue_action) { |e| raise e }
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    @deliveries = []
    ActionMailer::Base.deliveries = @deliveries
  end

  def test_stupid # :nodoc:
  end

  ##
  # Asserts that there is an error on +field+ of type +type+.

  def assert_error_on(field, type)
    error_message = ActiveRecord::Errors.default_error_messages[type]
    error_regex = /^#{field} #{error_message}/i
    assert_tag :tag => 'div', :attributes => { :class => 'errorExplanation' },
                  :descendant => { :tag => 'li', :content => error_regex }
  end

  ##
  # Asserts that a form with +form_action+ has an input element of +type+ with
  # a name of "+model+[+column+]" and has a label with a for attribute of
  # "+model+_+column+".

  def assert_field(form_action, type, model, column)
    assert_input form_action, type, model, column
    assert_label form_action, model, column
  end

  ##
  # Asserts that +key+ of flash has +content+

  def assert_flash(key, content)
    assert flash.include?(key), "#{key.inspect} missing from flash"
    assert_equal content, flash[key],
                 "Incorrect content in flash[#{key.inspect}]"
  end

  ##
  # Asserts that a form with +form_action+ has an input element of +type+ with
  # a name of "+model+[+column+]".

  def assert_input(form_action, type, model, column)
    assert_tag_in_form form_action, :tag => 'input', :attributes => {
                                      :type => type.to_s,
                                      :name => "#{model}[#{column}]" }
  end

  ##
  # Asserts that a form with +form_action+ has a label with a for attribute of
  # "+model+_+column+".

  def assert_label(form_action, model, column)
    assert_tag_in_form form_action, :tag => 'label', :attributes => {
                                      :for => "#{model}_#{column}" }
  end

  ##
  # Asserts that there is an anchor tag with an href of +href+ and optionally
  # has +content+.

  def assert_links_to(href, content = nil)
    assert_tag links_to_options_for(href, content)
  end

  ##
  # Denies that there is an anchor tag with an href of +href+ and optionally
  # +content+.

  def deny_links_to(href, content = nil)
    assert_no_tag links_to_options_for(href, content)
  end

  ##
  # Asserts that there is a form using the 'POST' method whose action is
  # +form_action+.

  def assert_post_form(form_action)
    assert_tag :tag => 'form', :attributes => { :action => form_action,
                 :method => 'post' }
  end

  ##
  # Asserts that a form with +form_action+ has a select element with a name of
  # "+model+[+column+]" and has +children+ children.

  def assert_select(form_action, model, column, children)
    assert_tag_in_form form_action, :tag => 'select', :attributes => {
                                        :name => "#{model}[#{column}]" },
                                      :children => { :count => children }
  end

  ##
  # Asserts that a form with +form_action+ has a submit element with a value
  # of +value+.

  def assert_submit(form_action, value)
    assert_tag_in_form form_action, :tag => 'input', :attributes => {
                                      :type => "submit", :value => value }
  end

  ##
  # Asserts that a form with +form_action+ has a descendent that matches
  # +options+.

  def assert_tag_in_form(form_action, options)
    assert_tag :tag => 'form', :attributes => { :action => form_action },
                 :descendant => options
  end

  ##
  # Asserts that the title element and an h1 element have +title+ as their
  # content.

  def assert_title(title)
    assert_tag :tag => 'title', :content => title
    assert_tag :tag => 'h1',    :content => title
  end

  ##
  # Sets up the session so that +player+ is logged-in.

  def util_set_user(player)
    @request.session[:username] = player.username
  end

  protected

  def links_to_options_for(href, content = nil)
    options = { :tag => 'a', :attributes => { :href => href } }
    options[:content] = content unless content.nil?
    return options
  end

end

module Test::Unit::Assertions

  def deny(boolean, message = nil)
    _wrap_assertion do
      assert_block(build_message(message, "<?> is not false or nil.", boolean)) { not boolean }
    end
  end

  alias deny_equal assert_not_equal

end

