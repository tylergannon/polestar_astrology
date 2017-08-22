class ChartsController < ApplicationController
  load_and_authorize_resource :chart, except: [:create, :index, :update], find_by: :slug
  respond_to :json

  def index
    @charts = Rails.cache.fetch "charts-#{current_member.cache_key}" do
      current_member.charts
    end

    @cache_key = "#{@charts.cache_key}/#{current_member.cache_key}/#{params[:search] || 'none'}"

    if params[:search]
      regexp = Regexp.new params[:search], 'i'
      @charts = @charts.select{|t| t.search_text =~ regexp}
    end

      render :index
  end

  def destroy
    @chart.destroy
    redirect_to charts_path
  end

  def show
    @year = 'base'
    if params[:year]
      @year = params[:year]
      ming_branch = Branch.find_by_english_name(@year)

      @chart.palaces.sort{|t, u| t.location.ordinal <=> u.location.ordinal}.each_with_index do |chart_palace, i|
        chart_palace.palace = Palace.find_by_ordinal(((chart_palace.palace.id + ming_branch.ordinal - @chart.ming_id - 1) % 12) + 1)
      end
    end

    respond_to do |format|
      format.html {
        render :show
      }
      format.pdf {
        pdf = ChartPdf.new(@chart, view_context)
        send_data pdf.render, filename: pdf.file_name, type: pdf.mime_type, disposition: 'inline'
      }
    end
  end

  def update
    @chart = current_member.charts.friendly.find(params[:id])
    @chart.attributes = chart_params.except(*DATE_PARAMS)
    @chart.dob = replace_date_parts_with_date_time
    @chart.save!
    redirect_to @chart
  end

  DATE_PARAMS = [ :dob_year, :dob_month, :dob_day, :dob_time]

  def create
    @chart = current_member.charts.new chart_params.except(*DATE_PARAMS)
    @chart.dob = replace_date_parts_with_date_time
    @chart.save
    redirect_to @chart
  end

  def replace_date_parts_with_date_time
    Time.use_zone @chart.time_zone do
      values = chart_params.slice(*DATE_PARAMS).values
      puts values.inspect
      return Time.zone.parse [values[0..2].join('/'), values.last].join(' ')
    end
  end

  def chart_params
    params.require(:chart).permit(:first_name, :last_name, :yin_yang, :time_zone, *DATE_PARAMS)
  end

  def date_param
    params.require(:chart).permit("year", "month(2i)", "day", "time")
  end
end
