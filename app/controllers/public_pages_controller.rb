class PublicPagesController < ApplicationController
  skip_before_action :require_login

  def privacy; end

  def delete_account; end
end
