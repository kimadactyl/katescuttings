class FeedsController < ApplicationController
  def index
    @blogs = Blog.teasers.includes(:attachments, :rich_text_body).limit(20)

    respond_to do |format|
      format.rss
    end
  end
end
