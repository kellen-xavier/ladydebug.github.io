# frozen_string_literal: true

require 'date'
require 'digest'
require 'fileutils'
require 'json'
require 'open3'
require 'pathname'
require 'uri'
require 'yaml'

module PostLayout
  ROOT = File.expand_path('../..', __dir__)
  POSTS_ROOT = File.join(ROOT, 'content/docs')
  MONTHS = %w[janeiro fevereiro marco abril maio junho julho agosto setembro outubro novembro dezembro].freeze
  IMAGE = /(!\[[^\]\n]*\]\()(<[^>]+>|[^\s)]+)([^\n)]*\))/
  Record = Struct.new(:path, :metadata, :header, :body, keyword_init: true)

  module_function

  def slugify(text)
    text.unicode_normalize(:nfkd).encode('ASCII', invalid: :replace, undef: :replace, replace: '').downcase.gsub(/[^a-z0-9]+/, '-').gsub(/\A-|-\z/, '')
  end

  def date_of(metadata)
    Date.iso8601(metadata.fetch('date').to_s[0, 10])
  end

  def month_relative_path(metadata)
    date = date_of(metadata)
    File.join(date.year.to_s, MONTHS.fetch(date.month - 1))
  end

  def post_relative_path(metadata, source)
    stem = File.basename(source).sub(/(?:\.en)?\.md\z/, '')
    stem = metadata['slug'] || File.basename(File.dirname(source)) if stem == 'index'
    stem = slugify(stem)
    raise ArgumentError, "Nome de post inválido: #{source}" if stem.empty?
    extension = source.end_with?('.en.md') ? '.en.md' : '.md'
    File.join(month_relative_path(metadata), date_of(metadata).strftime('%d-%m'), stem + extension)
  end

  def read_post(path)
    match = File.read(path).match(/\A---\r?\n(.*?)\r?\n---\r?\n(.*)\z/m)
    raise ArgumentError, "Front matter inválido: #{path}" unless match
    metadata = YAML.safe_load(match[1], permitted_classes: [Date, Time])
    date_of(metadata)
    Record.new(path: path, metadata: metadata, header: match[1], body: match[2])
  end

  def posts(root)
    Dir.glob(File.join(root, '**/*.md')).reject { |path| File.basename(path).start_with?('_index') }.map { |path| read_post(path) }
  end

  def legacy_url(relative, metadata)
    return metadata['url'] if metadata['url']
    parts = relative.sub(/(?:\.en)?\.md\z/, '').split('/')
    parts.pop if parts.last == 'index'
    parts[-1] = metadata['slug'] if metadata['slug']
    URI::DEFAULT_PARSER.escape("#{relative.end_with?('.en.md') ? '/en' : ''}/docs/#{parts.join('/')}/")
  end

  def ensure_images(month)
    directory = File.join(month, 'images')
    FileUtils.mkdir_p(directory)
    FileUtils.touch(File.join(directory, '.gitkeep')) if Dir.empty?(directory)
  end

  def validate!(root = POSTS_ROOT)
    errors = posts(root).filter_map do |post|
      relative = Pathname.new(post.path).relative_path_from(Pathname.new(root)).to_s
      relative unless relative == post_relative_path(post.metadata, post.path)
    end
    Dir.glob(File.join(root, '**/*')).select { |path| File.file?(path) && !path.end_with?('.md') }.each do |path|
      relative = Pathname.new(path).relative_path_from(Pathname.new(root)).to_s
      errors << relative unless relative.match?(%r{\A\d{4}/(?:#{MONTHS.join('|')})/images/[^/]+\z})
    end
    raise ArgumentError, "Estrutura fora do padrão:\n#{errors.join("\n")}" unless errors.empty?
    true
  end

  class Migration
    def initialize(posts_root: POSTS_ROOT, repo_root: ROOT)
      @root, @repo = posts_root, repo_root
    end

    def relative(path)
      Pathname.new(path).relative_path_from(Pathname.new(@root)).to_s
    end

    # Reconhece também arquivos movidos manualmente sem alterar seu conteúdo.
    def original_paths
      out, _, status = Open3.capture3('git', '-C', @repo, 'ls-tree', '-rz', 'HEAD', '--', 'content/docs')
      return {} unless status.success?
      out.split("\0").each_with_object({}) do |entry, result|
        info, name = entry.split("\t", 2)
        next unless name&.end_with?('.md')
        (result[info.split.last] ||= []) << name.delete_prefix('content/docs/')
      end
    end

    def resolve_asset(post, destination)
      return if destination.match?(%r{\A(?:[a-z]+:|//)}i)
      path = URI::DEFAULT_PARSER.unescape(destination.delete_prefix('<').delete_suffix('>').split(/[?#]/, 2).first)
      candidates = [File.expand_path(path, File.dirname(post.path))]
      candidates << File.join(@repo, path.delete_prefix('/')) if path.start_with?('/content/')
      candidates << File.join(@repo, 'content', path.delete_prefix('/')) if path.start_with?('/docs/')
      candidates << File.expand_path(path, File.dirname(File.join(@root, @old_relative.fetch(post.path))))
      candidates << File.join(File.dirname(post.path), File.basename(path))
      candidates.find { |candidate| @assets.include?(candidate) }
    end

    def plan
      records = PostLayout.posts(@root)
      originals = original_paths
      @old_relative = records.to_h do |post|
        bytes = File.binread(post.path)
        candidates = originals.fetch(Digest::SHA1.hexdigest("blob #{bytes.bytesize}\0" + bytes), [])
        current = relative(post.path)
        [post.path, candidates.include?(current) || candidates.empty? ? current : candidates.first]
      end
      targets = records.to_h { |post| [post.path, File.join(@root, PostLayout.post_relative_path(post.metadata, post.path))] }
      raise ArgumentError, 'Dois posts possuem o mesmo destino; ajuste seus nomes antes de migrar.' unless targets.values.uniq.length == targets.length
      @assets = Dir.glob(File.join(@root, '**/*')).select { |p| File.file?(p) && !p.end_with?('.md') }
      owners = Hash.new { |hash, key| hash[key] = [] }
      records.each do |post|
        post.body.scan(IMAGE).each do |_, destination, _|
          asset = resolve_asset(post, destination)
          owners[asset] << post if asset
        end
      end
      image_targets = {}
      used = {}
      @assets.each do |asset|
        users = owners[asset]
        if users.empty?
          users = [records.max_by do |post|
            a, b = File.dirname(post.path).split('/'), asset.split('/')
            a.zip(b).take_while { |x, y| x == y }.length
          end].compact
        end
        raise ArgumentError, "Imagem sem mês de referência: #{asset}" if users.empty?
        image_targets[asset] = {}
        users.group_by { |post| PostLayout.month_relative_path(post.metadata) }.each do |month, posts|
          stem = File.basename(targets.fetch(posts.first.path)).sub(/(?:\.en)?\.md\z/, '')
          name = if relative(asset).match?(%r{\A\d{4}/(?:\d{2}-)?(?:#{MONTHS.join('|')})/images/[^/]+\z})
                   File.basename(asset)
                 else
                   "#{stem}--#{PostLayout.slugify(File.basename(asset, '.*'))}#{File.extname(asset).downcase}"
                 end
          directory = File.join(@root, month, 'images')
          target = File.dirname(asset) == directory ? asset : File.join(directory, name)
          suffix = 1
          while used.key?(target) && used[target] != asset
            suffix += 1
            target = File.join(directory, "#{File.basename(name, '.*')}-#{suffix}#{File.extname(name)}")
          end
          used[target] = asset
          image_targets[asset][month] = target
        end
      end
      aliases = targets.merge(@old_relative.to_h { |source, old| [File.join(@root, old), targets.fetch(source)] })
      posts = records.map do |post|
        month = PostLayout.month_relative_path(post.metadata)
        body = post.body.gsub(IMAGE) do
          opening, destination, closing = Regexp.last_match.captures
          asset = resolve_asset(post, destination)
          if asset
            suffix = destination.delete_prefix('<').delete_suffix('>')[/[?#].*\z/] || ''
            "#{opening}../images/#{File.basename(image_targets.fetch(asset).fetch(month))}#{suffix}#{closing}"
          else
            "#{opening}#{destination}#{closing}"
          end
        end
        body = body.gsub(/(\{\{<\s*relref\s+")([^\"]+)("\s*>\}\})/) do
          opening, source, closing = Regexp.last_match.captures
          target = aliases[File.join(@repo, 'content', source.delete_prefix('/'))]
          "#{opening}#{target ? '/docs/' + relative(target) : source}#{closing}"
        end
        header = post.header
        if targets[post.path] != post.path && !post.metadata['url']
          header += "\nurl: #{JSON.generate(PostLayout.legacy_url(@old_relative.fetch(post.path), post.metadata))}"
        end
        { source: post.path, target: targets.fetch(post.path), content: "---\n#{header}\n---\n#{body}" }
      end
      images = image_targets.flat_map { |source, months| months.values.uniq.map { |target| { source: source, target: target } } }
      (posts + images).each do |entry|
        raise ArgumentError, "Destino já existe: #{entry[:target]}" if entry[:source] != entry[:target] && File.exist?(entry[:target])
      end
      { posts: posts, images: images }
    end

    def apply!
      changes = plan
      created = []
      updated = {}
      begin
        (changes[:images] + changes[:posts]).each do |entry|
          next if entry[:source] == entry[:target] && !entry.key?(:content)
          bytes = entry[:content] || File.binread(entry[:source])
          next if File.file?(entry[:target]) && File.binread(entry[:target]) == bytes
          FileUtils.mkdir_p(File.dirname(entry[:target]))
          if entry[:source] == entry[:target]
            updated[entry[:target]] = File.binread(entry[:target])
            File.binwrite(entry[:target], bytes)
          else
            File.open(entry[:target], File::WRONLY | File::CREAT | File::EXCL) { |file| file.write(bytes) }
            created << entry[:target]
          end
        end
      rescue StandardError
        created.each { |path| File.unlink(path) }
        updated.each { |path, bytes| File.binwrite(path, bytes) }
        raise
      end
      entries = changes[:posts] + changes[:images]
      destinations = entries.map { |entry| entry[:target] }
      entries.map { |entry| entry[:source] }.uniq.each { |path| File.unlink(path) unless destinations.include?(path) }
      PostLayout.posts(@root).each { |post| PostLayout.ensure_images(File.join(@root, PostLayout.month_relative_path(post.metadata))) }
      Dir.glob(File.join(@root, '[0-9][0-9][0-9][0-9]/[0-9][0-9]-*/images/.gitkeep')).each do |placeholder|
        File.unlink(placeholder) if File.zero?(placeholder) && Dir.children(File.dirname(placeholder)) == ['.gitkeep']
      end
      Dir.glob(File.join(@root, '**/*')).select { |p| File.directory?(p) }.sort_by(&:length).reverse_each { |p| Dir.rmdir(p) if Dir.empty?(p) }
      changes.transform_values(&:length)
    end
  end
end
