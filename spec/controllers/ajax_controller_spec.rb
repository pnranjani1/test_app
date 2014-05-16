require 'spec_helper'

describe AjaxController do

  describe "GET 'customers'" do
    it "returns http success" do
      get 'customers'
      response.should be_success
    end
  end

end
