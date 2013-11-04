module SocialHelper
  NETWORKS = {
    :facebook => "https://www.facebook.com/sharer/sharer.php?s=100&u=:url",
    :twitter => "https://twitter.com/intent/tweet?text=:text&url=:url"
  }

  def share_button(network, target_url, label, text = '')
    url = NETWORKS[network] or return ''
      .sub(':url', CGI.escape(target_url))
      .sub(':text', CGI.escape(text))
    content_tag :a, label,
      :href => '#',
      :onclick => "window.open('#{url}', '#{network}-share-dialog', 'width=626,height=436')".html_safe
  end
end