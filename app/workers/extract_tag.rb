class ExtractTag
  @queue = :extract_tag
  
  def self.perform(post_id)
    post = Post.select("id, text").find_by_id post_id
    post.extract_hashtags(post.text).each do |tag_name|
      tag = Tag.find_or_create_by_name tag_name
      PostTag.find_or_create_by_post_id_and_tag_id(post.id, tag.id)
    end
  end
end
