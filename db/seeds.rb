# $redis.rpush("dl", "vvdpzz")
# count = $redis.incr("count")

class String
  def red; colorize(self, "\e[1m\e[31m"); end
  def green; colorize(self, "\e[1m\e[32m"); end
  def dark_green; colorize(self, "\e[32m"); end
  def yellow; colorize(self, "\e[1m\e[33m"); end
  def blue; colorize(self, "\e[1m\e[34m"); end
  def dark_blue; colorize(self, "\e[34m"); end
  def pur; colorize(self, "\e[1m\e[35m"); end
  def colorize(text, color_code)  "#{color_code}#{text}\e[0m" end
end

github = Octokit::Client.new

while $redis.llen('dl') > 0 do
  count = $redis.incr("count")
  
  puts "count = #{count} & list length = #{$redis.llen('dl')}"
  
  login = $redis.lpop("dl")
  
  if not $redis.sismember("set", login)
    $redis.sadd("set", login)
    
    followers = []
    following = []
    repos = []
    cols = []
    all_repos = {}
    langs = {}
    threads = []
    
    all_repos = github.repos(login).collect{|r| {:fork => r.fork, :name => r.name}}
    
    threads << Thread.new { Thread.current[:name]  = "Fetching followers"; followers = github.followers(login) }
    threads << Thread.new { Thread.current[:name]  = "Fetching following"; following = github.following(login) }
    
    all_repos.each do |repo|
      if not repo[:fork]
        threads << Thread.new { Thread.current[:name]  = "Fetching #{repo[:name]}'s languages"; langs.merge! github.languages("#{login}/#{repo[:name]}") }
        threads << Thread.new { Thread.current[:name]  = "Fetching #{repo[:name]}'s collaborators"; cols += github.collaborators("#{login}/#{repo[:name]}").map(&:login) }
      end
      repos.push repo[:name]
    end
    
    threads.each do |th|
      puts "#{th.inspect}: #{th[:name]}"
      th.join
    end
    
    cols.uniq!
    cols.delete(login) if cols
    
    Octodata.create(login: login, data_type: 1, content: followers.join(", "))
    Octodata.create(login: login, data_type: 2, content: following.join(", "))
    Octodata.create(login: login, data_type: 3, content: langs.keys.join(", "))
    Octodata.create(login: login, data_type: 4, content: repos.join(", "))
    Octodata.create(login: login, data_type: 5, content: cols.join(", "))
    
    # write into redis
    # followers.each  {|user|  $redis.sadd("user:#{login}:fers", user)}
    # following.each  {|user|  $redis.sadd("user:#{login}:fing", user)}
    # langs.keys.each {|lang|  $redis.sadd("user:#{login}:lang", lang)}
    # repos.each      {|repo|  $redis.sadd("user:#{login}:repo", repo)}
    # cols.uniq.each  {|user|  $redis.sadd("user:#{login}:cols", user)}
    
    # remove self from collaborators
    # $redis.srem("user:#{login}:cols", login)
    
    # take nodes to dl
    (followers + following).uniq.each do |user|
      $redis.rpush("dl", user) if not $redis.sismember("set", user)
    end
    
    printf "%-60s %s\n", login.pur, "[ DONE ]".green
  end
end
