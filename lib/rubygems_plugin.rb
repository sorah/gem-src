require 'rubygems'

Gem.post_install do |installer|
  clone_dir = ENV['GEMSRC_CLONE_ROOT'] ? "#{ENV['GEMSRC_CLONE_ROOT']}/#{installer.spec.name}" : "#{installer.gem_dir}/src"

  if (repo = installer.spec.homepage) && !repo.empty? && !File.exists?(clone_dir)
    if repo =~ /\Ahttps?:\/\/([^.]+)\.github.com\/(.+)/
      repo = if $1 == 'www'
        "https://github.com/#{$2}"
      elsif $1 == 'wiki'
        # https://wiki.github.com/foo/bar => https://github.com/foo/bar
        "https://github.com/#{$2}"
      else
        # https://foo.github.com/bar => https://github.com/foo/bar
        "https://github.com/#{$1}/#{$2}"
      end
    end

    if !`git ls-remote #{repo} 2> /dev/null`.empty?
      `git clone #{repo} #{clone_dir}`
    end
  end
end
