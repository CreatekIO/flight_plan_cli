module FlightPlanCli
  class << self
    def version
      File.open(version_filepath, &:readline).strip
    end

    private

    def version_filepath
      File.join(__dir__, '../../VERSION')
    end
  end
end
