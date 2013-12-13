module SocialHelper
  NETWORKS = {
    :facebook => "https://www.facebook.com/sharer/sharer.php?s=100&u=:url",
    :twitter => "https://twitter.com/intent/tweet?text=:text%20:url"
  }

  def share_button(network, target_url, label, text = '', cls = '')
    url = NETWORKS[network]
    return '' unless url
    url.sub!(':url', CGI.escape(target_url))
       .sub!(':text', CGI.escape(text))
    content_tag :a, label,
      :href => '#',
      :class => "social #{network} #{cls}",
      :onclick => "window.open('#{url}', '#{network}-share-dialog', 'width=626,height=436'); return false;".html_safe
  end
end