describe CourseSchedule do
  it { should validate_presence_of(:course_id) }
  it { should validate_presence_of(:date) }
  # it { should validate_presence_of(:starts_at) }
  # it { should validate_presence_of(:ends_at) }

  let(:schedule) { CourseSchedule.new(date: Date.today) }

  describe "#starts_at=, #ends_at=" do
    it "converts time string to seconds sicne midnight" do
      schedule.starts_at = "9:00am"
      schedule.ends_at = "5:00PM"

      schedule[:starts_at].should == 32400
      schedule[:ends_at].should == 61200
    end
  end

  describe "#starts_at" do
    it "converts seconds from midnight to time string" do
      schedule[:starts_at] = 32460
      schedule[:ends_at] = 61320

      schedule.starts_at.should == "09:01am"
      schedule.ends_at.should == "05:02pm"
    end
  end

  describe "#starts_at_time, #ends_at_time" do
    it "returns time object" do
      schedule[:starts_at] = 32460
      schedule[:ends_at] = 61320

      schedule.starts_at_time.to_date.should == Date.today
      schedule.starts_at_time.hour.should == 9
      schedule.starts_at_time.min.should == 1

      schedule.ends_at_time.hour.should == 17
      schedule.ends_at_time.min.should == 2
    end
  end
end