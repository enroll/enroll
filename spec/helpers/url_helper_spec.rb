require 'spec_helper'

describe UrlHelper do
  include UrlHelper

  let(:course) { create(:course) }

  before(:each) do
    stubs(:request).returns(OpenStruct.new(subdomain: course.url, domain: 'enroll.dev', port_string: ':5000'))
  end

  describe 'with_subdomain' do
    it 'returns a formatted subdomain string' do
      with_subdomain('superawesome').should == 'superawesome.enroll.dev:5000'
    end
  end

  describe 'url_for' do
    it 'supports a subdomain option' do
      url = url_for(controller: 'courses', action: 'show', id: course.to_param, subdomain: course.url)
      url.should == "http://#{course.url}.enroll.dev/courses/#{course.id}"
    end
  end

  describe 'current_course' do
    it 'retrieves a course by url from the subdomain' do
      current_course.should == course
    end

    it 'returns nil if the named course does not exist' do
      stubs(:request).returns(OpenStruct.new(subdomain: 'nothingtoseehere'))
      current_course.should be_nil
    end
  end
end
