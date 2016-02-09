module FormatDateHelper
  def local_formatted_time(datetime)
    datetime.in_time_zone('Eastern Time (US & Canada)').strftime("%A %e %B, %H:%M")
  end
end
