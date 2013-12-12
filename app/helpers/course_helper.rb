include NavigationHelper
include FormatHelper

module CourseHelper
  def reservations_needed(course)
    return "?" unless course.min_seats

    needed = course.min_seats - course.reservations.count
    needed > 0 ? needed : 0
  end

  def days_until_start(course)
    return "?" unless course.starts_at

    days_until = (course.starts_at.to_date - Date.today).numerator
    days_until > 0 ? days_until : 0
  end

  def percentage_to_full(course)
    return 0 unless course.max_seats
    (course.reservations.count.to_f / course.max_seats) * 100
  end

  def percentage_goal(course)
    return 0 unless course.max_seats && course.min_seats
    (course.min_seats.to_f / course.max_seats) * 100
  end

  def course_reservation_link(course, options={})
    link_to "Enroll - #{course_price_text(course)}",
      new_course_reservation_path(course),
      :class => options[:class] ||= 'btn btn-primary btn-large reserve'
  end

  def course_price_text(course)
    if course.paid?
      number_to_currency(price_in_dollars(course.price_per_seat_in_cents))
    else
      "FREE"
    end
  end

  def facebook_og_meta_tags(course)
    meta_tags = []
    meta_tags << %Q[<meta property="og:title" content="#{course.name}" />]
    meta_tags << %Q[<meta property="og:description" content="#{course.tagline}" />]
    meta_tags << %Q[<meta property="og:url" content="#{course_short_url(course)}" />]
    meta_tags << %Q[<meta property="og:image" content="/assets/images/enroll-io-logo.png" />]
    meta_tags.join("\n").html_safe
  end
end
