describe CourseSchedule do
  it { should validate_presence_of(:course_id) }
  it { should validate_presence_of(:date) }
  # it { should validate_presence_of(:starts_at) }
  # it { should validate_presence_of(:ends_at) }
end