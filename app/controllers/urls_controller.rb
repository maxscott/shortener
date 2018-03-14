class UrlsController < ApplicationController
  def index
    @urls = Url.all
    @url = Url.new
  end

  def show
    @url = Url.find_by_short_url(params[:short_url])

    if @url
      redirect_to @url.original_url
    else
      flash.now[:alert] = ["couldn't find #{params[:short_url]}"]
      render :index
    end
  end

  def destroy
    @url = Url.find(params[:id])
    @url.destroy!
    flash.now[:alert] = ["removed #{@url[:id]} : #{@url[:short_url]} --> #{@url[:original_url]}"]
    render :index
  end

  def create
    @url = Url.new(url_params)

    if @url.save
      #flash.now[:alert] = ["created at #{request.host}/#{@url.short_url}"]
      redirect_to root_path
    else
      @urls = Url.all
      flash.now[:alert] = @url.errors.messages
      render :index
    end
  end

  private

    def url_params
      params.require(:url).permit(:original_url)
    end
end
