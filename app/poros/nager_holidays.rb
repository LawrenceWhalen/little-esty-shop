class NagerHolidays

  def self.three_holidays
    immenent_holidays = NagerService.upcoming_holidays
    holidays_third = immenent_holidays[0..2]
    if !holidays_third[0].keys.include?(:message)
      holidays_third[0..2].map do |holiday|
        if holiday[:name] == 'Columbus Day'
          holiday[:name] = 'First Peoples Day'
        end
        {name: holiday[:name], date: holiday[:date]}
      end
    else
      "Unavailable: API rate limit exceeded."
    end
  end
end
