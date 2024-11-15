# frozen_string_literal: true

require 'test_helper'

class GraphControllerTest < ActionDispatch::IntegrationTest
  test 'should get year' do
        get graph_year_url
        assert_response :success
  end
end
