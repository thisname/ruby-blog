# encoding: utf-8
module ApplicationHelper

  def meta_content
    tag_name, page_number = nil
    case request.fullpath
      when /categories\/.{1,}/
        request.fullpath.scan(/\/categories\/(.+)(\?page=)?(\d+)?/) do
          tag_name = CGI::unescape($1.to_s)
          page_number = $3 || 1
        end
        { :title => "Категория: #{tag_name}, страница #{page_number}", :keywords => tag_name.to_s, :description => "Все темы по категории #{tag_name}" }
      when /^\/(\?page=)?(\d+)?$/
        request.fullpath.scan(/^\/(\?page=)?(\d+)?$/) do
          page_number = $2 || 1
        end
        { :title => "RubyBlog, страница #{page_number}", :keywords => @posts.map{|p| p.tags.map(&:name)}.flatten.uniq.join(" "), :description => "Блог, созданый и посвященный Ruby on Rails." }
      when /\/post\/\d+/
        { :title => @post.subject, :keywords => @post.tags.map(&:name).join(" "), :description => "#{@post.subject}. #{Nokogiri::HTML.fragment(truncate_html(@post)).content}" }
      else
        { :title => "RubyBlog", :keywords => @tags.map(&:name).join(" "), :description => "Блог, созданый и посвященный Ruby on Rails." }
    end
  end

end
